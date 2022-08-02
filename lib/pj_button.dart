import 'package:flutter/material.dart';

class PjButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final double? buttonWight;
  final Function() onTap;
  final bool isSelected;

  const PjButton({
    Key? key,
    this.textColor = const Color.fromRGBO(15, 18, 24, 1),
    this.buttonWight,
    this.isSelected = false,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected ? Color.fromRGBO(250, 123, 55, 1.0) :
            Color.fromRGBO(250, 198, 55, 1),
          ),
          width: buttonWight ?? 336,
          height: 50,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: textColor,
              ),
            ),
          ),
        ),
    );
  }
}
