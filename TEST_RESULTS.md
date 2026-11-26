# Doğrulama sonuçları

## Sağ dört kare yükleme hatası — PNG bekleniyor

Godot **4.3.stable.official.77dcf97d8** ile hata tekrarlandı: `character_visual.gd:45`
satırında dosyada önce kullanılan boşluklarla TAB girintileri karışmıştı. Script
yüklenmediğinden oyuncu görünüşü oluşturulamıyordu. Girintiler tutarlı hale getirildi.

Telefon Download yolları ve ham dış dosya yüklemesi kaldırıldı. Tek kaynak
`res://assets/characters/mayhem_sag_4k.png` adlı import edilmiş Texture2D'dir.
Hücre boyutu 2×2 dokudan hesaplanır; sabit 1254/627 boyut varsayımı kaldırıldı.
Her hücrenin alpha sınırından ayak tabanı, mevcut karakter yüksekliğinden sabit
ölçek hesaplanır. Eksik/geçersiz dosyada önceki atlas korunur.

- Gerçek 4.3 editor import ve 180 kare headless açılış: hata yok.
- Mevcut atlas/prototip/eski cutout testleri: **415 kontrol, 0 hata**.
- `right_walk_test.gd`: **27 geometri kontrolü, 0 hata**; test yalnız bellekteki
  renkli bloklarla boyut, dört bölge, 6,25 FPS döngü, ayak hesabı ve fallback'i doğrular.
- Kamera, hareket, HUD, joystick ve diğer yedi yönün kaynakları değiştirilmedi.

**Eksik girdi:** Sohbetteki görselin ham PNG dosyası çalışma alanında veya Git
deposunda bulunmuyor. Dosya uydurulmadı/üretilmedi. Bu nedenle gerçek 4 karelik
görselin boyutu, alpha'sı, sırası ve görüntü kayması henüz doğrulanmış değildir;
üretim PNG'si henüz eklenmedi. Fiziksel Android testi yapılmadı.

## Güncel sekiz yön / sekiz kare asker atlası — Godot 4.3

Hedef `prototypes/phase0/project.godot`; gerçek motor
**4.3.stable.official.77dcf97d8**, Linux, Compatibility/Mesa llvmpipe.

| Kontrol | Sonuç |
| --- | --- |
| Editor import ve 180 kare açılış | Script/motor hatası yok |
| Atlas, yön, kare, tempo, idle, ayak/kenar kontrolleri | 321 kontrol, 0 hata |
| Mevcut hareket/kamera/çarpışma/dokunma regresyonu | 57 kontrol, 0 hata |
| Korunan eski cutout bileşeni | 37 kontrol, 0 hata |
| Grafik ekranlı aynı üç test | 415 kontrol, 0 hata |
| 960×540 / 1200×540 / 960×720 gerçek render | Görüntüler üretildi ve incelendi |

Önbelleksiz ZIP kopyasında editor import, 180 kare açılış ve aynı 415 kontrol de geçti.

82 kaynak PNG ve manifest byte olarak değiştirilmeden
`prototypes/phase0/assets/characters/mayhem_soldier/` altına alındı. Atlas 2048×2304,
hücre 256×288, ayak pivotu (128, 272), tek sabit ölçek 0,36, kare süresi 95 ms.
64 atlas hücresi ve sekiz idle pozu, tekil yükleme PNG'leriyle piksel piksel eşleşir.
PNG'lerde boş veya kenardan kırpılmış kare yoktur. Her idle, ilgili yönün ilk karesidir.

Godot render'ında 64 zaman yuvası ve sekiz idle yönü kontrol edildi. N yönündeki
1/5. kare kaynakta aynıdır; toplam 63 benzersiz yürüyüş resmi vardır. Bu tekrar
deduplikasyonla silinmedi; sekiz kareli ritim ve 8→1 geçişi korunur. Ayak pivotu
bütün karelerde oyuncu origin'inde kalır; kaynak görsellerdeki 1–3 piksel dikey
sekme ekstra kodla bastırılmadı (oyunda en fazla 1,08 dünya birimi).

S/SE/SW ikinci yarı adımları ve NE/NW arka çapraz yönler render temas tablosunda
incelendi. Nötr poza dönüşler ve 8→1 zamanlamasında kare atlama/atlas kayması
bulunmadı. E/W profil ve SE/SW temas pozlarının örtüşme/çizim tutarlılığı test
sanatının sınırıdır; yazılım testi nihai animasyon kalitesi onayı değildir.
Kaynak kareleri aynalama, yeniden çizme veya yeniden sıralama yapılmadı.

Kanıtlar: [oyun](prototypes/phase0/evidence/soldier-8dir-gameplay.png),
[64 kare](prototypes/phase0/evidence/soldier-8dir-64-frames.png),
[normal tempo](prototypes/phase0/evidence/soldier-8dir-walk.gif),
[4× yavaş](prototypes/phase0/evidence/soldier-8dir-walk-slow.gif),
[motor/komut/exit sonuçları](prototypes/phase0/evidence/verification.json).
Oyuncu hareketi, nişan önceliği, HUD, kamera, dünya, çarpışma ve kökteki ana proje
değiştirilmedi. Fiziksel Android, cihaz FPS/ısınma, DPI/çentik ve APK denenmedi.

## Önceki altı kare asker atlası — arşiv sonuçları

Hedef yalnız `prototypes/phase0/project.godot`; motor gerçek
**4.3.stable.official.77dcf97d8**, Linux, Compatibility/Mesa llvmpipe.

| Kontrol | Sonuç |
| --- | --- |
| Editor import ve ana sahne 180 kare açılış | Script/motor hatası yok |
| `soldier_atlas_test.gd` | 200 kontrol, 0 hata |
| `prototype_test.gd` | 57 kontrol, 0 hata |
| Korunan eski cutout bileşeni: `soldier_rig_test.gd` | 37 kontrol, 0 hata |
| Grafik ekranlı aynı üç test | 294 kontrol, 0 hata |
| Gerçek render, 960×540 / 1200×540 / 960×720 | Görüntüler üretildi ve incelendi |
| Sekiz idle ve 48 yürüyüş karesi render'ı | Her yönde altı ayrı kare ve sekiz ayrı duruş doğrulandı |

Yeni test atlas RGBA özetini yüklenen manifestle karşılaştırır; 48 yürüyüş
hücresi ve sekiz idle hücresi, yüklenen tekil PNG'lerle piksel piksel eşleşir.
Gerçek `Sprite2D` bölgeleri, E/SE/S/SW/W/NW/N/NE sırası, 8 FPS döngüsü,
yarım hız, yürürken yön değişimi, durunca faz sıfırlama, idle'da nişanla yönelme,
sabit ayak pivotu, tek renderer ve y-sort katmanı kontrol edildi.

Eski ön rig ve kaynakları korunur, oyuncuya eklenmez. Oyuncu hareketi, input,
HUD, kamera, çarpışma ve dünya dosyaları değiştirilmedi. Altı yan/çapraz yön
geçici prosedürel çizim taslaklarıdır; ön ve arka yönler gönderilen GIF
kareleridir. Bu paket nihai animasyon kalitesini doğrulamaz.

Bu aşamanın kanıtları [f3752c6 sürümündedir](https://github.com/ErtugrulGurler/Mayhem/tree/f3752c6/prototypes/phase0/evidence).
Eski [48 yürüyüş karesi](prototypes/phase0/evidence/soldier-8dir-48-frames.png) korunur.

Önbelleksiz ZIP kopyasında editor import, 180 kare açılış ve 294 kontrol de geçti.
Fiziksel Android, GPU/FPS/ısınma, çentik/DPI ve APK dışa aktarma denenmedi.

## Önceki ön yön rig denemesi — arşiv sonuçları

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

Bu önceki pakette sekiz yönlü atlas yoktu. O aşamada yalnız ön yön (index 2)
asker rig'ini kullanıyor, diğer yedi yön önceki placeholder görselleri koruyordu.
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
