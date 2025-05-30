import 'package:flutter/material.dart';
import 'package:siakad_trivium/style.dart';

class CustomScrollbar extends StatelessWidget {
  final Widget child;

  const CustomScrollbar({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      thumbColor: brand200,
      radius: const Radius.circular(8),
      thickness: 6.0,
      thumbVisibility: true, // scrollbar selalu kelihatan
      child: child,
    );
  }
}