import 'package:flutter/material.dart';

Widget buildSkeleton() {
  return Column(
    children: [
      _skeletonBox(width: 104, height: 104, radius: 52),
      const SizedBox(height: 12),
      _skeletonBox(width: 150, height: 18),
      const SizedBox(height: 8),
      _skeletonBox(width: 200, height: 14),
    ],
  );
}

Widget _skeletonBox({
  required double width,
  required double height,
  double radius = 8,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}
