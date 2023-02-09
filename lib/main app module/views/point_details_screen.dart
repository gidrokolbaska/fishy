import 'package:fishy/constants.dart';
import 'package:flutter/material.dart';

class PointDetailsScreen extends StatelessWidget {
  const PointDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: Text('point details screen'),
      ),
    );
  }
}
