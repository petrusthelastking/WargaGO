import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TambahDataMutasiPage extends StatefulWidget {
  const TambahDataMutasiPage({super.key});

  @override
  State<TambahDataMutasiPage> createState() => _TambahDataMutasiPageState();
}

class _TambahDataMutasiPageState extends State<TambahDataMutasiPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _rumahSekarangController = TextEditingController();
  final TextEditingController _rumahBaruController = TextEditingController();
  final TextEditingController _alasanMutasiController = TextEditingController();

  // Dropdowns
  String? _selectedJenisMutasi;
  String? _selectedKeluarga;
  DateTime? _selectedTanggalMutasi;

  // List data untuk dropdown
  final List<String> _jenisMutasiList = [
    'Keluar Perumahan',
    'Pindah Rumah',
  ];

  final List<String> _keluargaList = [
    'Keluarga Rusdi',
    'Keluarga Habibie Ed Dien',
    'Keluarga Budi Santoso',
    'Keluarga Ahmad Dahlan',
    'Keluarga Siti Nurhaliza',
  ];

  @override
  void dispose() {
    _rumahSekarangController.dispose();
    _rumahBaruController.dispose();
    _alasanMutasiController.dispose();
    super.dispose();
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement data submission logic
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Berhasil',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Data mutasi keluarga berhasil ditambahkan.',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                'OK',
                style: GoogleFonts.poppins(
                  color: const Color(0xFF2988EA),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F1F1F)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Tambah Mutasi Keluarga',
          style: GoogleFonts.poppins(
            color: const Color(0xFF1F1F1F),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Jenis Mutasi
                    _buildDropdownField(
                      label: 'Jenis Mutasi',
                      hint: 'Keluar Perumahan',
                      value: _selectedJenisMutasi,
                      items: _jenisMutasiList,
                      onChanged: (value) {
                        setState(() {
                          _selectedJenisMutasi = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Keluarga
                    _buildDropdownField(
                      label: 'Keluarga',
                      hint: 'Keluarga Rusdi',
                      value: _selectedKeluarga,
                      items: _keluargaList,
                      onChanged: (value) {
                        setState(() {
                          _selectedKeluarga = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Rumah Sekarang
                    _buildTextField(
                      controller: _rumahSekarangController,
                      label: 'Rumah Sekarang',
                      hint: 'Rumah sekarang',
                    ),
                    const SizedBox(height: 16),

                    // Tampilkan field Rumah Baru jika jenis mutasi adalah Pindah Rumah
                    if (_selectedJenisMutasi == 'Pindah Rumah') ...[
                      _buildTextField(
                        controller: _rumahBaruController,
                        label: 'Rumah Baru',
                        hint: 'Masukkan alamat rumah baru',
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Tanggal Mutasi
                    _buildDateField(
                      label: 'Tanggal Mutasi',
                      hint: 'mm/dd/yyyy',
                      value: _selectedTanggalMutasi,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedTanggalMutasi ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Color(0xFF2988EA),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedTanggalMutasi = picked;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Alasan Mutasi
                    _buildTextArea(
                      controller: _alasanMutasiController,
                      label: 'Alasan Mutasi',
                      hint: 'Masukkan alasan mutasi keluarga',
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Button
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F1F1F),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                hint,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF9E9E9E),
                ),
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF757575),
                size: 24,
              ),
              isExpanded: true,
              dropdownColor: Colors.white,
              menuMaxHeight: 300,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFF1F1F1F),
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFF1F1F1F),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        // Validation message
        if (value == null && _formKey.currentState?.validate() == false)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12),
            child: Text(
              'Pilih $label',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.red,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F1F1F),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF9CA3AF),
            ),
            filled: true,
            fillColor: const Color(0xFFF8F9FC),
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE8EAF2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE8EAF2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2988EA), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Masukkan $label';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required String hint,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F1F1F),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE8EAF2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value != null
                      ? '${value.month.toString().padLeft(2, '0')}/${value.day.toString().padLeft(2, '0')}/${value.year}'
                      : hint,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: value != null
                        ? const Color(0xFF1F1F1F)
                        : const Color(0xFF9CA3AF),
                  ),
                ),
                const Icon(
                  Icons.calendar_today,
                  color: Color(0xFF6B7280),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextArea({
    required TextEditingController controller,
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1F1F1F),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF9CA3AF),
            ),
            filled: true,
            fillColor: const Color(0xFFF8F9FC),
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE8EAF2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE8EAF2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF2988EA), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Masukkan $label';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _submitData,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2988EA),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Simpan',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
