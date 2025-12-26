# ISE 465 - Bulut Tabanlı Snake Game Dağıtımı

## Mimari Şema

![Mimari Şema](architecture.svg)

Basitçe: Kullanıcı tarayıcısından internete, internetten AWS EC2 (Ubuntu 24.04) üzerinde çalışan Nginx'e bağlanır ve Nginx `index.html` dosyasını sunar.

## Kullanılan Teknolojiler

- AWS EC2
- Ubuntu 24.04
- Nginx
- HTML5
- JavaScript

## Otomasyon (Bonus Puan)

Sunucu kurulumu sırasında kullanılan komutlar `deploy.sh` dosyasında bulunmaktadır. EC2 üzerinde çalıştırmak için:

```bash
sudo bash deploy.sh
```

Script, temel olarak Nginx yüklemeyi, servisi başlatmayı ve varsa repo kökündeki `index.html` dosyasını `/var/www/html/index.html` konumuna kopyalamayı otomatikleştirir.

## Zorluklar

- Security Group ayarlarında TCP/80 (HTTP) ve TCP/22 (SSH) portlarının açılması gerekiyordu; AWS tarafında izinleri doğru şekilde vermek gerekiyor.
- SSH bağlantı izinleri (anahtar çiftleri) doğru ayarlanmamışsa `scp` veya doğrudan `ssh` bağlantıları başarısız oluyor.
- EC2 üzerinde UFW veya başka bir host tabanlı firewall varsa hem AWS Security Group hem de host firewall kurallarının uyumlu olması gerekiyor.

## Notlar

- `deploy.sh` çalıştırılmadan önce EC2 Security Group üzerinde HTTP (80) portunun açık olduğundan emin olun.
- Geliştirme için eklemek isterseniz HTTPS (443) ve sertifika otomasyonu için `certbot` adımlarını genişletebilirim.
