<div align="center">
<h1>🚀 Docker Compose Project – Web App + Database</h1>
<p><strong>Built with ❤️ by <a href="https://github.com/atulkamble">Atul Kamble</a></strong></p>

<p>
<a href="https://codespaces.new/atulkamble/template.git">
<img src="https://github.com/codespaces/badge.svg" alt="Open in GitHub Codespaces" />
</a>
<a href="https://vscode.dev/github/atulkamble/template">
<img src="https://img.shields.io/badge/Open%20with-VS%20Code-007ACC?logo=visualstudiocode&style=for-the-badge" alt="Open with VS Code" />
</a>
<a href="https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/atulkamble/template">
<img src="https://img.shields.io/badge/Dev%20Containers-Ready-blue?logo=docker&style=for-the-badge" />
</a>
<a href="https://desktop.github.com/">
<img src="https://img.shields.io/badge/GitHub-Desktop-6f42c1?logo=github&style=for-the-badge" />
</a>
</p>

<p>
<a href="https://github.com/atulkamble">
<img src="https://img.shields.io/badge/GitHub-atulkamble-181717?logo=github&style=flat-square" />
</a>
<a href="https://www.linkedin.com/in/atuljkamble/">
<img src="https://img.shields.io/badge/LinkedIn-atuljkamble-0A66C2?logo=linkedin&style=flat-square" />
</a>
<a href="https://x.com/atul_kamble">
<img src="https://img.shields.io/badge/X-@atul_kamble-000000?logo=x&style=flat-square" />
</a>
</p>

<strong>Version 1.0.0</strong> | <strong>Last Updated:</strong> January 2026
</div>
---

### **Use Case**

A **Python Flask web application** connected to **MySQL**, managed using **Docker Compose**.

---

## 🏗️ Architecture Overview

![Image](https://docs.docker.com/compose/images/compose-application.webp)

![Image](https://cdn.hashnode.com/res/hashnode/image/upload/v1610136098758/vey2tFCDx.png)

![Image](https://media.geeksforgeeks.org/wp-content/uploads/20240715174859/Microservices-with-Docker-Containers.webp)

![Image](https://docs.docker.com/get-started/docker-concepts/running-containers/images/multi-container-apps.webp)

**Components**

* 🐍 Flask Web App
* 🗄️ MySQL Database
* 🔗 Docker network (auto-created)
* 📦 Volumes for persistent data

---

## 📁 Project Structure

```bash
docker-compose-project/
├── app/
│   ├── app.py
│   ├── requirements.txt
│   └── Dockerfile
├── docker-compose.yml
└── README.md
```

---

## 🐳 docker-compose.yml

```yaml
version: "3.9"

services:
  web:
    build: ./app
    container_name: flask_app
    ports:
      - "5000:5000"
    depends_on:
      - db
    environment:
      DB_HOST: db
      DB_USER: root
      DB_PASSWORD: root123
      DB_NAME: flaskdb

  db:
    image: mysql:8.0
    container_name: mysql_db
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root123
      MYSQL_DATABASE: flaskdb
    volumes:
      - mysql_data:/var/lib/mysql
    ports:
      - "3306:3306"

volumes:
  mysql_data:
```

---

## 🐍 Flask Application

### **app/app.py**

```python
from flask import Flask
import mysql.connector
import os

app = Flask(__name__)

@app.route("/")
def hello():
    db = mysql.connector.connect(
        host=os.getenv("DB_HOST"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        database=os.getenv("DB_NAME")
    )
    return "🚀 Flask + MySQL running via Docker Compose!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

---

## 📦 requirements.txt

```txt
flask
mysql-connector-python
```

---

## 🐳 Dockerfile (Flask App)

```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

CMD ["python", "app.py"]
```

---

## ▶️ Run the Project

```bash
docker compose up -d --build
```

### Verify

```bash
docker compose ps
docker logs flask_app
```

### Access App

```
http://localhost:5000
```

---

## 🛑 Stop & Cleanup

```bash
docker compose down
docker volume rm docker-compose-project_mysql_data
```

---

## 🔥 Interview + Training Talking Points

✔ Multi-container orchestration
✔ Service dependency (`depends_on`)
✔ Environment variables
✔ Volumes for persistence
✔ Internal Docker networking
✔ Production-ready structure

---
