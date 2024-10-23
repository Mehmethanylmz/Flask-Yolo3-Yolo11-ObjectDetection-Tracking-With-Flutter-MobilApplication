from flask import Flask, request, send_file,jsonify
from tempfile import NamedTemporaryFile
from action_recognition import run
from PIL import Image
import io
import yolo_v3 



app = Flask(__name__)
@app.route('/process_image', methods=['POST'])
def process_image_route():
    if 'image' not in request.files:
        return "No image part", 400

    image_file = request.files['image']
    if image_file.filename == '':
        return "No selected file", 400
    try:
        image = Image.open(image_file)
        processed_image = yolo_v3.process_image(image)
        img_io = io.BytesIO()
        processed_pil_image = Image.fromarray(processed_image)
        processed_pil_image.save(img_io, 'PNG')
        img_io.seek(0)
        return send_file(img_io, mimetype='image/png')

    except Exception as e:
        print(e)
        return str(e), 500

@app.route('/process_video', methods=['POST'])
def process_video():
    if 'video' not in request.files:
        return jsonify({"error": "No video file found"}), 400

    # Video dosyasını al ve geçici bir dosyaya kaydet
    video_file = request.files['video']
    temp_video = NamedTemporaryFile(delete=False, suffix=".mp4")
    video_path = temp_video.name
    video_file.save(video_path)
    
    run(
        weights="yolo11n.pt",
        device="cpu",  # GPU'yu kullanmak için 'cuda' yazmak gerekir
        source= video_path,  # Girdi video dosyası
        output_path="output_video.mp4",  # İşlenmiş video çıkış dosyası
        crop_margin_percentage=10,
        num_video_sequence_samples=8,
        skip_frame=2,
        video_cls_overlap_ratio=0.25,
        fp16=False,
        video_classifier_model="microsoft/xclip-base-patch32",
        labels=["walking", "running", "jumping"]
    )
    

    # YOLOv8 Region Counter dosyasındaki fonksiyonu çağırarak videoyu işle
    processed_video_path = "output_video.mp4"

    # İşlenmiş videoyu API üzerinden döndür
    return send_file(processed_video_path, as_attachment=True, download_name="processed_video.mp4")


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000, use_reloader=False)
