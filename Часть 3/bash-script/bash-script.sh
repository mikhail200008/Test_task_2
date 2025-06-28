#!/bin/bash

# Проверка, передан ли аргумент
if [ $# -eq 0 ]; then
    echo "Ошибка: Не указан путь к директории для резервного копирования."
    echo "Использование: $0 /путь/к/директории"
    exit 1
fi

SOURCE_DIR=$1
BACKUP_DIR="/backup"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/backup_$(basename "$SOURCE_DIR")_$DATE.tar.gz"

# Проверка существования исходной директории
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Ошибка: Директория '$SOURCE_DIR' не существует."
    exit 1
fi

# Создание папки для бэкапов, если её нет
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
    if [ $? -ne 0 ]; then
        echo "Ошибка: Не удалось создать директорию для бэкапов '$BACKUP_DIR'."
        exit 1
    fi
fi

# Создание архива
echo "Создание резервной копии директории '$SOURCE_DIR'..."
tar -czf "$BACKUP_FILE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"

if [ $? -eq 0 ]; then
    echo "Резервная копия успешно создана: $BACKUP_FILE"
else
    echo "Ошибка при создании резервной копии."
    exit 1
fi

# Удаление архивов старше 7 дней
echo "Удаление резервных копий старше 7 дней..."
find "$BACKUP_DIR" -name "backup_$(basename "$SOURCE_DIR")_*.tar.gz" -type f -mtime +7 -delete

echo "Процесс завершен."