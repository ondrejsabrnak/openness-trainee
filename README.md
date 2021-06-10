# Openness trainee homework

In this document, I describe how I proceeded in solving the assigned task.

## Flask App

First, I created a simple Flask application using Skeleton. 
#### Here is the app structure:

```
app
│   main.py
│
└─── static
│   └─── css
│       │   normalize.css
│       │   skeleton.css
│   └─── images
│       │   celebration.gif
│
└─── templates
    │   index.html
```

#### Main.py

```python
from flask import Flask, render_template, url_for

app = Flask(__name__)

@app.route("/")

def hello():
    return render_template("index.html")
```

## Docker
Then I created a Dockerfile.

```dockerfile
FROM python:3.8

WORKDIR /app
COPY . .

ENV FLASK_APP=./app/main.py
ENV FLASK_RUN_HOST=0.0.0.0

RUN pip install -r requirements.txt

CMD ["flask", "run"]
```

And also docker-compose.yaml to create a docker image and run the container.

```yaml
version: "3.9"

services:
    web:
        build: .
        image: openness_trainee
        ports:
            - 5000:5000
```
Then, I pushed the Docker image to the Docker Hub under the name  [osabrnak/openness-trainee](https://hub.docker.com/repository/docker/osabrnak/openness-trainee)  so that the image was public and I could integrate it to K8s.

## Kubernetes
I created a K8s cluster on the Google Cloud Engine and deployed the created docker image. Thanks to this, the Flask application is accessible at this [address](http://34.116.224.146:5000).
