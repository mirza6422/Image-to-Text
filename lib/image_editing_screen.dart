import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_to_text/state/image_state.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:provider/provider.dart';

class ImageEditorScreen extends StatelessWidget {
  final File originalImage;

  const ImageEditorScreen({super.key, required this.originalImage});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ImageState>(context);
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
              final now = DateTime.now().millisecondsSinceEpoch;
              final file = File('${tempDir.path}$now.png');
              final image = await file.writeAsBytes(editedImage as List<int>);
              provider.image = image;
              Navigator.pop(context, image);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}
