# Laravel 13 & Docker Development Environment


This template aims to provide a fast and repeatable development environment by bringing together the essential services needed in the Laravel development process under a single Docker Compose structure. The project is a highly optimized Laravel 13 development environment tailored for Windows (Host). It leverages **Docker Volumes** and **VS Code Dev Containers** architecture to eliminate Windows filesystem drag (I/O bottlenecks) and prevent local disk bloat.


## Tech Stack

* PHP 8.4  
* Laravel 13
* Nginx
* MySQL 8
* Redis 8
* Node.js & NPM
* Vite
* Bootstrap 5
* Docker & Docker Compose


## 🚀 How It Works & Architecture

In traditional Docker setups on Windows, project files are mirrored into the container using standard bind mounts (`./src:/var/www`). However, vendor folders like `vendor` and `node_modules` consist of thousands of tiny files. Syncing these heavy folders between the Windows filesystem (NTFS) and the Linux container causes severe performance degradation.

This project implements a hybrid architecture to solve this:

* **Live Source Code (Bind Mount):** Your actual source files (`app/`, `routes/`, `resources/`, etc.) are shared dynamically between Windows and Docker. Any changes you make in Windows are reflected inside the container instantly.
* **Heavy Dependencies (Named Volumes):** The `vendor` and `node_modules` folders are completely isolated from Windows. They live inside isolated, high-speed Linux volumes (`Named/Anonymous Volumes`) managed entirely by Docker.



---

## 🛠️ The Installation Flow (What the Script Does)

The automation script (`setup.ps1`) executes the following steps seamlessly:

1.  **Laravel Installation (`laravel new`):** Downloads a clean Laravel 13 skeleton into the `src/` directory.
2.  **In-Flight Configuration:** Updates Docker-ready `.env`, optimized `vite.config.js` files directly from the script to avoid manual copy errors.
3.  **Pre-Cleaning:** Wipes out any residual `vendor` or `node_modules` folders on the Windows side *before* Docker starts. This ensures Docker boots up with a clean canvas.
4.  **Booting Containers (`docker compose`):** Builds/starts the environment cleanly.
5.  **In-Container Installation:** Triggers `composer install` and `npm install` *inside* the container. All heavy dependencies are compiled straight into Docker's sealed volume storage. It then finalizes app keys and storage symbolic links.
6.  **VS Code Remote Connection:** Executes `code --folder-uri` to seamlessly attach your local VS Code directly to the heartbeat of the Linux container (`/var/www`).

---

## 👨‍💻 Daily Development Rules

Because this ecosystem is completely isolated, you should **never** run PHP, Composer, or Node.js commands directly on your local Windows machine. 

### 1. Adding New Packages (Composer)
Whenever you want to pull in a package, open the built-in terminal inside VS Code (`Ctrl + \``). Since VS Code is attached to the Dev Container, this terminal is running directly inside Linux container App_Laravel. Run your PHP Laravel and Composer commands normally:

```bash
# To install a PHP package:
composer require laravel/sanctum
```

### 1. Adding New Packages (NPM)
Open an exec cli inside Linux container App_Vite. Run your Node, NPM and JS commands normally:

```bash
# To install a JavaScript package:
npm install sweetalert2
```
