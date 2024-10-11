import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ImageService {
  Future<Uint8List?> uploadImage(File selectedImage) async {
    try {
      String apiUrl = 'http://localhost_or_ipv4adress/process-image';
      String fileName = selectedImage.path.split('/').last;

      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(selectedImage.path,
            filename: fileName),
      });

      Dio dio = Dio(BaseOptions(
        connectTimeout: const Duration(milliseconds: 10000),
        receiveTimeout: const Duration(milliseconds: 30000),
      ));

      Response response = await dio.post(
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
        print("Hata oluştu: $e");
      }
    }
    return null;
  }
}
