# Mayhem — Çayır Muhafızları

Android için tasarlanan, tek haritalı ve oynanabilir bir kule savunması prototipi.
GDScript ve Godot Compatibility renderer kullanır. Grafikler tamamen proje içindeki çizim kodundan üretilir; ücretli servis, indirilen asset veya eklenti yoktur.

## Çalıştırma
1. Repoyu klonla ve Godot ile kökteki `project.godot` dosyasını aç.
2. **F6 yerine F5** ile ana sahneyi başlat.
3. Bir **+** noktasına dokun/tıkla, alttan kule seç.
4. **Dalgayı başlat** düğmesine bas. Dalgalar arasında altınını harcayıp hazırlanabilirsin.
5. Kurulu kuleye dokunarak seviye 3'e kadar yükselt. Can sıfır olursa **Yeniden başlat**.

Hedef ve doğrulanan editör **Godot 4.7.2 stable** (`ed1daf0bf`). Resmi Linux paketiyle headless import, açılış ve 22 otomatik kontrol geçti. İlk prototip ayrıca 4.6.3 ile test edilmişti; geliştirme hedefi 4.7.2 olarak korunur.
`config/features` hedef Godot 4.7 serisini belirtir; geliştirme hedefi 4.7.2’dir.

## Prototip
- Kıvrımlı yol, dokuz inşa noktası, ağaçlar, taşlar ve çiçeklerle renkli çayır.
- Normal, koşucu ve tank düşmanlar; otomatik hedefleyen okçu, büyücü ve topçu.
- Görünür takip mermileri, alan hasarı, vuruş parlaması ve halkalı/parçacıklı efektler.
- Altın, üç kule seviyesi, artan dalgalar, 20 can ve yeniden başlatma.
- Dokunmatik için 48–54 mantıksal piksel düğmeler ve fare desteği.
- Yatay 960×540 tasarım; farklı ekranlarda oran korunur, gerekirse kenar boşlukları oluşur.

## Android
`export_presets.cfg` arm64 Android hazır ayarını içerir.
Hedef Godot sürümünün Android export template'lerini, JDK ve Android SDK'yı kur;
Godot **Editor Settings → Export → Android** yollarını ayarla.
**Project → Export → Android → Export Project** ile debug APK oluştur.
CLI: `godot --headless --path . --export-debug Android build/mayhem.apk`
(önce `build/` klasörünü oluştur).
Yayın için benzersiz paket adı ve kendi imzalama anahtarın gerekir; gizli anahtarları repoya ekleme.
Bu ortamda APK üretilmedi, Android cihazda dokunma/performans testi yapılmadı.

## Dosya yapısı
- `scenes/main.tscn`: giriş sahnesi.
- `scripts/game.gd`: oturum, ekonomi, sahne bileşimi ve sinyal bağlantıları.
- `scripts/game_data.gd`: kule/düşman dengesi, yol ve inşa noktaları.
- `scripts/enemy.gd`, `tower.gd`, `projectile.gd`: hareket ve savaş.
- `scripts/wave_director.gd`: dalga planlama ve üretim.
- `scripts/game_hud.gd`: dokunma/fare arayüzü; komutları sinyalle iletir.
- `scripts/visuals/`: harita, düşman/kule çizimleri ve geçici efektler.
- `tests/`: bağımlılıksız headless entegrasyon testleri.

Enemy/Tower görsel çocukları sonradan AnimatedSprite2D veya ayrı görsel sahnelerle değiştirilebilir.
Denge değerleri tek veri sınıfında; düşman ölüm/kaçış, kule atışı ve dalga olayları sinyallerle ayrılmıştır.
Mevcut simülasyon tek oyunculudur; gelecek multiplayer için ağ otoritesi/senkronizasyonu ayrıca tasarlanmalıdır.

## Doğrulama
```sh
godot --headless --path . --editor --import --quit
godot --headless --path . --quit-after 180
godot --headless --path . --script tests/smoke_test.gd
godot --headless --path . --script tests/combat_test.gd
```
Ayrıntılar: [TEST_RESULTS.md](TEST_RESULTS.md).
Ürün kapsamı ve gelecek hedefleri: [GAME_REQUIREMENTS.md](GAME_REQUIREMENTS.md).
