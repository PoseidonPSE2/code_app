import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final dynamic error;

  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Error: $error'),
    );
  }
}
