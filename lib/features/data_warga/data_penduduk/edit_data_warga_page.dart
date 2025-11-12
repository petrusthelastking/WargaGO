import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditDataWargaPage extends StatefulWidget {
  const EditDataWargaPage({super.key});

  @override
  State<EditDataWargaPage> createState() => _EditDataWargaPageState();
}

class _EditDataWargaPageState extends State<EditDataWargaPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk field teks
  final TextEditingController _namaController = TextEditingController(
    text: "Farhan",
  );
  final TextEditingController _nikController = TextEditingController(
    text: "4567890864654356",
  );
  final TextEditingController _teleponController = TextEditingController(
    text: "0876543219",
  );
  final TextEditingController _keluargaController = TextEditingController(
    text: "Keluarga Farhan",
  );
  final TextEditingController _tempatLahirController = TextEditingController(
    text: "Malang",
  );

  // Variabel dropdown
  String? _agama;
  String? _golonganDarah;
  String? _peran;
  String? _pendidikan;
  String? _pekerjaan;
  String? _statusHidup;
  String? _statusPenduduk;
  String? _jenisKelamin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Edit Data Warga",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField("Nama Lengkap", _namaController),
              _buildTextField(
                "NIK",
                _nikController,
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                "Nomor Telepon",
                _teleponController,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField("Keluarga", _keluargaController),
              _buildTextField("Tempat Lahir", _tempatLahirController),

              _buildDropdown(
                "Agama",
                _agama,
                ["Islam", "Kristen", "Katolik", "Hindu", "Buddha", "Konghucu"],
                (value) {
                  setState(() => _agama = value);
                },
              ),

              _buildDropdown(
                "Golongan Darah",
                _golonganDarah,
                ["A", "B", "AB", "O"],
                (value) {
                  setState(() => _golonganDarah = value);
                },
              ),

              _buildDropdown(
                "Peran",
                _peran,
                ["Kepala Keluarga", "Istri", "Anak", "Anggota Keluarga Lain"],
                (value) {
                  setState(() => _peran = value);
                },
              ),

              _buildDropdown(
                "Pendidikan Terakhir",
                _pendidikan,
                [
                  "Tidak Sekolah",
                  "SD",
                  "SMP",
                  "SMA",
                  "Sarjana/Diploma (D1-D3)",
                ],
                (value) {
                  setState(() => _pendidikan = value);
                },
              ),

              _buildDropdown(
                "Pekerjaan",
                _pekerjaan,
                [
                  "Tidak Bekerja",
                  "Pelajar",
                  "Ibu Rumah Tangga",
                  "Pegawai",
                  "Wirausaha",
                  "Buruh",
                  "Lainnya",
                ],
                (value) {
                  setState(() => _pekerjaan = value);
                },
              ),

              _buildDropdown("Status Hidup", _statusHidup, ["Hidup", "Wafat"], (
                value,
              ) {
                setState(() => _statusHidup = value);
              }),

              _buildDropdown(
                "Status Penduduk",
                _statusPenduduk,
                ["Aktif", "Nonaktif"],
                (value) {
                  setState(() => _statusPenduduk = value);
                },
              ),

              _buildDropdown(
                "Jenis Kelamin",
                _jenisKelamin,
                ["Laki-laki", "Perempuan"],
                (value) {
                  setState(() => _jenisKelamin = value);
                },
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F80ED),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    "Simpan",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Text Field builder
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
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

  // Dropdown builder
  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            initialValue: value,
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
            items: items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: onChanged,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
