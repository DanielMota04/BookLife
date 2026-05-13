import 'package:flutter/material.dart';

class BibliotecaSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const BibliotecaSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade500),
              ),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Pesquisar livro",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: onChanged,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.filter_alt_outlined, size: 32),
        ],
      ),
    );
  }
}
