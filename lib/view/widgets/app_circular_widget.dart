import 'package:flutter/material.dart';

class AppCircularWidget extends StatelessWidget {
  const AppCircularWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
