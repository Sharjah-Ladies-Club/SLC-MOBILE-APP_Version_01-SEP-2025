import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCachedImage extends StatelessWidget {
  final String url;

  CustomCachedImage(this.url);

  @override
  Widget build(BuildContext ctxt) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (ctxt, imageProvider) => Container(
        margin: EdgeInsets.only(bottom: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (ctxt, url) => Container(
        child: Center(
          child: SizedBox(
              height: 30.0, width: 30.0, child: CircularProgressIndicator()),
        ),
      ),
      errorWidget: (ctxt, url, error) => Icon(Icons.error),
    );
  }
}
