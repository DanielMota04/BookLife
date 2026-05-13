import 'dart:typed_data';
import 'package:book_life/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CoverPicker extends StatelessWidget {
  final Uint8List? imagem;
  final VoidCallback onTap;

  const CoverPicker({super.key, required this.onTap, this.imagem});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 120,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade500),
          ),
          child: imagem != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.memory(imagem!, fit: BoxFit.cover),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.upload, size: 38, color: AppColors.teal),
                    const SizedBox(height: 8),
                    Text(
                      "Capa do livro",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.teal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
