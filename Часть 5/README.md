1) Построить Image командой в командной строке:
docker build -t fastapi_docker  <директория в которой лежит Dockerfile>

2) Запустить построенный Image командой:
docker run -p 5000:5000 fastapi_docker 

3) По ссылке: http://localhost:5000/docs
Должно запуститься fastapi приложение


Как клонировать с GitHub
1) Зайти в нужную папку, куда будем клонировать проект
2) В этой папке открыть терминал
3) в терминале выполнить команду git clone https://github.com/mikhail200008/Test_task