import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedImageNotifier extends StateNotifier<Uint8List?> {
  SelectedImageNotifier() : super(null);

  void setImage(Uint8List? image) => state = image;
}

final selectedImageProvider = StateNotifierProvider<SelectedImageNotifier, Uint8List?>(
  (ref) => SelectedImageNotifier(),
);