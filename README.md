# ISE 465 - Bulut Bilişim Dersi 2. Ödev Raporu

## 1. Özet

Bu çalışma tek dosyadan oluşan HTML5/JavaScript tabanlı bir Snake oyununun AWS EC2 (Ubuntu 24.04) üzerinde Nginx ile dağıtımını içermektedir. Amaç, bulut üzerinde basit bir web uygulamasının dağıtımı, güvenlik yapılandırması ve otomasyon adımlarının belgelenmesidir.

## 2. Uygulama Seçimi

Seçilen uygulama: Tek dosyalık HTML ve JavaScript ile yazılmış Snake (Yılan) oyunu (`index.html`). Minimal bağımlılık gerektirdiği için dağıtım ve değerlendirme için uygundur.

## 3. Bulut Platformu

Platform: AWS (Amazon Web Services)

- Servis: EC2 (Ubuntu 24.04)
- Web sunucusu: Nginx

## 4. Uygulama Mimari Şeması

Kullanıcı -> İnternet -> AWS Security Group (Port 80 açık) -> EC2 (Nginx) -> `index.html`

Detaylı şema dosyası: [architecture.svg](architecture.svg)

## 5. Adım Adım Kurulum Notları

1. EC2 Instance oluşturma
	- Ubuntu 24.04 AMI seçildi.
	- Uygun instance tipi seçildi (test için t2.micro / t3.micro önerilir).
	- Bir anahtar çifti (key pair) oluşturuldu ve `.pem` dosyası indirildi.

2. Security Group yapılandırması
	- TCP/80 (HTTP) kuralı: Kaynak 0.0.0.0/0 (dış dünyadan erişim). Bu izin verilmeden tarayıcıdan EC2 IP'sine erişim sağlanamaz.
	- TCP/22 (SSH) kuralı: Yönetim için gerekli. Üretimde yalnızca belirli IP'lere izin verilmesi tavsiye edilir.

3. Sunucuya SSH ile bağlanma

```bash
chmod 400 mykey.pem
ssh -i mykey.pem ubuntu@<EC2_PUBLIC_IP>
```

4. Depoyu çekme ve otomasyon

```bash
git clone https://github.com/<kullanici>/<repo>.git
cd <repo>
sudo bash deploy.sh
```

`deploy.sh` betiği sistem güncellemelerini yapar, Nginx'i kurar, servisi başlatır ve repo kökündeki `index.html` dosyasını `/var/www/html/index.html` olarak kopyalar.

## 6. Otomasyon (`deploy.sh`)

Bu ödevde otomasyon zorunludur. `deploy.sh` aşağıdaki işlevleri otomatikleştirir:

- Paket listelerini güncelleme ve temel paketlerin kurulumu (`apt update && apt upgrade`).
- Nginx kurulumu ve servisin başlatılması.
- Repo kökündeki `index.html` dosyasının Nginx'in sunacağı dizine kopyalanması.

Örnek (kısmi) içerik:

```bash
#!/bin/bash
set -e
sudo apt update
sudo apt -y upgrade
sudo apt -y install nginx
sudo systemctl enable --now nginx
sudo cp index.html /var/www/html/index.html
```

## 7. Karşılaşılan Zorluklar ve Çözümler

- Port 80 erişimi kapalıydı: AWS Security Group üzerinde TCP/80 açılarak sorun çözüldü.
- SSH izinleri hatası: `.pem` dosyasının izinleri uygun değildi; `chmod 400` uygulandı ve bağlantı sağlandı.
- Dinamik Public IP: EC2 restart sonrası IP değişimi yaşandı; bu durum rapor/erişim hedefleri için Elastic IP kullanılarak çözülebilir.

## 8. Güvenlik Notları

- Security Group'lar gelen trafiği kontrol eder; gereksiz açık port bırakmayın.
- SSH anahtarlarını güvenle saklayın, `.pem` dosyasına sadece gerekli izinleri verin (`chmod 400`).
- Üretim ortamında SSH erişimini sadece yönetici IP'leriyle sınırlandırın.

## 9. Öğrenilen Dersler

- Bulut altyapısında ilk savunma hattı Security Group'lardır; doğru yapılandırma erişim sağlar veya engeller.
- Otomasyon (deploy.sh) dağıtımı tekrarlanabilir ve hızlı yapar; manuel adım sayısını azaltır.
- Kaynak yönetimi ve maliyet takibi önemlidir — kullanılmayan EC2/Elastic IP kaynakları maliyete yol açar.

## 10. Sunum Videosu

Sunum ve demo videosu: [YouTube Linki Buraya]

---

Bu raporu daha akademik bir formatta (başlıklarda numaralandırma, özet, sonuç vb.) genişletebilirim veya `architecture.svg` görselini oluşturup repo'ya ekleyebilirim. Ayrıca isterseniz `deploy.sh` dosyasının tam içeriğini README içinde gösterebilirim.
