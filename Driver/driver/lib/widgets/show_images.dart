import 'package:flutter/material.dart';

class ShowImages extends StatelessWidget {
  final String path;
  const ShowImages({Key? key, required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(path);
  }
}
