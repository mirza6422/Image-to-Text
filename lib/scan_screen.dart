import 'dart:io';

import 'package:docx_template/docx_template.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_to_text/state/image_state.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

import 'app_languages.dart';
import 'image_editing_screen.dart';

class ImageCapture extends StatefulWidget {
  const ImageCapture({super.key});

  @override
  State<ImageCapture> createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  final picker = ImagePicker();

  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TextRecognizer _textRecognizer = TextRecognizer();

  // Future<bool> _requestPermission(Permission permission) async {
  //   if (await permission.isGranted) {
  //     return true;
  //   } else {
  //     var result = await permission.request();
  //     if (result == PermissionStatus.granted) {
  //       return true;
  //     } else if (result == PermissionStatus.denied ||
  //         result == PermissionStatus.permanentlyDenied) {
  //       openAppSettings();
  //     }
  //   }
  //   return false;
  // }

  Future<String> _getFilePath(String extension) async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        directory =
            await getExternalStorageDirectory(); // App-specific directory
      } else {
        directory =
            await getApplicationDocumentsDirectory(); // iOS-specific directory
      }
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      return "${directory!.path}/$fileName.$extension";
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return "";
    }
  }

  Future<void> _saveFile(
      ImageState imageProvider, String content, String extension) async {
    if (imageProvider.textController.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 1),
          content: Text(AppLocalizations.of(context)!.noSave),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Request correct permission (storage access)
    // bool permissionGranted = await _requestPermission(Permission.storage);
    // if (!permissionGranted) {
    //   return;
    // }

    String filePath = await _getFilePath(extension);
    bool success = false;

    if (filePath.isNotEmpty) {
      switch (extension) {
        case 'txt':
          success = await _saveAsTxt(imageProvider, content, filePath);
          break;
        case 'pdf':
          success = await _saveAsPdf(imageProvider, content, filePath);
          break;
        case 'docx':
          success = await _saveAsDocx(imageProvider, content, filePath);
          break;
      }
    }

    if (mounted) {
      _showSaveResult(success, filePath);
    }
  }

  Future<bool> _saveAsTxt(
      ImageState imageProvider, String content, String filePath) async {
    try {
      File file = File(filePath);
      await file.writeAsString(content);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> _saveAsPdf(
      ImageState imageProvider, String content, String filePath) async {
    bool success = false;
    try {
      final fontData =
          await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
      final ttf = pw.Font.ttf(fontData);
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Text(content,
                  style: pw.TextStyle(font: ttf, fontSize: 20)),
            );
          },
        ),
      );
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
      return success = true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return success;
  }

  Future<List<int>> _getDocxTemplate() async {
    ByteData data = await rootBundle.load('assets/template.docx');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<bool> _saveAsDocx(
      ImageState imageProvider, String content, String filePath) async {
    try {
      final docxBytes = await _getDocxTemplate();
      final docx = await DocxTemplate.fromBytes(docxBytes);
      Content contentObject = Content();

      contentObject.add(TextContent('content', content));

      final generatedDocx = await docx.generate(contentObject);

      if (generatedDocx != null) {
        final file = File(filePath);
        await file.writeAsBytes(generatedDocx);
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return true;
    }
  }

  void _showSaveResult(bool success, String filePath) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 2),
              content: Text(AppLocalizations.of(context)!.saveFiles),
              action: SnackBarAction(
                  label: AppLocalizations.of(context)!.openFile,
                  onPressed: () => OpenFile.open(filePath)),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.errorSaving),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });
  }

  void _handleSave(ImageState imageProvider, String extension) async {
    await _saveFile(imageProvider, imageProvider.textController, extension);
    if (mounted) {
      Navigator.pop(context);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const ImageCapture()));
    }
  }

  Future<void> _openImageEditor(ImageState imageProvider) async {
    if (imageProvider.image == null) return;

    var result = await Navigator.push<File>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ImageEditorScreen(originalImage: imageProvider.image!),
      ),
    );

    imageProvider.setEditedImage(result);
  }

  Future<void> getImageFromCamera(ImageState imageProvider) async {
    try {
      var pickedFile = await picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        imageProvider.image = File(pickedFile.path);
        recognizeText(imageProvider);
      } else {
        imageProvider.errorMessage =
            AppLocalizations.of(context)!.imageSelection;
      }
    } catch (e) {
      imageProvider.errorMessage = AppLocalizations.of(context)!.errorCapturing;
    }
  }

  Future<void> getImageFromGallery(ImageState imageProvider) async {
    try {
      var pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        imageProvider.image = File(pickedFile.path);
        recognizeText(imageProvider);
      } else {
        imageProvider.errorMessage =
            AppLocalizations.of(context)!.imageSelection;
      }
    } catch (e) {
      imageProvider.errorMessage = AppLocalizations.of(context)!.errorGallery;
    }
  }

  Future<void> recognizeText(ImageState imageProvider) async {
    if (imageProvider.image == null) return;

    imageProvider.isProcessing = true;
    imageProvider.errorMessage = '';

    final inputImage = InputImage.fromFilePath(imageProvider.image!.path);
    try {
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);

      imageProvider.recognizedText = recognizedText.text;
      _textController.text = imageProvider.recognizedText;
      imageProvider.textController = imageProvider.recognizedText;

      imageProvider.isProcessing = false;
    } catch (e) {
      imageProvider.errorMessage = AppLocalizations.of(context)!.errorText;
      imageProvider.isProcessing = false;
    }
  }

  @override
  void dispose() {
    _textRecognizer.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.of(context).viewInsets.bottom;
    final iskeyboardVisible = keyboard > 0;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    //final provider = Provider.of<ImageState>(context, listen: false);

    return Material(
      child: Consumer<ImageState>(
        builder: (context, provider, child) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: AppBar(
              foregroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              backgroundColor: const Color(0xff0F67B1),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AppLanguages(),
                          ));
                    },
                    icon: const Icon(Icons.language_rounded),
                    tooltip: AppLocalizations.of(context)!.languageIcon,
                  ),
                ),
              ],
              title: Text(
                AppLocalizations.of(context)!.appBar,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            body: Directionality(
              textDirection: TextDirection.ltr,
              child: Center(
                child: Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  height: height / 1.15,
                  width: width,
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        duration: Duration.zero,
                        top: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: height / 2.8,
                            width: width / 1.04,
                            decoration: BoxDecoration(
                              color: Colors.blue[200],
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.blueGrey.withOpacity(0.9),
                                    blurRadius: 12,
                                    blurStyle: BlurStyle.outer),
                              ],
                            ),
                            child: provider.image == null
                                ? Center(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      AppLocalizations.of(context)!
                                          .imageSelection,
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                : Stack(
                                    children: [
                                      Container(
                                        height: height / 2.8,
                                        width: width / 1.04,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          image: DecorationImage(
                                            image: provider.editedImage != null
                                                ? FileImage(
                                                    provider.editedImage!)
                                                : FileImage(provider.image!),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 4,
                                        bottom: 4,
                                        child: SpeedDial(
                                          backgroundColor: Colors.blue[400],
                                          tooltip: 'Edit Image',
                                          onPress: () {
                                            provider.setEditedImage(null);
                                            _openImageEditor(provider);
                                          },
                                          icon: Icons.mode_edit_rounded,
                                          iconTheme: const IconThemeData(
                                              color: Colors.white, size: 40),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                          top: iskeyboardVisible ? 0 : height * 0.39,
                          duration: const Duration(milliseconds: 200),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: provider.isProcessing
                                ? SizedBox(
                                    width: width,
                                    height: 200,
                                    child: const Center(
                                        child: CircularProgressIndicator()))
                                : Container(
                                    height: height / 2.8,
                                    width: width / 1.04,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white),
                                    child: provider.textController.isEmpty
                                        ? const Center(
                                            child: Text(
                                            '',
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 20,
                                            ),
                                          ))
                                        : provider.errorMessage.isNotEmpty
                                            ? Text(
                                                provider.errorMessage,
                                                style: const TextStyle(
                                                    color: Colors.red),
                                              )
                                            : TextFormField(
                                                autocorrect: true,
                                                cursorOpacityAnimates: true,
                                                textCapitalization:
                                                    TextCapitalization
                                                        .sentences,
                                                textDirection:
                                                    TextDirection.ltr,
                                                textAlign: TextAlign.justify,
                                                controller:
                                                    TextEditingController(
                                                  text: provider.image != null
                                                      ? provider.textController
                                                      : _textController.text,
                                                ),
                                                scrollController:
                                                    _scrollController,
                                                maxLines: null,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  // focusedBorder: InputBorder.none,
                                                  floatingLabelAlignment:
                                                      FloatingLabelAlignment
                                                          .center,
                                                  label: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .text,
                                                    style: const TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                ),
                                              )),
                          )),
                      AnimatedPositioned(
                        bottom: 0,
                        left: 0.1,
                        right: 0.1,
                        duration: Duration.zero,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              FloatingActionButton(
                                  mini: true,
                                  tooltip:
                                      AppLocalizations.of(context)!.gallery,
                                  onPressed: () {
                                    provider.setEditedImage(null);
                                    getImageFromGallery(provider);
                                  },
                                  heroTag: 'galleryButton',
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Icon(
                                    Icons.photo_library_rounded,
                                    color: Colors.blue,
                                    size: 30,
                                  )),
                              FloatingActionButton(
                                backgroundColor: Colors.blue,
                                tooltip: AppLocalizations.of(context)!.camera,
                                onPressed: () {
                                  provider.setEditedImage(null);
                                  getImageFromCamera(provider);
                                },
                                heroTag: 'cameraButton',
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 55,
                                  color: Colors.white,
                                ),
                              ),
                              SpeedDial(
                                closeDialOnPop: true,
                                useRotationAnimation: true,
                                direction: SpeedDialDirection.up,
                                tooltip: AppLocalizations.of(context)!.save,
                                curve: Curves.bounceInOut,
                                animationDuration:
                                    const Duration(milliseconds: 300),
                                spaceBetweenChildren: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                backgroundColor: Colors.white,
                                icon: Icons.save_alt_rounded,
                                buttonSize: const Size(40, 40),
                                iconTheme: const IconThemeData(
                                    size: 40, color: Colors.blue),
                                children: [
                                  SpeedDialChild(
                                    // onTap: () => Navigator.pop(context),
                                    labelWidget: ElevatedButton(
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                  Colors.blue)),
                                      onPressed: () {
                                        _handleSave(provider, 'txt');
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!.txt,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Icon(
                                            Icons.text_fields_rounded,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SpeedDialChild(
                                    labelWidget: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                  Colors.red[400])),
                                      onPressed: () {
                                        _handleSave(provider, 'pdf');
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!.pdf,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const Icon(
                                            Icons.picture_as_pdf_rounded,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SpeedDialChild(
                                    labelWidget: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                  Colors.green[400])),
                                      onPressed: () {
                                        _handleSave(provider, 'docx');
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!.docx,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          const SizedBox(
                                            width: 9,
                                          ),
                                          const Icon(
                                            Icons.edit_document,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
