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
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.8,
      child: child
    );
  }
}
