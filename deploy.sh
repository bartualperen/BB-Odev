set -euo pipefail

echo "Güncelleniyor ve Nginx kuruluyor..."
sudo apt update
sudo apt install -y nginx

echo "Nginx etkinleştiriliyor ve başlatılıyor..."
sudo systemctl enable --now nginx

if command -v ufw >/dev/null 2>&1; then
  sudo ufw allow 'Nginx Full' || true
fi

if [ -f index.html ]; then
  echo "index.html bulunuyor, /var/www/html konumuna kopyalanıyor..."
  sudo cp index.html /var/www/html/index.html
  sudo chown www-data:www-data /var/www/html/index.html
fi

echo "Kurulum tamam. Lütfen AWS Console üzerinden Security Group ayarlarından TCP/80 (HTTP) ve TCP/22 (SSH) portlarının açık olduğunu doğrulayın."