import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

class ImageEditorScreen extends StatelessWidget {
  final File originalImage;

  const ImageEditorScreen({super.key, required this.originalImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Editor'),
      ),
      body: ProImageEditor.file(
        originalImage, // Pass the file directly

        callbacks: ProImageEditorCallbacks(
          onImageEditingComplete: (Uint8List editedImage) async {
            if (editedImage.isNotEmpty) {
              // Save the edited image and return
              final tempDir = Directory.systemTemp;
              final file = File('${tempDir.path}/edited_image.png');
              await file.writeAsBytes(editedImage as List<int>);
              Navigator.pop(context, file);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}
