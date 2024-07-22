import 'package:flutter/material.dart';

class BigStaticSizeBox extends StatelessWidget {
  final BuildContext context;
  final Widget child;

  const BigStaticSizeBox(
    this.context, {
    super.key,
    required this.child,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20)
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.8,
        child: child
      ),
    );
  }
}
