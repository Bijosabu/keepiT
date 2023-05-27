import 'package:flutter/material.dart';

class ShowAddedFiles extends StatelessWidget {
  const ShowAddedFiles({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width - 50,
      height: 150,
    );
  }
}
