import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:book_life/core/enums/reading_status.dart';

class BookStatusButton extends StatelessWidget {
  final ReadingStatus status;
  final VoidCallback onPressed;
  const BookStatusButton({
    super.key,
    required this.status,
    required this.onPressed,
  });

  String get _buttonText {
    switch (status) {
      case ReadingStatus.reading:
        return 'Leitura Atual';
      case ReadingStatus.completed:
        return 'Leitura Concluida';
      case ReadingStatus.wishlist:
      default:
        return 'Iniciar Leitura';
    }
  }

  Color get _backgroundColor {
    switch (status) {
      case ReadingStatus.reading:
        return const Color(0xFF32BBFF);
      case ReadingStatus.completed:
        return const Color(0xFF22C55E);
      case ReadingStatus.wishlist:
      default:
        return const Color(0xFFEADBC8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        side: const BorderSide(color: Colors.black),
        backgroundColor: _backgroundColor,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        minimumSize: const Size(60, 44),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status == ReadingStatus.completed) ...[
            const Icon(Icons.check),
            const SizedBox(width: 8),
          ],
          Text(
            _buttonText,
            style: GoogleFonts.inriaSans(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          const SizedBox(
            height: 30,
            child: VerticalDivider(color: Colors.black),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down, size: 20),
        ],
      ),
    );
  }
}
