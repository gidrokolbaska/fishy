import 'package:fishy/constants.dart';

import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

class TypeOfFishingBottomSheetPage extends StatelessWidget {
  final bool reverse;

  const TypeOfFishingBottomSheetPage({Key? key, this.reverse = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        titleTextStyle: TextStyle(
          color: grayscaleOffwhite,
          fontWeight: FontWeight.bold,
          fontSize: 13.sp,
        ),
        foregroundColor: grayscaleOffwhite,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 24,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const Text(
              'Выберите глубину',
            )
          ],
        ),
      ),
      body: Center(
        child: Text('test'),
      ),
    );
  }
}
