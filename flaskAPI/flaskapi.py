from flask import Flask, request, send_file
from PIL import Image
import io
import yolo_v3 



app = Flask(__name__)
@app.route('/process-image', methods=['POST'])
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
        return str(e), 500


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000, use_reloader=False)
