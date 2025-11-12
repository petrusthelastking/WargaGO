import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EditKegiatanPage extends StatefulWidget {
  const EditKegiatanPage({super.key});

  @override
  State<EditKegiatanPage> createState() => _EditKegiatanPageState();
}

class _EditKegiatanPageState extends State<EditKegiatanPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController(
    text: "Gotong Royong",
  );
  final TextEditingController _tanggalController = TextEditingController(
    text: "15/10/2025",
  );
  final TextEditingController _lokasiController = TextEditingController(
    text: "Masjid Komplek",
  );
  final TextEditingController _pjController = TextEditingController(
    text: "Pak Rusdi",
  );
  final TextEditingController _deskripsiController = TextEditingController(
    text: "Membersihkan Masjid kita tercinta ini",
  );

  String? _selectedKategori = 'Komunitas & Sosial';
  DateTime? _selectedDate;

  final List<String> _kategoriOptions = [
    'Komunitas & Sosial',
    'Kebersihan & Keamanan',
    'Keagamaan',
    'Pendidikan',
    'Kesehatan & Olahraga',
    'Lainnya',
  ];

  String? _selectedDocumentFileName = "dokumentasi_lama.jpg";

  @override
  void initState() {
    super.initState();
    try {
      _selectedDate = DateFormat('dd/MM/yyyy').parse(_tanggalController.text);
    } catch (e) {
      _selectedDate = DateTime.now();
      _tanggalController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _tanggalController.dispose();
    _lokasiController.dispose();
    _pjController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _tanggalController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _pickDocument() async {
    setState(() {
      _selectedDocumentFileName = "dokumentasi_baru.pdf";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logika ganti dokumen belum diimplementasikan.'),
      ),
    );
  }

  // Membuat TextFormField dengan gaya Figma
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    int? maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: Colors.black.withOpacity(0.5),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            filled: true,
            fillColor: const Color(0xFFF2F2F2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 1, color: Color(0xFFCFCFCF)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 1, color: Color(0xFFCFCFCF)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 1, color: Color(0xFF1D4ED8)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  // Membuat DropdownButtonFormField dengan gaya Figma
  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required void Function(String?)? onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          validator: validator,
          hint: Text(
            hint,
            style: GoogleFonts.poppins(
              color: Colors.black.withOpacity(0.5),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF2F2F2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 1, color: Color(0xFFCFCFCF)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 1, color: Color(0xFFCFCFCF)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(width: 1, color: Color(0xFF1D4ED8)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: GoogleFonts.poppins(fontSize: 14)),
            );
          }).toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down),
        ),
      ],
    );
  }

  // Membuat area upload file
  Widget _buildFileUploadArea({
    required String label,
    required String buttonText,
    required IconData buttonIcon,
    required VoidCallback onUploadPressed,
    String? selectedFileName,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 120,
          decoration: ShapeDecoration(
            color: const Color(0xFFF2F2F2),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFCFCFCF)),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Center(
            child: selectedFileName != null
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      selectedFileName,
                      style: GoogleFonts.poppins(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  )
                : Text(
                    'Belum ada dokumentasi',
                    style: GoogleFonts.poppins(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 13,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          icon: Icon(buttonIcon, size: 18, color: const Color(0xFF1D4ED8)),
          label: Text(
            buttonText,
            style: GoogleFonts.poppins(
              color: const Color(0xFF1D4ED8),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: onUploadPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            alignment: Alignment.centerLeft,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const double headerHeight = 100.0;
    const double formTopPadding = 20.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Header Biru dengan latar belakang melengkung
          Container(
            height: headerHeight + formTopPadding,
            decoration: const ShapeDecoration(
              color: Color(0xFF1D4ED8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: kToolbarHeight - 50,
                left: 10,
                right: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        'Kembali',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Text(
                      'Edit Kegiatan',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Text(
                      'Perbarui informasi untuk kegiatan ini.',
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Form input dibawah header
          Padding(
            padding: EdgeInsets.only(top: headerHeight + formTopPadding),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                children: [
                  _buildTextField(
                    controller: _namaController,
                    label: "Nama Kegiatan",
                    hint: "Masukkan nama kegiatan",
                    validator: (v) => v == null || v.isEmpty
                        ? 'Nama kegiatan tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  _buildDropdownField(
                    label: "Kategori",
                    hint: "Pilih Kategori",
                    value: _selectedKategori,
                    items: _kategoriOptions,
                    onChanged: (nv) => setState(() => _selectedKategori = nv),
                    validator: (v) =>
                        v == null ? 'Kategori harus dipilih' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _tanggalController,
                    label: "Tanggal",
                    hint: "dd/mm/yyyy",
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      size: 20,
                      color: Colors.grey,
                    ),
                    validator: (v) => v == null || v.isEmpty
                        ? 'Tanggal tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _lokasiController,
                    label: "Lokasi",
                    hint: "Masukkan lokasi",
                    validator: (v) => v == null || v.isEmpty
                        ? 'Lokasi tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _pjController,
                    label: "Penanggung Jawab",
                    hint: "Masukkan nama Penanggung Jawab",
                    validator: (v) => v == null || v.isEmpty
                        ? 'Penanggung Jawab tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _deskripsiController,
                    label: "Deskripsi",
                    hint: "Masukkan deskripsi kegiatan",
                    maxLines: 3,
                    validator: (v) => v == null || v.isEmpty
                        ? 'Deskripsi tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  _buildFileUploadArea(
                    label: "Dokumentasi",
                    buttonText: _selectedDocumentFileName == null
                        ? "Upload Dokumentasi"
                        : "Ganti Dokumentasi",
                    buttonIcon: Icons.upload_file,
                    onUploadPressed: _pickDocument,
                    selectedFileName: _selectedDocumentFileName,
                  ),

                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D4ED8),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.25),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Menyimpan perubahan...'),
                            ),
                          );
                        }
                      },
                      child: Text(
                        "Simpan Perubahan",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
