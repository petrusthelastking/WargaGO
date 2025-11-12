import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and logo
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3E9FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Logo and App Name
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/icon.png',
                  height: 48,
                  width: 48,
                  errorBuilder: (_, __, ___) => Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2F80ED),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.fingerprint,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Jawara',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2F80ED),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Breadcrumb
            _buildBreadcrumb(),
            const SizedBox(height: 32),
            // Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _Step1Content(onNext: _nextStep),
                  _Step2Content(onNext: _nextStep, onBack: _previousStep),
                  _Step3Content(onNext: _nextStep, onBack: _previousStep),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreadcrumb() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildBreadcrumbStep(1, _currentStep >= 0),
          _buildBreadcrumbLine(_currentStep >= 1),
          _buildBreadcrumbStep(2, _currentStep >= 1),
          _buildBreadcrumbLine(_currentStep >= 2),
          _buildBreadcrumbStep(3, _currentStep >= 2),
        ],
      ),
    );
  }

  Widget _buildBreadcrumbStep(int step, bool isActive) {
    return Container(
      height: 36,
      width: 36,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF2F80ED) : const Color(0xFFE5E7EB),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$step',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : const Color(0xFF9CA3AF),
          ),
        ),
      ),
    );
  }

  Widget _buildBreadcrumbLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 3,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF2F80ED) : const Color(0xFFE5E7EB),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

// Step 1: Basic Information
class _Step1Content extends StatelessWidget {
  final VoidCallback onNext;

  const _Step1Content({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sign Up',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2F80ED),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Daftar sebagai admin untuk mulai menggunakan fitur di aplikasi ini.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF9CA3AF),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          _buildTextField('Nama Lengkap'),
          const SizedBox(height: 20),
          _buildTextField('Nomor NIK'),
          const SizedBox(height: 20),
          _buildTextField('Email Anda'),
          const SizedBox(height: 20),
          _buildTextField('Nomor Telepon'),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F80ED),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: onNext,
              child: Text(
                'Selanjutnya',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFFD1D5DB),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: const Color(0xFFE5E7EB)),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: const Color(0xFFE5E7EB)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: const Color(0xFF2F80ED), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: const Color(0xFF1F1F1F),
          ),
        ),
      ],
    );
  }
}

// Step 2: Password and Address
class _Step2Content extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _Step2Content({required this.onNext, required this.onBack});

  @override
  State<_Step2Content> createState() => _Step2ContentState();
}

class _Step2ContentState extends State<_Step2Content> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sign Up',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2F80ED),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Daftar sebagai admin untuk mulai menggunakan fitur di aplikasi ini.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF9CA3AF),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          _buildPasswordField('Password', _obscurePassword, () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          }),
          const SizedBox(height: 20),
          _buildPasswordField(
            'Konfirmasi password',
            _obscureConfirmPassword,
            () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildDropdownField('Jenis Jelamin')),
              const SizedBox(width: 12),
              Expanded(child: _buildDropdownField('Jenis Jelamin')),
            ],
          ),
          const SizedBox(height: 20),
          _buildTextField('Alamat Rumah (Jika Tidak Ada di List)'),
          const SizedBox(height: 20),
          _buildTextField('Status kepemilikan rumah'),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F80ED),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: widget.onNext,
              child: Text(
                'Selanjutnya',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: const Color(0xFFD1D5DB),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: const Color(0xFFE5E7EB)),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: const Color(0xFFE5E7EB)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: const Color(0xFF2F80ED), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
      style: GoogleFonts.poppins(fontSize: 15, color: const Color(0xFF1F1F1F)),
    );
  }

  Widget _buildPasswordField(String hint, bool obscure, VoidCallback onToggle) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: const Color(0xFFD1D5DB),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: const Color(0xFFE5E7EB)),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: const Color(0xFFE5E7EB)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: const Color(0xFF2F80ED), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: const Color(0xFF9CA3AF),
            size: 20,
          ),
          onPressed: onToggle,
        ),
      ),
      style: GoogleFonts.poppins(fontSize: 15, color: const Color(0xFF1F1F1F)),
    );
  }

  Widget _buildDropdownField(String hint) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: const Color(0xFFE5E7EB))),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFFD1D5DB),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9CA3AF)),
        items: ['Laki-laki', 'Perempuan'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: GoogleFonts.poppins(fontSize: 15)),
          );
        }).toList(),
        onChanged: (value) {},
      ),
    );
  }
}

// Step 3: Photo Upload
class _Step3Content extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const _Step3Content({required this.onNext, required this.onBack});

  @override
  State<_Step3Content> createState() => _Step3ContentState();
}

class _Step3ContentState extends State<_Step3Content> {
  bool _hasImage = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sign Up',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2F80ED),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Daftar sebagai admin untuk mulai menggunakan fitur di aplikasi ini.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF9CA3AF),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Foto Indentitas',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 12),
          // Upload Area
          GestureDetector(
            onTap: () {
              setState(() {
                _hasImage = !_hasImage;
              });
            },
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2F80ED),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.cloud_upload_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'WARNING',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFEF4444),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Upload Foto KK/KTP (.png/.jpg)',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: const Color(0xFFEF4444),
            ),
          ),
          const SizedBox(height: 200),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F80ED),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: () {
                // Navigate to dashboard or show success
                Navigator.pop(context);
              },
              child: Text(
                'Selanjutnya',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
