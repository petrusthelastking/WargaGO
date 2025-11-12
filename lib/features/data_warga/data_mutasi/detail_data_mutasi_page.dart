import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'edit_data_mutasi_page.dart';

class DetailDataMutasiPage extends StatelessWidget {
  const DetailDataMutasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Detail Data Mutasi",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditDataMutasiPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailField("Nama Lengkap", "Rendha Putra Rahmadya"),
            _buildDetailField("NIK", "3505111512040002"),
            _buildDetailField("Jenis Mutasi", "Mutasi Masuk"),
            _buildDetailField("Tanggal Mutasi", "21/10/2023"),
            _buildDetailField("Alamat Asal/Tujuan", "Surabaya"),
            _buildDetailField("Alasan Mutasi", "Pindah Kerja"),
            _buildDetailField("Status Mutasi", "Selesai"),
            _buildDetailField("Nomor Surat Pengantar", "123/RT/X/2023"),
            _buildDetailField(
              "Keterangan",
              "Mutasi karena pindah tempat kerja ke Malang",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: value,
            readOnly: true,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
            ),
            style: GoogleFonts.poppins(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
