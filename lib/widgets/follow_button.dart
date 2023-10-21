import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Function()? function;
  final Color backgroundColor;
  final Color borderColor;
  final String label;
  final Color labelColor;
  const FollowButton(
      {super.key,
      this.function,
      required this.backgroundColor,
      required this.borderColor,
      required this.label,
      required this.labelColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: TextButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(5)),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(color: labelColor, fontWeight: FontWeight.bold),
          ),
          width: 250,
          height: 27,
        ),
      ),
    );
  }
}
