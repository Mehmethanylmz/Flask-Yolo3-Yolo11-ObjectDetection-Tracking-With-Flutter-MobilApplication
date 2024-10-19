import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class ImageService {
  String apiAdress = 'http://192.168.162.130:5000/';
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(milliseconds: 10000),
    receiveTimeout: const Duration(milliseconds: 30000),
  ));

  // Resim yükleme metodu
  Future<Uint8List?> uploadImage(File selectedImage) async {
    try {
      String apiUrl = '${apiAdress}process_image';
      String fileName = selectedImage.path.split('/').last;

      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(selectedImage.path,
            filename: fileName),
      });

      Response response = await _dio.post(
        apiUrl,
        data: formData,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        print("Görsel başarıyla yüklendi.");
        return Uint8List.fromList(response.data);
      } else {
        print(
            "Görsel yükleme başarısız oldu. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Resim yükleme sırasında hata oluştu: $e");
      }
    }
    return null;
  }

  Future<String?> uploadVideo(File selectedVideo) async {
    try {
      String apiUrl = '${apiAdress}process_video';
      String fileName = selectedVideo.path.split('/').last;

      // Video dosyasını form-data'ya ekliyoruz
      FormData formData = FormData.fromMap({
        "video": await MultipartFile.fromFile(selectedVideo.path,
            filename: fileName),
      });

      // Dio ile API'ye POST isteği gönderiyoruz
      Response response = await Dio().post(
        apiUrl,
        data: formData,
        options: Options(
          responseType: ResponseType
              .bytes, // Byte yanıt bekliyoruz çünkü video dosyası dönüyor
        ),
      );

      if (response.statusCode == 200) {
        print("Video başarıyla yüklendi ve işlenmiş video alındı.");

        // Geçici dizine kaydedilecek yol
        Directory tempDir = await getTemporaryDirectory();
        String tempPath = tempDir.path;
        String processedVideoPath = '$tempPath/processed_video.mp4';

        // Byte verisini dosya olarak kaydediyoruz
        File file = File(processedVideoPath);
        await file.writeAsBytes(response.data);

        print("İşlenmiş video dosyası kaydedildi: $processedVideoPath");

        return processedVideoPath; // Kaydedilen dosyanın yolunu döndürüyoruz
      } else {
        print(
            "Video yükleme başarısız oldu. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Video yükleme sırasında hata oluştu: $e");
    }
    return null; // Hata olursa null döndürülür
  }
}
