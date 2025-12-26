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

## Teknik Detaylar (Rapor İçin)

- **Security Group (Güvenlik Grubu) Ayarları:** EC2 panelinde HTTP için TCP/80 portunu dış dünyaya açtım (kaynak 0.0.0.0/0). Bunu yapmasaydım, tarayıcıya EC2 IP adresini yazdığınızda oyun yüklenmezdi çünkü gelen HTTP trafiği bloke edilmiş olurdu. Benzer şekilde SSH erişimi için TCP/22 portunu yalnızca gerekli adreslere veya test ortamı için genişçe açtım; üretimde IP kısıtlaması tavsiye edilir.

- **SSH Bağlantı İzinleri:** İndirdiğim `.pem` anahtar dosyasına sunucudan erişmeden önce yerel makinada izinleri `chmod 400 mykey.pem` ile kısıtladım. Sunucuya bağlanmak için kullandığım örnek komut:

```bash
ssh -i mykey.pem ubuntu@<EC2_PUBLIC_IP>
```

Bu izinlerin doğru olmaması durumunda SSH istemcisi bağlantıyı reddeder.

- **Statik IP / Elastic IP:** Eğer EC2 instance'ı kapatıp başlattığınızda genel IP (public IP) değişiyorsa, bu bir zorluktur — özellikle rapor/ödev bağlantıları için. Bunu çözmek için EC2'ye bir Elastic IP atamak gerekir; Elastic IP atanmamışsa IP değişimini "iyileştirme önerisi" olarak rapora ekleyin.

## Rapor İçeriği (Sunulacak Başlıklar)

**Uygulama Mimari Şeması:** Kullanıcı -> İnternet -> AWS Security Group -> EC2 (Nginx + Snake App) akışını gösteren basit bir şema (bkz. `architecture.svg`).

**Adım Adım Uygulama Notları:**

- GitHub reposunun oluşturulması: Bu repo oluşturuldu ve kaynak kod (`index.html` vb.) eklendi.
- AWS EC2 Instance ayağa kaldırılması: Ubuntu 24.04 AMI seçildi, instance tipi ve anahtar çifti belirlendi.
- Güvenlik ayarlarının yapılması: Security Group üzerinde TCP/22 (SSH) ve TCP/80 (HTTP) izinleri tanımlandı. (Prod için 22'yi kısıtlamanızı öneririm.)
- `git clone` ve `deploy.sh` ile kurulum: Sunucuya bağlandıktan sonra repoyu klonlayıp `deploy.sh` çalıştırarak Nginx kurulumu ve dosya yerleştirmesini otomatikleştirdim.

Örnek kurulum adımları (EC2 üzerinde):

```bash
# sunucuya bağlandıktan sonra
git clone https://github.com/<kullanici>/<repo>.git
cd <repo>
sudo bash deploy.sh
```

## Otomasyon Kodları

Otomasyon olarak yazdığım `deploy.sh` scripti, Nginx kurulumunu, servis başlatmayı ve repo kökündeki `index.html` dosyasını `/var/www/html/index.html` olarak kopyalamayı içerir. Otomasyon ödev gereksinimi nedeniyle bu script raporda ayrı bir başlık altında vurgulanmalıdır.

## Öğrenilen Dersler

- **Güvenlik Gruplarının Önemi:** Bulut ortamında trafiği kontrol eden ilk katman Security Group'lardır; yanlış yapılandırma erişimi kapatır veya gereksiz yere açar.
- **SSH Anahtar Güvenliği:** `.pem` dosyasına doğru dosya izinleri verilmezse bağlantı sağlanamaz; anahtarların güvenli saklanması kritik.
- **Maliyet Yönetimi:** Oluşturulan EC2, Elastic IP vb. kaynaklar kullanılmadığında kapatılmalı veya silinmelidir; aksi takdirde maliyet devam eder.
- **Statik IP Gerekliliği:** Sunucu IP'sinin değişmesi kullanıcı deneyimini etkiler; uzun süreli erişim için Elastic IP kullanımı önerilir.

## Kısa Notlar / İpuçları

- `deploy.sh` çalıştırılmadan önce Security Group üzerinde HTTP (80) portunun açık olduğundan emin olun.
- Bu repo içindeki önemli dosyalar: `index.html`, `deploy.sh`, `README.md`.

---

Eğer isterseniz, bu README içeriği için uygun bir mimari görsel (PNG/SVG) oluşturarak `architecture.svg` yerine güncelleme yapabilirim veya `deploy.sh` içeriğini README'e yerleştirebilirim.
