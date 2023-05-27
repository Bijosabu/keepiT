import 'package:flutter/material.dart';
import 'package:keepit/core/constants/constants.dart';

class MainFolder extends StatelessWidget {
  final Function()? onTap;
  final String text;
  const MainFolder({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            width: 70,
            height: 70,
            child: Icon(
              Icons.folder,
              color: Colors.blue[300],
              size: 40,
            ),
          ),
        ),
        kHeight10,
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
