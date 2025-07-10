import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../ui_helper/app_colors.dart';

class CompanyProfileShimmer extends StatelessWidget {
  const CompanyProfileShimmer({super.key});

  Widget _shimmerBox({double height = 16, double width = double.infinity, BorderRadius? borderRadius}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    );
  }

  Widget _shimmerRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: _shimmerBox(width: 100, height: 14)),
          const SizedBox(width: 8),
          Expanded(flex: 3, child: _shimmerBox(height: 14)),
        ],
      ),
    );
  }

  Widget _circleAvatarShimmer() {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _shimmerBox(height: 18, width: 160), // title
                    const SizedBox(height: 16),
                    _shimmerRow(),
                    _shimmerRow(),
                    _shimmerRow(),
                    _shimmerRow(),
                    _shimmerRow(),
                    _shimmerRow(),
                    _shimmerRow(),
                    const SizedBox(height: 12),
                    _circleAvatarShimmer(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _addressShimmer("Registered Office Address"),
            const SizedBox(height: 20),
            _addressShimmer("Corporate Office Address"),
            const SizedBox(height: 20),
            _addressShimmer("Custom Address"),
          ],
        ),
      ),
    );
  }

  Widget _addressShimmer(String title) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _shimmerBox(height: 18, width: 180),
            const SizedBox(height: 16),
            _shimmerRow(),
            _shimmerRow(),
            _shimmerRow(),
            _shimmerRow(),
            _shimmerRow(),
          ],
        ),
      ),
    );
  }
}
