import 'dart:io';
import 'dart:typed_data';
import 'package:cat_detection_app/images_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedFile;
  Uint8List? _processedImageBytes;
  final ImageService _imageService = ImageService();
  VideoPlayerController? _videoPlayerController;
  bool _isVideo = false;
  bool _isProcessed = false; // İşlenmiş içerik olup olmadığını belirlemek için

  Future<void> pickFile() async {
    final XFile? pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 85,
        ) ??
        await _picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _isVideo = pickedFile.path.endsWith('.mp4');
        _selectedFile = File(pickedFile.path);
        _processedImageBytes = null;
        _isProcessed = false;

        // Eğer video seçildiyse mevcut video kontrolcüsünü temizliyoruz
        if (_videoPlayerController != null) {
          _videoPlayerController!.dispose();
          _videoPlayerController = null;
        }

        // Eğer video seçildiyse VideoPlayerController'i başlatıyoruz
        if (_isVideo) {
          _videoPlayerController = VideoPlayerController.file(_selectedFile!)
            ..initialize().then((_) {
              setState(() {
                _videoPlayerController!.play();
              });
            });
        }
      });
    }
  }

  Future<void> processFile() async {
    if (_selectedFile == null) {
      return;
    }

    if (_isVideo) {
      await processVideo();
    } else {
      await processImage();
    }
  }

  Future<void> processImage() async {
    Uint8List? imageBytes = await _imageService.uploadImage(_selectedFile!);
    if (imageBytes != null) {
      setState(() {
        _processedImageBytes = imageBytes;
        _isProcessed = true;
      });
    }
  }

  Future<void> processVideo() async {
    if (_selectedFile == null) {
      print("Video seçilmedi.");
      return;
    }

    print("Video işleniyor: ${_selectedFile!.path}");

    // API'ye videoyu yükle ve işlenmiş videonun yolunu al
    String? processedVideoPath =
        await _imageService.uploadVideo(_selectedFile!);

    if (processedVideoPath != null) {
      print("İşlenmiş video kaydedildi ve yol alındı: $processedVideoPath");

      // İşlenmiş video dosyasını oynatmak için VideoPlayerController kullanıyoruz
      _videoPlayerController =
          VideoPlayerController.file(File(processedVideoPath));

      // Kontrolcüyü başlatıyoruz ve ekranı güncelliyoruz
      await _videoPlayerController!.initialize();
      setState(() {
        _isProcessed = true;
        _videoPlayerController!.play(); // Video otomatik olarak oynatılıyor
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Video başarıyla işlendi ve oynatılıyor!")),
      );
    } else {
      print("Video yükleme başarısız oldu.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Video yüklenirken hata oluştu.")),
      );
    }
  }

  @override
  void dispose() {
    // Video kontrolcüsünü dispose ederken temizliyoruz
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Object Detection And Tracking"),
      ),
      body: Column(
        children: [
          // Ortak bir container içinde hem video hem görseli göstermek için
          Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.65, // Ekranın yarısı
            color: Colors.white, // Medya alanı arka plan rengi
            child: _isProcessed
                ? _isVideo
                    ? _videoPlayerController != null &&
                            _videoPlayerController!.value.isInitialized
                        ? AspectRatio(
                            aspectRatio:
                                _videoPlayerController!.value.aspectRatio,
                            child: VideoPlayer(_videoPlayerController!),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          )
                    : _processedImageBytes != null
                        ? Image.memory(_processedImageBytes!)
                        : const Center(child: Text("İşlenmiş resim yok"))
                : _selectedFile != null
                    ? _isVideo
                        ? _videoPlayerController != null &&
                                _videoPlayerController!.value.isInitialized
                            ? AspectRatio(
                                aspectRatio:
                                    _videoPlayerController!.value.aspectRatio,
                                child: VideoPlayer(_videoPlayerController!),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              )
                        : Image.file(_selectedFile!)
                    : const Center(child: Text("Dosya seçilmedi")),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: pickFile,
                  child: const Text("Galeri Aç"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: processFile,
                  child: const Text("Algılama ve Takip"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
