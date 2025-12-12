import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget tombol batal untuk form agenda
class CancelButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const CancelButton({
    super.key,
    required this.onPressed,
    this.label = 'Batal',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: Color(0xFF2F80ED),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2F80ED),
          ),
        ),
      ),
    );
  }
}
