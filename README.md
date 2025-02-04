### **📌 TastyIgniter Docker Setup**
This repository provides a **Dockerized setup** for running **TastyIgniter** using **Nginx, PHP-FPM, and MariaDB**.

#### **📝 Prerequisites**
Ensure you have the following installed:
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Git](https://git-scm.com/)

---

## **🚀 Installation Steps**

### **1️⃣ Clone This Repository**
First, pull this repository, which contains the `docker-compose.yml` and `Dockerfile`:
```bash
git clone https://github.com/AndyYangUK/tastyigniter-docker.git
cd tastyigniter-docker
```

### **2️⃣ Download TastyIgniter**
Inside the `tastyigniter-docker` directory, **clone the TastyIgniter application** into the `/app` folder:
```bash
git clone https://github.com/tastyigniter/TastyIgniter.git app
```

Alternatively, you can manually **download** the latest release from:
- **[TastyIgniter Releases](https://github.com/tastyigniter/TastyIgniter/releases)**  
- Extract the files into the `app/` folder.

---

### **3️⃣ Build and Run the Containers**
Go back to the `tastyigniter-docker` root directory and start the containers:
```bash
cd ..
docker-compose up -d --build
```
This will:
- **Build the `app` container** using the `Dockerfile`
- **Pull the `nginx` and `mariadb` images** if not already available
- **Run the containers in detached mode (`-d`)**

---

### **4️⃣ Install Dependencies and Setup TastyIgniter**
Run the following command inside the `app` container:
```bash
docker exec -it tastyigniter-app bash -c "
composer install --no-dev --optimize-autoloader &&
php artisan igniter:install --no-interaction"
```

After installation, **clear the cache**:
```bash
docker exec -it tastyigniter-app bash -c "
php artisan config:clear &&
php artisan cache:clear &&
php artisan view:clear"
```

---

### **5️⃣ Access the Application**
Once setup is complete, you can access **TastyIgniter** in your browser:

**Admin Panel:**  
👉 [http://localhost:8080/admin](http://localhost:8080/admin)  

**Default Login Credentials:**
- **Username:** `admin`
- **Password:** `admin123` _(if no custom password was set)_

If you need to **reset the admin password**, run:
```bash
docker exec -it tastyigniter-app php artisan igniter:pass admin newpassword
```
Replace `newpassword` with your desired password.

---

### **6️⃣ (Optional) Configure a Reverse Proxy**
If you are running this behind an **Nginx/Apache reverse proxy**, ensure you set the correct `APP_URL` in the environment variable:
```docker-compose.yml
APP_URL=https://yourdomain.com
```
And restart the containers:
```bash
docker-compose restart
```

---

## **🛠️ Useful Docker Commands**
### **Stop Containers**
```bash
docker-compose down
```
Stops all running containers.

### **Restart Containers**
```bash
docker-compose restart
```
Restarts all services.

### **View Logs**
```bash
docker logs -f tastyigniter-app
```
Shows real-time logs from the application.

---

## **💡 Troubleshooting**
### **"500 Internal Server Error"**
- Run:
  ```bash
  docker exec -it tastyigniter-app bash -c "php artisan cache:clear && php artisan config:clear && php artisan view:clear"
  ```
- Check logs:
  ```bash
  docker logs tastyigniter-app
  ```

### **"Database Connection Refused"**
- Ensure the database container is running:
  ```bash
  docker ps
  ```
- Try restarting:
  ```bash
  docker-compose restart db
  ```

---

## **📄 License**
This project follows the **MIT License** as per [TastyIgniter's licensing](https://github.com/tastyigniter/TastyIgniter/blob/master/LICENSE).
