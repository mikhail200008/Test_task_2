FROM python:3.10-slim

WORKDIR /app

COPY /app/main.py /app/main.py
COPY /app/requirements.txt /app

RUN pip install --no-cache-dir -r requirements.txt

RUN mkdir -p /app/uploads

EXPOSE 5000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5000"]