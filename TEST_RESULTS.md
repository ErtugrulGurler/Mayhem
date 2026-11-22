# Doğrulama sonuçları

## Asker ön yön rig'i — Godot 4.3

`mayhem_original_soldier_rig.zip` içindeki sekiz PNG parçası, orijinal ön görünüş
ve manifest mevcut Faz 0 projesine eklendi. Kaynak dosyalar yüklemeyle bayt bayt
aynıdır. Orijinal RGBA SHA-256 özeti manifestle eşleşir; cutout birleşimiyle
orijinal arasında **0 farklı RGBA piksel** vardır.

- `tests/soldier_rig_test.gd`: **39 kontrol, 0 hata**. Kaynak görsel bütünlüğü,
  sekiz parça, 91 birim yükseklik/pivot, dönüşümlü kısa adımlar, kol/baş salınımı,
  durunca tam pivot sıfırlama ve y-sort grubundan taşmayan çizim sırası kontrol edildi.
- Mevcut `tests/prototype_test.gd`: **57 kontrol, 0 hata**. Hareket, kamera,
  çarpışma ve mobil kontrol regresyonu geçti.
- Her iki test de gerçek **4.3.stable.official.77dcf97d8** motorunda headless
  ve grafik ekranlı Compatibility çalışma ile doğrulandı.
- 960×540, 1200×540 ve 960×720 ekran görüntüleri ve yürüyüş atlası incelendi.
  Önceki render ile karşılaştırmada diğer yedi yönün bütün pikselleri, ayrıca üç
  çözünürlükte karakter dışındaki harita/HUD pikselleri aynı kaldı.

Pakette ve repoda sekiz yönlü asker atlası bulunmuyor. Yalnız ön yön (index 2)
asker rig'ini kullanır; diğer yedi yön önceki placeholder görselleri korur.
Kol/bacak parçalarının altında eksik gizli çizimler üretilmedi; küçük açılar kullanılır.
Fiziksel Android, cihaz FPS/DPI/çentik ve APK dışa aktarma bu değişiklikte test edilmedi.

## Yeni Faz 0 — Godot 4.3

Bağımsız proje: `prototypes/phase0/project.godot`. Test motoru:
**4.3.stable.official.77dcf97d8**, Linux x86_64, Compatibility renderer.

| Kontrol | Sonuç |
| --- | --- |
| Gerçek 4.3 editor import / GDScript yükleme | Geçti, script/motor hatası yok |
| Ana sahne, 180 kare headless açılış | Geçti |
| `tests/prototype_test.gd`, headless | 57 kontrol, 0 hata |
| Aynı test, grafik ekranlı Compatibility çalışma | 57 kontrol, 0 hata |
| 960×540, 1200×540, 960×720 gerçek render | PNG'ler üretildi ve görsel olarak incelendi |
| Sekiz yön ve dört yürüyüş fazı | Render atlası incelendi; sekiz yönün piksel çıktıları farklı |
| Mevcut ana oyunun 4.7.2 regresyonu | Import/açılış dahil 14 süreç başarılı, 919 kontrol, 0 hata |

Faz 0 testleri gerçek Godot fiziğiyle hareket, çapraz hızın eşitliği, durma,
ağaç/kaya/sınır çarpışması, yumuşak kamera takibi, sekiz yön, gerçek viewport giriş
hattına gönderilen sentetik eşzamanlı dokunma/klavye/fare, analog dışı bırakma,
iptal edilen dokunma ve odak kaybını kontrol eder. HUD sınır/çakışma kontrolleri
960×540, 1200×540, 960×720, 1280×800, 1920×1080 ve 2400×1080 boyutlarında geçti.

Render Linux Mesa llvmpipe yazılım sürücüsünde yapıldı; VSync'in desteklenmediği
uyarısı bu ortama aittir. Fiziksel Android, gerçek iki parmaklı donanım girişi,
çentik/safe-area, DPI, telefon FPS/ısınma/batarya ve APK dışa aktarma **test edilmedi**.
İlk import denemesinde korumalı ev dizinine yazılamadı; XDG veri/ayar/önbellek
yolları çalışma alanına alınarak import temiz biçimde tekrarlandı.

## Önceki kule savunması prototipi

Tarih: 15 Kasım 2026. Hedef motor: **4.7.2.stable.official.ed1daf0bf**, headless Linux.

Resmi Godot GitHub sürümünden `Godot_v4.7.2-stable_linux.x86_64.zip` indirildi ve binary sürümü doğrulandı. Aşağıdaki bütün kontroller bu binary ile tekrar çalıştırıldı. İlk prototipte aynı kontroller 4.6.3 ile de geçmişti.

Kaynak: https://github.com/godotengine/godot/releases/tag/4.7.2-stable

Ham test çıktıları: `tests/results/4.7.2/`.

| Kontrol | Sonuç |
| --- | --- |
| Editor import / GDScript yükleme | Geçti; script hatası yok. Android build-tools eksikliği bildirildi |
| Ana sahne, 180 kare headless açılış | Geçti; motor/script hatası yok |
| smoke_test.gd | 17 kontrol geçti, 0 hata |
| combat_test.gd | 5 kontrol geçti, 0 hata |
| git diff --check | Geçti |

Smoke testi: başlangıç altını/canı, dokuz nokta, inşa maliyetleri, yetersiz bakiye,
dolu noktayı koruma, seviye 3 sınırı, üç düşman türü, tek seferlik ölüm ödülü,
alan hasarı mesafesi, yol hareketi, kaçış, üst üste dalga engeli, dalga sayısı/tamamlanması,
artan sonraki dalga, oyun sonunda duraklama ve temiz yeniden başlatma.

Combat testi: gerçek UI düğme sinyalleriyle doğru kule tipini kurma, gerçek zamanlı hedefleme/atış,
mermilerle öldürme ve altın, tam ilk dalganın tamamlanması ve oyuncunun hayatta kalması.
Test süresi için simülasyon hızı artırılır; saldırı/metotları elle tetiklenmez.

## Sınırlar
- Godot **4.7.2 headless uyumluluk kontrolleri geçti**; bu sonuç Android veya GPU doğrulaması değildir.
- Editor import sırasında `Unable to open Android 'build-tools' directory.` bildirimi görüldü; Android dışa aktarma araçları henüz hazır değil.
- Headless test görsel kaliteyi, dokunmatik donanımı veya GPU render sonucunu doğrulamaz.
- Android SDK/export template kurulumu, APK üretimi, fiziksel cihaz, ekran çentiği,
  farklı DPI değerleri ve telefon performansı doğrulanmadı.
- Uzun süreli dalga dengesi henüz oyun testi gerektirir.
- İlk editor denemesinde korumalı ev dizinine yazma hataları oluştu.
  XDG veri/ayar/önbellek yolları çalışma alanına yönlendirilerek tekrarlandı; son kontrol temiz.
