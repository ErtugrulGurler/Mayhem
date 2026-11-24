# Mayhem

## Yeni Faz 0 — Godot 4.3

Yeni hareket prototipi **[prototypes/phase0/project.godot](prototypes/phase0/project.godot)**
dosyasından ayrı proje olarak açılır. Godot **4.3 stable** ile içe aktar ve **F5**'e bas.
Kökteki mevcut oyunun başlangıcı, sistemleri ve kayıtları değiştirilmedi.

- Açık çayır haritası, yürünebilir patika, ağaç/kaya çarpışmaları ve harita sınırı.
- SE yönünde orijinal dokulu, 15 kemikli sürekli cutout/IK yürüyüşü; diğer yedi yönün atlası aynıdır.
- Atlas yönlerinde yürüyüş yaklaşık 10,53 FPS'tir (95 ms/kare). Durunca aynı yönde
  idle'a geçilir ve animasyon fazı sıfırlanır; başka karakter/placeholder çizilmez.
- 360° hareket, yumuşak ve haritayla sınırlı kamera; Compatibility renderer, yatay mobil ekran.
- Sol analog hareket; sağ analog yalnız bakış/nişan yönü. İki parmak aynı anda kullanılabilir.
- Masaüstü: **WASD / oklar**, **sağ fareyi tutarak yönelme**. Analoglar sol fareyle de denenebilir.
- Faz 0'da düşman, silah/saldırı, inşa, envanter, kaynak veya multiplayer yoktur.

`scripts/player.gd` hareketi, `character_visual.gd` değiştirilebilir çizimi/animasyonu,
`input_router.gd` girişleri, `hud.gd` ekran yerleşimini yönetir. Ağaç/kayaların
çarpışması yalnız yerdeki ayak izindedir; gövdelerin arkasından yürünebilir.
Çevre kodla çizilir; 3D model yoktur. Kullanıcının yüklediği asker PNG'leri
`assets/characters/mayhem_soldier/` altında değiştirilmeden saklanır. SE dışındaki yönlerde tek `Sprite2D`,
yürüyüşte 8×8 atlası, dururken 8×1 idle atlasını kullanır. Her hücre 256×288,
ayak pivotu (128, 272), sabit ölçek 0,36'dır; hareket/çarpışma/kamera kodu aynıdır.
Kareler kaynak sırasıyla oynar; runtime'da aynalanmaz veya yeniden sıralanmaz.
N yönünün 1. ve 5. kareleri kaynakta aynıdır; sekiz zaman yuvası aynen korunur.
Bu bir test çizim paketidir; profil/çapraz pozların nihai sanat değerlendirmesi gerekir.
Eski `scout_front_rig.gd`, ön cutout kaynakları ve `assets/mayhem_soldier/`
altındaki altı karelik paket korunur, aktif oyuncu tarafından çizilmez.
`.gdignore`, bu bağımsız projenin eski ana projeye kaynak olarak karışmasını önler.

Doğrulama komutları (Godot 4.3 executable'ı `godot` olarak varsayılmıştır):

```sh
godot --headless --path prototypes/phase0 --editor --import --quit
godot --headless --fixed-fps 60 --path prototypes/phase0 --script tests/prototype_test.gd
godot --headless --fixed-fps 60 --path prototypes/phase0 --script tests/soldier_atlas_test.gd
godot --headless --fixed-fps 60 --path prototypes/phase0 --script tests/soldier_rig_test.gd
godot --headless --fixed-fps 60 --path prototypes/phase0 --script tests/se_rig_test.gd
godot --headless --path prototypes/phase0 --quit-after 180
```

Grafik ekranı bulunan masaüstünde `tests/capture.gd` üç ekran oranını ve karakterin
sekiz idle yönünü ve 64 yürüyüş karesini render eder. `MAYHEM_CAPTURE_DIR` verilmezse görüntüler `user://captures`
altına yazılır. Fiziksel Android dokunma/DPI/çentik ve cihaz performansı ayrıca denenmelidir.
Gerçek Godot 4.3 import/açılış, headless ve grafik ekranlı 57 kontrol geçti.
Atlasın 321 kontrolü yönleri, 64 kareyi, şeffaf kenarları, döngüyü, hızı, idle geçişini ve ayak
hizasını doğrular. Korunan eski rig için 37 bileşen kontrolü de geçer.
Önceki ana oyun doğrulaması: Godot 4.7.2'de 919 kontrol, 0 hata.
Ayrıntılar: [TEST_RESULTS.md](TEST_RESULTS.md).
[Godot render'ından sekiz yön yürüyüş önizlemesi](prototypes/phase0/evidence/soldier-8dir-walk.gif).
[Dört kat yavaş inceleme](prototypes/phase0/evidence/soldier-8dir-walk-slow.gif).

Elle kontrol: iki analogla aynı anda hareket et/yönel; parmağı analog dışına sürükleyip
bırak; ağaç ve kayalara yürü; köşelere gidip harita sınırını dene; uygulamadan çıkıp
dönünce karakterin kendiliğinden yürümediğini kontrol et.
Sekiz yön testi: WASD/oklarla dört ana ve dört çapraz yöne yürü. Her yönde durup
doğru idle'a geçtiğini kontrol et. Sağ analogu/sağ fareyi tutarken bakış yönü
hareket yönünden bağımsızdır; hareket yönünü görmek için nişanı bırak.

### SE cutout yürüyüşü

Yalnız SE, `scripts/se_walk_rig.gd` içindeki Skeleton2D/Bone2D ve analitik iki
kemik IK kullanır. Baş/yüz/gözlük/saç/atkı ve görünen kıyafet UV'leri orijinal
SE dokusundandır. Gizli eklem ve çanta alt boyamaları ayrı dokudur. Sürekli,
ortak köşeli skin ağı eklem kıvrımlarında ters dönen üçgenleri engeller; botlar
ve eldivenler ayrı rijit parçadır. Ayaklar gerçek hareket mesafesine göre yere kilitlenir.
Durunca iki kısa yerleşme adımından sonra birebir orijinal idle görünüşü döner.

[40 birim/sn yürüyüş](prototypes/phase0/evidence/se/se-walk.gif) ·
[eklemler/temaslar](prototypes/phase0/evidence/se/se-joints.gif) ·
[gerçek 220 birim/sn oyun videosu](prototypes/phase0/evidence/se/se-native-220.mp4) ·
[24 örnek kare](prototypes/phase0/evidence/se/se-contact-sheet.png).

**Kalite sınırı:** Hareket hızı değiştirilmedi. Kısa adımlarda temas kaydırmadan
220 birim/sn'ye yetişmek 0,118 sn'lik çok hızlı döngü gerektiriyor. 40 birim/sn
önizlemesi doğal tempo içindir; tam hız videosu bu sorunu gizlemez. Tam hızdaki
doğallık, profesyonel kalite açısından açık konudur; diğer yedi yöne genişletilmedi.
Mobilde sol analogu hafifçe sağ alta iterek düşük tempoyu, tam iterek yüksek
tempoyu kıyaslayabilirsin. Masaüstünde D+S tam hızdır. Sağ nişanı bırak veya SE'ye yönelt.

## Mevcut ana proje — Godot 4.7.2

**Godot 4.7.2 · GDScript · Compatibility · Android yatay ekran.**
Fiziksel kaynak toplama, üretim ve üs savunması içeren yukarıdan bakışlı 2D prototip.
Ana menüdeki hacimli çekirdek dekoru, oyun kamerasını 3D'ye dönüştürmez.

## Başlat

Güncel main dalını çek veya GitHub ZIP'ini tamamen aç.
Godot 4.7.2 ile kökteki project.godot dosyasını içe aktar, **F5 / Projeyi Çalıştır**.

- **Yeni Oyun → karakter → harita/merkez/varyasyon → özet → Başlat.**
- Var olan ara verme kaydı varsa üzerine yazmak ayrıca onay ister; İptal kaydı korur.
- **Devam Et** yalnız geçerli ara verme kaydıyla etkinleşir. Checkpoint devam kaydı değildir.
- **Arkadaşlarla Oyna** henüz geliştirilmedi ve devre dışıdır.
- **İstatistikler** yalnız gerçek kayıt verilerini gösterir.
- **Ayarlar** UI ölçeği, dekoratif efekt ve gerçek kamera zoom'unu saklar. Ses ayarı yoktur.
- Çıkış/Quit/Bölüm Seç düğmesi yoktur. Esc / Android Back alt ekranda geri gider;
  ana menüde oyunu kapatmaz.

## Oyna, duraklat, devam et

Sol analog hareket; sağ analog tuttuğun yöne otomatik saldırı. Nişan yardımı yok.
Alt bağlamsal düğme Topla / Teslim et / Tesisi aç olur. İnşa ve Çanta panelleri
tarifleri, stokları ve mevcut işlemleri gösterir. Oyun içindeki rehber ilk üretim hattını öğretir.

**Menü → Oyuna Dön / Kaydet ve Ana Menü / Ayarlar / Kontroller / Rehberi Göster.**
Pause sırasında oyun zamanı, dalga, üretim, AI ve cooldown'lar durur.
Kaydetme başarısız olursa oyun kaybolmaz, pause ekranında kalırsın.
Kaydet ve Ana Menü → Devam Et aynı dünya/envanter/makine/RNG/tutorial durumunu sürdürür.
Yenilgide checkpoint retry, yeni oyun veya ana menü seçilir; suspend ile checkpoint karışmaz.

İnşa/çanta/tesis panelleri mevcut oynanış akışını korur; bunlar pause değildir.
DEBUG yalnız geliştirici alanındadır ve UNRANKED yapar.
Masaüstü: WASD, sağ fare nişan; E etkileşim, F yükle, G al, R reload, Q slot,
Space kaç, C yetenek, H medkit. Ayrıntılı kontroller oyun içindedir.

## Test ve rapor

    python3 tools/verify.py --godot /path/to/Godot_v4.7.2-stable_linux.x86_64

Sonuç: **919 kontrol, 0 hata**; editor import ve startup dahil 14 motor süreci başarılı.
Native fare/klavye/sentetik touch, kayıt, pause, üç UI ölçeği ve dört yatay çözünürlük testli.
Fiziksel Android, DPI/çentik, gerçek cihaz FPS ve APK testi yapılmadı.

- [Ana menü kabul tablosu, beş dakikalık test ve render görüntüleri](docs/menu/REPORT.md)
- [Ham test komutları / exit kodları](docs/evidence/commands.json)
- [Önceki mobil HUD / tutorial raporu](docs/ux/REPORT.md)
- [P0 mekanik referansı](docs/P0_GAMEPLAY_REFERENCE.md)
- [Genel ürün eksikleri](docs/PROTOTYPE_LIMITATIONS.md)

**Orijinal referans PNG açık:** sohbet görseli tema olarak incelendi; araçlara dosya
olarak ulaşmadığından docs/design/MAYHEM_UI_THEME_REFERENCE.png henüz eklenemedi.
[Dosya durumu](docs/design/REFERENCE_STATUS.md). Yeniden çizilmiş bir kopya orijinal diye sunulmadı.

Gerçek online co-op, bütün boss/çağ içerikleri ve leaderboard yoktur. Eski demo git
geçmişinde ve scenes/scripts altında korunur; kullanıcı ana menüsünde bağlantısı yoktur.
APK için Godot 4.7.2 Android template, JDK ve SDK ayrıca gerekir.
