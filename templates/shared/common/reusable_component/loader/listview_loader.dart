import 'package:flutter/material.dart';

class ListviewLoader extends StatelessWidget {
  const ListviewLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
