import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'edit_data_warga_page.dart';

class DetailDataWargaPage extends StatelessWidget {
  const DetailDataWargaPage({super.key});

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
          "Detail Data Warga",
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
                MaterialPageRoute(builder: (context) => const EditDataWargaPage()),
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
            _buildDetailField("Tempat, Tanggal Lahir", "-"),
            _buildDetailField("Nomor Telepon", "0876543219"),
            _buildDetailField("Jenis Kelamin", "Laki-laki"),
            _buildDetailField("Agama", "-"),
            _buildDetailField("Golongan Darah", "-"),
            _buildDetailField("Pendidikan Terakhir", "-"),
            _buildDetailField("Pekerjaan", "-"),
            _buildDetailField("Peran dalam Keluarga", "-"),
            _buildDetailField("Status Penduduk", "-"),
            _buildDetailField("Keluarga", "-"),
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
