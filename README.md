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

### **Use Case:** A **Python Flask web application** with a UI to add and display entries, connected to **MySQL**, managed using **Docker Compose**.

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
│   ├── Dockerfile
│   └── templates/
│       └── index.html
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
, render_template, request, redirect, url_for
import mysql.connector
import os
import time

app = Flask(__name__)

def get_db_connection():
    """Create and return a database connection"""
    max_retries = 5
    retry_delay = 2
    
    for attempt in range(max_retries):
        try:
            connection = mysql.connector.connect(
                host=os.getenv("DB_HOST"),
                user=os.getenv("DB_USER"),
                password=os.getenv("DB_PASSWORD"),
                database=os.getenv("DB_NAME")
            )
            return connection
        except mysql.connector.Error as err:
            if attempt < max_retries - 1:
                print(f"Database connection attempt {attempt + 1} failed: {err}")
                time.sleep(retry_delay)
            else:
                raise

def init_db():
    """Initialize database and create table if it doesn't exist"""
    try:
        connection = get_db_connection()
        cursor = connection.cursor()
        
        # Create entries table
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS entries (
                id INT AUTO_INCREMENT PRIMARY KEY,
                title VARCHAR(255) NOT NULL,
                description TEXT NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """)
        
        connection.commit()
        cursor.close()
        connection.close()
        print("Database initialized successfully!")
    except Exception as e:
        print(f"Error initializing database: {e}")

@app.route("/")
def index():
    """Display all entries and the form to add new entries"""
    try:
        connection = get_db_connection()
        cursor = connection.cursor()
        
        # Fetch all entries
        cursor.execute("SELECT * FROM entries ORDER BY created_at DESC")
        entries = cursor.fetchall()
        
        cursor.close()
        connection.close()
        
        return render_template("index.html", entries=entries)
    except Exception as e:
You should see a beautiful UI with:
- ✅ A form to add new entries (title and description)
- ✅ Display all entries from MySQL database
- ✅ Statistics showing total entries
- ✅ Modern, responsive design with gradient colors

### Features

✨ **Add Entries**: Fill in the form with a title and description to add new entries to MySQL
✨ **View Entries**: All entries are displayed in cards below the form
✨ **Auto-Initialize**: Database table is automatically created on first run
✨ **Real-time Stats**: See the count of total entries
✨ **Responsive Design**: Works great on desktop and mobile devices
🎯 Key Features Implemented

✔ Full CRUD operations (Create and Read)
✔ HTML templating with Jinja2
✔ Form handling with Flask
✔ MySQL connection with retry logic
✔ Auto database initialization
✔ Modern, responsive UI design
✔ Error handling and user feedback

## 🔥 Interview + Training Talking Points

✔ Multi-container orchestration
✔ Service dependency (`depends_on`)
✔ Environment variables
✔ Volumes for persistence
✔ Internal Docker networking
✔ Production-ready structure
✔ Full-stack web application
✔ Database operations (INSERT, SELECT)
✔ MVC architecture pattern
✔ HTML/CSS responsive design.get("title")
        description = request.form.get("description")
        
        if not title or not description:
            return redirect(url_for("index"))
        
        connection = get_db_connection()
        cursor = connection.cursor()
        
        # Insert new entry
        cursor.execute(
            "INSERT INTO entries (title, description) VALUES (%s, %s)",
            (title, description)
        )
        
        connection.commit()
        cursor.close()
        connection.close()
        
        return redirect(url_for("index"))
    except Exception as e:
        print(f"Error adding entry: {e}")
        return redirect(url_for("index"))

if __name__ == "__main__":
    # Initialize database on startup
    init_db()
    
    # Run the Flask app
    app.run(host="0.0.0.0", port=5000, debug=True
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

## � Manually Check MySQL Entries

### View all entries in the database

```bash
docker exec -it mysql_db mysql -uroot -proot123 -D flaskdb -e "SELECT * FROM entries;"
```

### View table structure

```bash
docker exec -it mysql_db mysql -uroot -proot123 -D flaskdb -e "DESCRIBE entries;"
```

### Count total entries

```bash
docker exec -it mysql_db mysql -uroot -proot123 -D flaskdb -e "SELECT COUNT(*) FROM entries;"
```

### Show all databases

```bash
docker exec -it mysql_db mysql -uroot -proot123 -e "SHOW DATABASES;"
```

### Interactive MySQL shell

```bash
docker exec -it mysql_db mysql -uroot -proot123 flaskdb
```

Once inside the MySQL shell, you can run any SQL commands:
```sql
SELECT * FROM entries;
INSERT INTO entries (title, description) VALUES ('Manual Entry', 'Added via MySQL shell');
DELETE FROM entries WHERE id = 1;
EXIT;
```

---

## �🛑 Stop & Cleanup

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
