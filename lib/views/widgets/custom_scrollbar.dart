import 'package:flutter/material.dart';
import 'package:siakad_trivium/style.dart';

class CustomScrollbar extends StatelessWidget {
  final Widget child;
  final ScrollController controller;

  const CustomScrollbar({
    Key? key,
    required this.child,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      controller: controller,
      thumbColor: brand200, // Warna scrollbar
      radius: const Radius.circular(8), // Rounded scrollbar
      thickness: 6.0,
      thumbVisibility: false, // Selalu muncul
      trackVisibility: false, // Background scrollbar
      child: child,
    );
  }
}
