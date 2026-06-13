Write-Host "project is being installed..." -ForegroundColor Cyan
if (!(Test-Path "src/artisan")) {laravel new src}

Write-Host "Project is configurating..." -ForegroundColor Cyan
Copy-Item "./.env" "src/.env" -Force
Write-Host ".env configurated" -ForegroundColor Green
Copy-Item "./vite.config.js" "src/vite.config.js" -Force
Write-Host "vite.config.js configurated" -ForegroundColor Green

Write-Host "Cleaning local files..." -ForegroundColor Cyan
if (Test-Path "src/vendor") { Remove-Item -Recurse -Force "src/vendor" }
if (Test-Path "src/node_modules") { Remove-Item -Recurse -Force "src/node_modules" }

Write-Host "Containers are starting..." -ForegroundColor Cyan
docker compose up -d --build

Write-Host "Waiting for containers to finish processes..." -ForegroundColor Cyan
Start-Sleep -Seconds 30

Write-Host "Installing PHP dependencies inside container..." -ForegroundColor Cyan
docker compose exec -T laravel composer install

Write-Host "Laravel is configurating..." -ForegroundColor Cyan
docker compose exec -T laravel php artisan key:generate
docker compose exec -T laravel php artisan storage:link
docker compose exec -T laravel php artisan migrate:fresh --seed

Write-Host "Installing frontend..." -ForegroundColor Cyan
docker compose exec -T vite npm install
docker compose exec -T vite npm install bootstrap

Write-Host "Starting Vite development server..." -ForegroundColor Green
docker compose exec -d vite npm run dev

Write-Host "Development environment set successfully" -ForegroundColor Green


Write-Host "Opening project directly inside Docker Container via VS Code..."  -ForegroundColor Cyan
code --folder-uri="vscode-remote://attached-container+4170705f4c61726176656c/var/www"

