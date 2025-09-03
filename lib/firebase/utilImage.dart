import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<String> saveImage(Image image) async {
  final completer = Completer<String>();
  var directory = await getApplicationDocumentsDirectory();

  image.image.resolve(ImageConfiguration()).addListener(ImageStreamListener((
    ImageInfo image,
    bool synchronousCall,
  ) async {
    final byteData = await image.image.toByteData(format: ImageByteFormat.png);
    final pngBytes = byteData.buffer.asUint8List();
    final fileName = image.hashCode;
    directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    await file.writeAsBytes(pngBytes);
    completer.complete(filePath);
  }));
  directory.deleteSync(recursive: true);
  return completer.future;
}
