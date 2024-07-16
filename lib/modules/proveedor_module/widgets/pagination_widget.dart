import 'package:flutter/material.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPages;
  final int totalPages;
  final void Function()? onNextPagePressed;
  final void Function()? onPreviousPagePressed;

  const PaginationWidget({
    super.key,
    required this.currentPages,
    required this.totalPages,
    this.onNextPagePressed,
    this.onPreviousPagePressed
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
          'Página $currentPages de $totalPages',
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
