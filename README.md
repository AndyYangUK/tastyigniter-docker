TastyIgniter v4 Docker for Coolify
==================================

This repository provides a lightweight, Dockerized setup for [TastyIgniter v4](https://tastyigniter.com/) (built on Laravel 11), optimized specifically for deployment via **Coolify**.

🚀 Features
-----------

*   **PHP 8.3-Apache** base image.
    
*   **Automated Installation**: Uses Composer to fetch the latest TastyIgniter core during the build process.
    
*   **Coolify Optimized**: Pre-configured for Docker Compose deployments with persistent volumes and health checks.
    
*   **Force HTTPS**: Pre-configured for reverse proxy environments to fix mixed content/styling issues.
    

🛠 Prerequisites
----------------

*   A server running **Coolify**.
    
*   A domain name pointed to your server with SSL enabled.
    

📦 Deployment via Coolify
-------------------------

1.  **Create New Resource**: In Coolify, select **New Resource** > **Public Repository**.
    
2.  **Link Repository**: Use https://github.com/AndyYangUK/tastyigniter-docker.
    
3.  **Build Pack**: Ensure it is set to **Docker Compose**.
    
4.  **Environment Variables**: Add the following in the Coolify dashboard for the app service:
    
    *   APP\_URL: https://your-domain.com
        
    *   SERVICE\_PASSWORD\_MYSQL: (A strong password for the database)
        
    *   APP\_KEY: (A 32-character base64 string, or generate one after deploy)
        
    *   FORCE\_HTTPS: true
        
5.  **Deploy**: Click Deploy.
    

🔧 Post-Installation Steps
--------------------------

Once the container status is **"Running"**, follow these steps to initialize the database:

### 1\. Run the Installer

Open the **Terminal** tab for the app container in Coolify and run:

`php artisan igniter:install`

*   **Database Host**: db
    
*   **Database Port**: 3306
    
*   **Database Name**: tastyigniter
    
*   **Database User**: igniter
    
*   **Password**: Use the SERVICE\_PASSWORD\_MYSQL value from your environment variables.
    

### 2\. Finalize Permissions

Ensure the webserver can write to the persistent volumes:

`chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/extensions /var/www/html/themes`

### 3\. Configure Cron Job (Scheduled Tasks)

TastyIgniter requires a cron job to process orders and notifications. In Coolify's **Scheduled Tasks** for the app service, add:

*   **Command**: php artisan schedule:run
    
*   **Frequency**: \* \* \* \* \* (Every minute)
    

📁 Persistence
--------------

The docker-compose.yaml is configured to persist the following directories. These will stay safe even when you redeploy your code:

*   /var/www/html/storage: Media uploads, logs, and system cache.
    
*   /var/www/html/extensions: Plugins installed via the Admin Marketplace.
    
*   /var/www/html/themes: Website designs and custom templates.
    
*   /var/lib/mysql: The MariaDB database data.
    

📄 License
----------

TastyIgniter is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).
