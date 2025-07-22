import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

mixin ImagePickerService on ConsumerWidget {
  Future<void> pickImage(Function(Uint8List?) onImagePicked) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Read the image file as bytes
      final bytes = await pickedFile.readAsBytes();
      onImagePicked(bytes);
    } else {
      // Handle the case where the user cancels the image picking
      onImagePicked(null);
    }
  }
}