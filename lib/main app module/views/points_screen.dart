import 'package:auto_route/auto_route.dart';
import 'package:fishy/routing/app_router.gr.dart';
import 'package:flutter/material.dart';

class FishyPointsScreen extends StatelessWidget {
  const FishyPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          onPressed: () {
            context.pushRoute(const PointDetailsScreenRoute());
          },
          child: Text('test nav')),
    );
  }
}
