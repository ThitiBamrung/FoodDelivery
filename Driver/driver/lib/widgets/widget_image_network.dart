// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:driver/widgets/show_images.dart';
import 'package:driver/widgets/show_progress.dart';

class WidgetImageNetwork extends StatelessWidget {
  const WidgetImageNetwork({
    Key? key,
    required this.url,
    this.width,
    this.height,
    this.boxFit,
  }) : super(key: key);

  final String url;
  final double? width;
  final double? height;
  final BoxFit? boxFit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => const ShowProgress(),
      errorWidget: (context, url, error) =>
          const ShowImages(path: 'images/logo.png'),
      width: width,
      height: height,
      fit: boxFit,
    );
  }
}
