from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.responses import FileResponse
from PIL import Image
import os
import uvicorn

app = FastAPI()

# Путь для временного хранения изображений
UPLOAD_DIR = "uploads"
PROCESSED_FILE = os.path.join(UPLOAD_DIR, "processed_image.png")

os.makedirs(UPLOAD_DIR, exist_ok=True)

# Задаем максимальный размер файла в байтах
MAX_FILE_SIZE = 5 * 1024 * 1024

@app.post("/upload")
async def upload_image(file: UploadFile):
    """
    'Этот метод загружает изображение в формате JPEG или PNG на "сервер",
    проверяет размер файла и формат; если файл больше 5 МБ или неверного формата — возвращаем ошибку
    """
    if file.content_type not in ["image/jpeg", "image/png"]:
        raise HTTPException(status_code=400, detail="Допустимы только JPEG и PNG файлы")

    contents = await file.read()
    if len(contents) > MAX_FILE_SIZE:
        raise HTTPException(status_code=400, detail="Размер файла превышает 5 МБ")

    # Сохраняем файл на диск
    filepath = os.path.join(UPLOAD_DIR, "original_image")
    with open(filepath, "wb") as f:
        f.write(contents)

    return {"message": "Изображение загружено"}

@app.get("/process")
def process_image(new_height = 224, new_weight = 224):
    """
    Этот метод изменяет размер изображения и преобразовывает его в чёрно-белое), 
    после этого возвращает обработанный файл.
    """
    input_path = os.path.join(UPLOAD_DIR, "original_image")
    if not os.path.exists(input_path):
        raise HTTPException(status_code=404, detail="Изображение не найдено")

    try:
        with Image.open(input_path) as img:
            # Преобразуем размер изобпажения
            resize_img = img.resize((int(new_height), int(new_weight)))
            # Преобразуем изображение в чёрно - белое
            bw_sesize_img = resize_img.convert("L")
            bw_sesize_img.save(PROCESSED_FILE, format = 'PNG')
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Ошибка обработки изображения: {str(e)}")

    return FileResponse(PROCESSED_FILE, media_type="image/png", filename="new_image.png")


#Для заупска fastapi приложения в браузере
if __name__ == "__main__":
    uvicorn.run(app = "main:app",  reload=True)