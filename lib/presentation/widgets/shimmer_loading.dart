// lib/presentation/widgets/shimmer_loading.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Widget? placeholder;

  const ShimmerLoading({
    Key? key,
    required this.isLoading,
    required this.child,
    this.placeholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return child;
    }

    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: placeholder ?? _buildDefaultPlaceholder(),
    );
  }

  Widget _buildDefaultPlaceholder() {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    );
  }
}

class UserListShimmer extends StatelessWidget {
  const UserListShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: _buildUserTilePlaceholder(),
        );
      },
    );
  }

  Widget _buildUserTilePlaceholder() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            height: 20,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Container(
            width: 200,
            height: 16,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class UserDetailsShimmer extends StatelessWidget {
  const UserDetailsShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 40,
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
          Container(
            width: 300,
            height: 20,
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
          Container(
            width: 250,
            height: 20,
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
          Container(
            width: 200,
            height: 20,
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 100,
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 100,
            color: Colors.white,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          ),
        ],
      ),
    );
  }
}