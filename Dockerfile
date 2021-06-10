FROM python:3.8

WORKDIR /app
COPY . .

ENV FLASK_APP=./app/main.py
ENV FLASK_RUN_HOST=0.0.0.0

RUN pip install -r requirements.txt

CMD ["flask", "run"]