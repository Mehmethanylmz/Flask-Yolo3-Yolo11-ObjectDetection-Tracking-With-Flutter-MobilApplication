# 📱 Mobil Uygulama ile Nesne Tespiti ve Takibi

Bu proje, **mobil bir uygulama** aracılığıyla resim ve video gönderilmesini sağlar. Gönderilen **resimler üzerinde YOLOv3 modeli** kullanılarak nesne tespiti yapılırken, **videolar üzerinde YOLOv11 ile nesne takibi** gerçekleştirilmektedir. Mobil uygulama ile YOLO işlemleri arasındaki iletişim, bir **Flask API** aracılığıyla sağlanmaktadır.

---

## 🚀 Proje Özellikleri

- **📷 Resim Gönderimi**: Mobil uygulama ile gönderilen resimler, YOLOv3 kullanılarak nesne tespitinden geçer.
- **🎥 Video Gönderimi**: Videolar, YOLOv11 kullanılarak nesne takibi yapılır.
- **🔗 Flask API**: Mobil uygulama ile nesne tespiti ve takibi işlemleri, Flask API üzerinden yürütülür.

---

## 🛠️ Kurulum

Projeyi kendi bilgisayarınızda çalıştırmak için aşağıdaki adımları takip edebilirsiniz:

### 1. Projeyi Klonlayın

Öncelikle projeyi GitHub üzerinden klonlayın:

```bash
git clone https://github.com/Mehmethanylmz/Flask-Yolo3-Yolo11-ObjectDetection-Tracking-With-Flutter-MobilApplication.git 
```

### 2. Gerekli Python Kütüphanelerini Kurun
Flask API'nin çalışabilmesi için gerekli Python kütüphanelerini kurmanız gerekmektedir. 
### 3. YOLOv3 Model Dosyasını İndirin
Proje için gerekli YOLOv3 model dosyasını flaskAPI/data klasörü içerisine indirmeniz gerekmektedir. Aşağıdaki adımları takip ederek model dosyasını indirin:
* YOLOv3 Model Dosyasını İndirin.
* Dosyayı flaskAPI/data dizinine yerleştirin.
### 4. Flask API'yi Çalıştırın
Flask API'yi çalıştırmak için projenin flaskAPI klasörüne gidin ve şu komutu çalıştırın:
```bash
python flaskapi.py
```
Bu işlemden sonra terminalde bir yerel adres (örneğin http://127.0.0.1:5000/) göreceksiniz. Bu adres, mobil uygulamanızın bağlanacağı API adresidir.

### 5. Mobil Uygulama için Flutter Projesini Açın
Mobil uygulamayı geliştirmek için flutter_project klasörünü açın ve Flutter için kullandığınız bir IDE'de (örneğin, Visual Studio Code) çalıştırın.

### 6. Mobil Uygulama ile API Entegrasyonu
Terminalde gördüğünüz yerel API adresini, flutter_project dosyası içindeki imageservice.dart dosyasındaki localhost kısmına yapıştırın.

Not: Eğer bir emülatör kullanıyorsanız, localhost yerine 10.0.2.2 adresini kullanmanız gerekmektedir.

### 7. Projeyi Çalıştırın
Tüm bu adımları tamamladıktan sonra, mobil uygulamayı bir emülatör veya gerçek cihaz üzerinde çalıştırabilirsiniz.
