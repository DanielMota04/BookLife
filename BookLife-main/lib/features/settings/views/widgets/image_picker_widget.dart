import 'dart:typed_data';
import 'package:flutter/material.dart';

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
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(color: Theme.of(context).colorScheme.secondary),
            ),
            child: imagem != null
                ? ClipOval(child: Image.memory(imagem!, fit: BoxFit.cover))
                : Icon(Icons.upload, size: 50, color: Theme.of(context).colorScheme.secondary),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
