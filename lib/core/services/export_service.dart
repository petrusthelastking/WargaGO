import 'dart:io';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class ExportService {
  static final currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  static final dateFormat = DateFormat('dd/MM/yyyy');

  /// Request storage permission
  static Future<bool> _requestPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
    return true; // iOS doesn't need explicit permission for app documents
  }

  /// Export to Excel
  static Future<File?> exportToExcel(List<Map<String, dynamic>> data, String filename) async {
    try {
      // Request permission
      final hasPermission = await _requestPermission();
      if (!hasPermission) {
        debugPrint('❌ Storage permission denied');
        return null;
      }

      // Create workbook
      final xlsio.Workbook workbook = xlsio.Workbook();
      final xlsio.Worksheet sheet = workbook.worksheets[0];
      sheet.name = 'Laporan Pemasukan';

      // Header style
      final xlsio.Style headerStyle = workbook.styles.add('HeaderStyle');
      headerStyle.bold = true;
      headerStyle.backColor = '#2988EA';
      headerStyle.fontColor = '#FFFFFF';
      headerStyle.hAlign = xlsio.HAlignType.center;
      headerStyle.vAlign = xlsio.VAlignType.center;

      // Headers
      final headers = ['No', 'Tanggal', 'Nama', 'Kategori', 'Nominal', 'Penerima', 'Deskripsi', 'Status'];
      for (int i = 0; i < headers.length; i++) {
        sheet.getRangeByIndex(1, i + 1).setText(headers[i]);
        sheet.getRangeByIndex(1, i + 1).cellStyle = headerStyle;
      }

      // Data rows
      double total = 0;
      int jenisIuranCount = 0;
      int pemasukanLainCount = 0;
      double totalJenisIuran = 0;
      double totalPemasukanLain = 0;

      for (int i = 0; i < data.length; i++) {
        final item = data[i];
        final row = i + 2; // Start from row 2

        // Get nominal value
        final nominal = (item['nominal'] is num)
            ? (item['nominal'] as num).toDouble()
            : 0.0;
        total += nominal;

        // Count by category
        final category = item['category'] ?? '';
        if (category == 'Iuran') {
          jenisIuranCount++;
          totalJenisIuran += nominal;
        } else {
          pemasukanLainCount++;
          totalPemasukanLain += nominal;
        }

        sheet.getRangeByIndex(row, 1).setNumber(i + 1);
        sheet.getRangeByIndex(row, 2).setText(item['tanggal'] ?? '-');
        sheet.getRangeByIndex(row, 3).setText(item['name'] ?? '-');
        sheet.getRangeByIndex(row, 4).setText(item['category'] ?? '-');
        sheet.getRangeByIndex(row, 5).setText(item['nominalFormatted'] ?? currencyFormat.format(nominal));
        sheet.getRangeByIndex(row, 6).setText(item['penerima'] ?? '-');
        sheet.getRangeByIndex(row, 7).setText(item['deskripsi'] ?? '-');
        sheet.getRangeByIndex(row, 8).setText(item['status'] ?? '-');
      }

      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('📊 Excel Export Service - Data Verification:');
      debugPrint('   📦 Total items received: ${data.length}');
      debugPrint('   📊 Jenis Iuran: $jenisIuranCount items = ${currencyFormat.format(totalJenisIuran)}');
      debugPrint('   📊 Pemasukan Lain: $pemasukanLainCount items = ${currencyFormat.format(totalPemasukanLain)}');
      debugPrint('   💰 TOTAL CALCULATED: ${currencyFormat.format(total)}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      // Add total row
      final totalRow = data.length + 2;
      sheet.getRangeByIndex(totalRow, 4).setText('TOTAL:');
      sheet.getRangeByIndex(totalRow, 4).cellStyle.bold = true;
      sheet.getRangeByIndex(totalRow, 5).setText(currencyFormat.format(total));
      sheet.getRangeByIndex(totalRow, 5).cellStyle.bold = true;

      // Auto-fit columns
      for (int i = 1; i <= headers.length; i++) {
        sheet.autoFitColumn(i);
      }

      // Save file
      final List<int> bytes = workbook.saveAsStream();
      workbook.dispose();

      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/$filename.xlsx';
      final file = File(path);
      await file.writeAsBytes(bytes, flush: true);

      debugPrint('✅ Excel exported: $path');
      return file;
    } catch (e) {
      debugPrint('❌ Error exporting to Excel: $e');
      return null;
    }
  }

  /// Export to PDF
  static Future<File?> exportToPDF(List<Map<String, dynamic>> data, String filename) async {
    try {
      final pdf = pw.Document();

      // Calculate total from nominal field (as number)
      double total = 0;
      int jenisIuranCount = 0;
      int pemasukanLainCount = 0;
      double totalJenisIuran = 0;
      double totalPemasukanLain = 0;

      for (var item in data) {
        final nominal = (item['nominal'] is num)
            ? (item['nominal'] as num).toDouble()
            : 0.0;
        total += nominal;

        // Count by category
        final category = item['category'] ?? '';
        if (category == 'Iuran') {
          jenisIuranCount++;
          totalJenisIuran += nominal;
        } else {
          pemasukanLainCount++;
          totalPemasukanLain += nominal;
        }
      }

      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('📄 PDF Export Service - Data Verification:');
      debugPrint('   📦 Total items received: ${data.length}');
      debugPrint('   📊 Jenis Iuran: $jenisIuranCount items = ${currencyFormat.format(totalJenisIuran)}');
      debugPrint('   📊 Pemasukan Lain: $pemasukanLainCount items = ${currencyFormat.format(totalPemasukanLain)}');
      debugPrint('   💰 TOTAL CALCULATED: ${currencyFormat.format(total)}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              // Title
              pw.Header(
                level: 0,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'LAPORAN PEMASUKAN',
                      style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Tanggal Cetak: ${DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.now())}',
                      style: const pw.TextStyle(fontSize: 12),
                    ),
                    pw.Divider(thickness: 2),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // Table
              pw.Table.fromTextArray(
                headers: ['No', 'Tanggal', 'Nama', 'Kategori', 'Nominal', 'Status'],
                data: List.generate(data.length, (index) {
                  final item = data[index];
                  final nominal = (item['nominal'] is num)
                      ? (item['nominal'] as num).toDouble()
                      : 0.0;
                  return [
                    '${index + 1}',
                    item['tanggal'] ?? '-',
                    item['name'] ?? '-',
                    item['category'] ?? '-',
                    item['nominalFormatted'] ?? currencyFormat.format(nominal),
                    item['status'] ?? '-',
                  ];
                }),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                cellStyle: const pw.TextStyle(fontSize: 9),
                cellAlignment: pw.Alignment.centerLeft,
                headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
                cellHeight: 30,
              ),

              pw.SizedBox(height: 20),

              // Total
              pw.Container(
                alignment: pw.Alignment.centerRight,
                child: pw.Container(
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.blue50,
                    border: pw.Border.all(color: PdfColors.blue),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Total Pemasukan:', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 4),
                      pw.Text(currencyFormat.format(total), style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            ];
          },
        ),
      );

      // Save file
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/$filename.pdf';
      final file = File(path);
      await file.writeAsBytes(await pdf.save());
      debugPrint('✅ PDF exported: $path');
      return file;
    } catch (e) {
      debugPrint('❌ Error exporting to PDF: $e');
      return null;
    }
  }

  /// Export to CSV
  static Future<File?> exportToCSV(List<Map<String, dynamic>> data, String filename) async {
    try {
      List<List<dynamic>> rows = [];

      // Header
      rows.add([
        'No',
        'Tanggal',
        'Nama',
        'Kategori',
        'Nominal',
        'Penerima',
        'Deskripsi',
        'Status',
      ]);

      // Data rows
      double total = 0;
      for (int i = 0; i < data.length; i++) {
        final item = data[i];
        final nominal = (item['nominal'] is num)
            ? (item['nominal'] as num).toDouble()
            : 0.0;
        total += nominal;

        rows.add([
          i + 1,
          item['tanggal'] ?? '-',
          item['name'] ?? '-',
          item['category'] ?? '-',
          item['nominalFormatted'] ?? currencyFormat.format(nominal),
          item['penerima'] ?? '-',
          item['deskripsi'] ?? '-',
          item['status'] ?? '-',
        ]);
      }

      // Add total row
      rows.add([
        '',
        '',
        '',
        'TOTAL:',
        currencyFormat.format(total),
        '',
        '',
        '',
      ]);

      // Convert to CSV
      String csv = const ListToCsvConverter().convert(rows);

      // Save file
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/$filename.csv';
      final file = File(path);
      await file.writeAsString(csv);
      debugPrint('✅ CSV exported: $path with total: ${currencyFormat.format(total)}');
      return file;
    } catch (e) {
      debugPrint('❌ Error exporting to CSV: $e');
      return null;
    }
  }
}

