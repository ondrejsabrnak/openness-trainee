# Openness trainee homework

In this document, I describe how I proceeded in solving the assigned task.

## Flask App

First, I created a simple Flask application using [Skeleton](http://getskeleton.com). 
#### Here is the app structure:

```
📦 app
│   📜 main.py
│
└─── 📂 static
│   └─── 📂 css
│       │   📜 normalize.css
│       │   📜 skeleton.css
│   └─── 📂 images
│       │   📜 celebration.gif
│
└─── 📂 templates
    │   📜 index.html
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

#### Deployment openness-trainee
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    deployment.kubernetes.io/revision: "1"
  creationTimestamp: "2021-06-10T17:36:10Z"
  generation: 1
  labels:
    app: openness-trainee
  name: openness-trainee
  namespace: default
  resourceVersion: "1208"
  selfLink: /apis/apps/v1/namespaces/default/deployments/openness-trainee
  uid: 91ed7f16-d42d-47ed-b0e2-812eae3cbf82
spec:
  progressDeadlineSeconds: 600
  replicas: 3
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: openness-trainee
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: openness-trainee
    spec:
      containers:
      - image: osabrnak/openness-trainee
        imagePullPolicy: Always
        name: openness-trainee-1
        resources: {}
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
status:
  availableReplicas: 3
  conditions:
  - lastTransitionTime: "2021-06-10T17:36:35Z"
    lastUpdateTime: "2021-06-10T17:36:35Z"
    message: Deployment has minimum availability.
    reason: MinimumReplicasAvailable
    status: "True"
    type: Available
  - lastTransitionTime: "2021-06-10T17:36:10Z"
    lastUpdateTime: "2021-06-10T17:36:35Z"
    message: ReplicaSet "openness-trainee-789756d86" has successfully progressed.
    reason: NewReplicaSetAvailable
    status: "True"
    type: Progressing
  observedGeneration: 1
  readyReplicas: 3
  replicas: 3
  updatedReplicas: 3
```
#### Service openness-trainee
```yaml
apiVersion: v1
kind: Service
metadata:
  annotations:
    cloud.google.com/neg: '{"ingress":true}'
  creationTimestamp: "2021-06-10T17:37:40Z"
  finalizers:
  - service.kubernetes.io/load-balancer-cleanup
  labels:
    app: openness-trainee
  name: openness-trainee-service
  namespace: default
  resourceVersion: "2100"
  selfLink: /api/v1/namespaces/default/services/openness-trainee-service
  uid: d5a896a9-66ca-4e67-aad6-af804f98286d
spec:
  clusterIP: 10.4.9.3
  externalTrafficPolicy: Cluster
  ports:
  - nodePort: 30347
    port: 5000
    protocol: TCP
    targetPort: 5000
  selector:
    app: openness-trainee
  sessionAffinity: None
  type: LoadBalancer
status:
  loadBalancer:
    ingress:
    - ip: 34.116.224.146
```
