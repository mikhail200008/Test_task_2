#!/bin/bash

# Проверка, передан ли аргумент
if [ $# -eq 0 ]; then
    echo "Ошибка: Не указан путь к директории для резервного копирования."
    echo "Использование: $0 /путь/к/директории"
    exit 1
fi

SOURCE_DIR=$1
BACKUP_DIR="/d/PythonProjects/Тестовое 2/Часть 3/bash-script/backup"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_FILE="$BACKUP_DIR/backup_$(basename "$SOURCE_DIR")_$DATE.tar.gz"

# Проверка существования исходной директории
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Ошибка: Директория '$SOURCE_DIR' не существует."
    exit 1
fi

# Проверка прав на чтение исходной директории
if [ ! -r "$SOURCE_DIR" ]; then
    echo "Ошибка: Нет прав на чтение директории '$SOURCE_DIR'."
    exit 1
fi

# Создание директории для бэкапа
mkdir -p "$BACKUP_DIR"
if [ $? -ne 0 ]; then
    echo "Ошибка: Не удалось создать директорию для бэкапов '$BACKUP_DIR'."
    exit 1
fi

# Проверка на запись в директорию бэкапа
if [ ! -w "$BACKUP_DIR" ]; then
    echo "Ошибка: Нет прав на запись в директорию '$BACKUP_DIR'."
    exit 1
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