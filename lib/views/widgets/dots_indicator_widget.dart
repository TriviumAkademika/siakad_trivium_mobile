// lib/widgets/dots_indicator_widget.dart
import 'package:flutter/material.dart';

class DotsIndicatorWidget extends StatelessWidget {
  final int itemCount;
  final int currentPageIndex;
  final Color activeColor;
  final Color inactiveColor;

  const DotsIndicatorWidget({
    super.key,
    required this.itemCount,
    required this.currentPageIndex,
    this.activeColor = const Color(0xFF152556), // Warna titik aktif default
    this.inactiveColor = Colors.grey, // Warna titik tidak aktif default
  });

  @override
  Widget build(BuildContext context) {
    if (itemCount <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentPageIndex == index
                ? activeColor
                : inactiveColor.withOpacity(0.5), // Opacity untuk titik tidak aktif
          ),
        );
      }),
    );
  }
}