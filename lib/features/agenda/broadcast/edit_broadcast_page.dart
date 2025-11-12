import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditBroadcastPage extends StatefulWidget {
  const EditBroadcastPage({super.key});

  @override
  State<EditBroadcastPage> createState() => _EditBroadcastPageState();
}

class _EditBroadcastPageState extends State<EditBroadcastPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _judulController = TextEditingController(
    text: "Pengumuman",
  );
  final TextEditingController _isiController = TextEditingController(
    text: "Donor Darah di posko...",
  );

  String? _selectedImageFileName = "poster_donor.jpg";
  String? _selectedDocumentFileName = "surat_undangan.pdf";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    setState(() {
      _selectedImageFileName = "gambar_baru.png";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logika ganti gambar belum diimplementasikan.'),
      ),
    );
  }

  Future<void> _pickDocument() async {
    setState(() {
      _selectedDocumentFileName = "dokumen_baru.docx";
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
          ),
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
                    'Belum ada file terlampir',
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
                      'Edit Broadcast',
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
                      'Perbarui isi pengumuman yang sudah dibuat.',
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
                    controller: _judulController,
                    label: "Judul Broadcast",
                    hint: "Masukkan judul broadcast",
                    validator: (v) => v == null || v.isEmpty
                        ? 'Judul tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _isiController,
                    label: "Isi Broadcast",
                    hint: "Masukkan isi broadcast",
                    maxLines: 5,
                    validator: (v) => v == null || v.isEmpty
                        ? 'Isi broadcast tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  _buildFileUploadArea(
                    label: "Lampiran Gambar",
                    buttonText: "Ganti Gambar",
                    buttonIcon: Icons.upload_file,
                    onUploadPressed: _pickImage,
                    selectedFileName: _selectedImageFileName,
                  ),
                  const SizedBox(height: 20),
                  _buildFileUploadArea(
                    label: "Lampiran Dokumen",
                    buttonText: "Ganti Dokumen PDF",
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
                              content: Text('Menyimpan perubahan broadcast...'),
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
