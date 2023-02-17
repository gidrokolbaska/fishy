import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GreenButton extends StatefulWidget {
  const GreenButton({
    super.key,
    required this.buttonSize,
    required this.buttonText,
    required this.onTap,
    this.isLoading,
  });
  final Size buttonSize;
  final String buttonText;
  final VoidCallback onTap;
  final bool? isLoading;

  @override
  State<GreenButton> createState() => _GreenButtonState();
}

class _GreenButtonState extends State<GreenButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: widget.buttonSize,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      onPressed: widget.onTap,
      child: widget.isLoading == null || widget.isLoading == false
          ? Text(
              widget.buttonText,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            )
          : const CircularProgressIndicator.adaptive(),
    );
  }
}
