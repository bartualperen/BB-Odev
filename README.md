ISE 465 - Bulut Bilişim Dersi 2. Ödev Raporu
1. Özet ve Amaç

Bu proje, ISE 465 Bulut Bilişim dersi kapsamında, bulut bilişim kavramlarını uygulamalı olarak anlamak amacıyla geliştirilmiştir. Çalışma; tek dosyadan oluşan bir web uygulamasının (Snake Game) modern bulut sağlayıcı platformları kullanılarak yayına alınması, güvenliğinin yapılandırılması ve dağıtım sürecinin otomatize edilmesini kapsamaktadır.

2. Proje Açıklaması ve Hedefleri

Projenin temel hedefleri şunlardır:

	Erişilebilirlik: Yerel ortamda geliştirilen bir uygulamanın genel internet trafiğine açılması.

Otomasyon: Manuel kurulum hatalarını en aza indirmek için dağıtım süreçlerinin scriptler aracılığıyla yürütülmesi.

Güvenlik: Bulut ortamında port yönetimi ve erişim kontrollerinin (Security Groups) yapılandırılması.

Maliyet Yönetimi: Ücretsiz plan (Free Tier) kaynaklarını kullanarak verimli bir mimari oluşturmak.

3. Uygulama Seçimi

Dağıtım için HTML5 ve JavaScript tabanlı, tek dosyadan oluşan bir Snake (Yılan) Oyunu seçilmiştir.

	Neden: Minimal bağımlılık gerektirmesi sayesinde bulut platformundaki web sunucusu (Nginx) konfigürasyonuna ve dağıtım adımlarına odaklanmayı kolaylaştırmaktadır.

4. Kullanılan Teknolojiler ve Bulut Platformu

Ödev gereksinimleri doğrultusunda aşağıdaki teknolojiler tercih edilmiştir:

	Bulut Sağlayıcı: Amazon Web Services (AWS).

Servis: AWS EC2 (Elastic Compute Cloud).

İşletim Sistemi: Ubuntu 24.04 LTS.

	Web Sunucusu: Nginx.

	Versiyon Kontrol: Git & GitHub.

5. Uygulama Mimari Şeması

Uygulamanın bulut üzerindeki çalışma mantığı aşağıdaki gibidir:

Kullanıcı (Tarayıcı) --> İnternet --> AWS Security Group (Port 80) --> EC2 Instance (Nginx) --> index.html
6. Adım Adım Kurulum ve Dağıtım Notları

Uygulamanın yerel ortamdan buluta taşınma süreci şu adımlarla gerçekleştirilmiştir:

6.1. AWS EC2 Yapılandırması

	AWS Konsolu üzerinden bir EC2 instance başlatıldı (Free Tier uyumlu t2.micro).

	Güvenlik için bir .pem anahtar çifti oluşturuldu.

6.2. Security Group (Güvenlik Grubu) Ayarları

Uygulamanın erişilebilir olması için aşağıdaki kurallar tanımlanmıştır:

	HTTP (Port 80): 0.0.0.0/0 (Her yerden gelen web trafiğine izin verildi).

	SSH (Port 22): Yönetimsel erişim için aktif edildi.

6.3. Uygulamanın Dağıtımı

Sunucuya SSH ile bağlanıldı ve terminal üzerinden işlemler tamamlandı:

Bash

chmod 400 key.pem
ssh -i "key.pem" ubuntu@13.61.187.227
git clone https://github.com/bartualperen/BB-Odev.git
cd BB-Odev
sudo bash deploy.sh

7. Otomasyon (deploy.sh)

Dağıtım sürecini otomatize etmek için kullanılan script içeriği aşağıdadır:

Bash

#!/bin/bash
# Paket listelerini güncelle
sudo apt update -y
# Nginx kurulumu
sudo apt install nginx -y
# Nginx servisini başlat ve boot sırasında çalışması için ayarla
sudo systemctl start nginx
sudo systemctl enable nginx
# Uygulama dosyasını Nginx dizinine kopyala
sudo cp index.html /var/www/html/index.html

8. Karşılaşılan Zorluklar ve Çözümler

	Erişim Sorunu: Başlangıçta HTTP portu kapalı olduğu için IP üzerinden erişim sağlanamadı; AWS Security Group ayarları güncellenerek çözüldü.

	İzin Hataları: Dosya kopyalama sırasında permission denied hatası alındı; sudo yetkileri script içerisine dahil edilerek çözüldü.

9. Öğrenilen Dersler ve Olası İyileştirmeler

Öğrenilen Dersler:

	Bulut altyapısında güvenlik gruplarının (firewall) yanlış yapılandırılmasının uygulamanın erişilebilirliğini doğrudan engellediği görüldü.

	deploy.sh gibi otomasyon araçlarının, sunucu kurulum süresini kısalttığı ve hata payını düşürdüğü deneyimlendi.

Olası İyileştirmeler:

	SSL/TLS: Veri güvenliği için Certbot kullanılarak HTTPS protokolüne geçilebilir.

	CI/CD: GitHub Actions entegrasyonu ile kod her güncellendiğinde sunucuya otomatik dağıtım yapılabilir.

	Elastic IP: Sunucu her yeniden başladığında IP değişimini önlemek için sabit bir IP atanabilir.

10. Sunum Videosu

Ödevin anlatımını ve çalışan demonun gösterimini içeren video bağlantısı:

	YouTube Linki: [Linkinizi Buraya Yapıştırın]
