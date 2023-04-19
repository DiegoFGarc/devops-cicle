FROM python:3.9-slim-buster

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

RUN export FLASK_RUN_PORT=5001
RUN export FLASK_APP=main.py
RUN export FLASK_ENV=development

COPY main.py main.py

EXPOSE 5001

CMD ["python3", "main.py", "runserver", "--debug"]
