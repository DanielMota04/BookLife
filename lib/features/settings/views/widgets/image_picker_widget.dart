import 'dart:typed_data';

import 'package:book_life/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImagePickerWidget extends StatelessWidget {
  final Uint8List? imagem;
  final VoidCallback? onTap;
  final String label;

  const ImagePickerWidget({super.key, this.imagem, this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade500),
            ),
            child: imagem != null
                ? ClipOval(child: Image.memory(imagem!, fit: BoxFit.cover))
                : const Icon(Icons.upload, size: 50, color: AppColors.teal),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inriaSans(
              fontSize: 20,
              color: AppColors.teal,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
