import 'package:flutter/material.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback? onNextPagePressed;
  final VoidCallback? onPreviousPagePressed;

  const PaginationWidget({
    super.key, 
    required this.currentPage,
    required this.totalPages,
    required this.onNextPagePressed,
    required this.onPreviousPagePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onPreviousPagePressed,
        ),
        const SizedBox(width: 16),
        Text(
          'Página $currentPage de $totalPages',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: onNextPagePressed,
        ),
      ],
    );
  }
}
