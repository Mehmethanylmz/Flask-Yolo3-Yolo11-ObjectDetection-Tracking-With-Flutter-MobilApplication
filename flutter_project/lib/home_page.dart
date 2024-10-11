import 'dart:io';
import 'dart:typed_data';
import 'package:cat_detection_app/images_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  Uint8List? _processedImageBytes;
  final ImageService _imageService = ImageService();

  Future<void> pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _processedImageBytes = null;
      });
    }
  }

  Future<void> uploadImage() async {
    if (_selectedImage == null) {
      return;
    }

    Uint8List? imageBytes = await _imageService.uploadImage(_selectedImage!);
    if (imageBytes != null) {
      setState(() {
        _processedImageBytes = imageBytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Görsel Yükleme"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_processedImageBytes != null)
              Image.memory(_processedImageBytes!)
            else if (_selectedImage != null)
              Image.file(_selectedImage!)
            else
              const Text("Henüz bir görsel seçmediniz."),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Galeriden Görsel Seç"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadImage,
              child: const Text("Görseli Yükle"),
            ),
          ],
        ),
      ),
    );
  }
}
