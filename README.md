# Mayhem

## Yeni Faz 0 — Godot 4.3

Yeni hareket prototipi **[prototypes/phase0/project.godot](prototypes/phase0/project.godot)**
dosyasından ayrı proje olarak açılır. Godot **4.3 stable** ile içe aktar ve **F5**'e bas.
Kökteki mevcut oyunun başlangıcı, sistemleri ve kayıtları değiştirilmedi.

- Açık çayır haritası, yürünebilir patika, ağaç/kaya çarpışmaları ve harita sınırı.
- Sekiz yönde aynı asker; her yönde altı yürüyüş karesi ve ayrı duruş pozu.
- Yürüyüş yaklaşık 8 FPS'tir ve hareket hızıyla ölçeklenir. Durunca aynı yönde
  idle'a geçilir ve animasyon fazı sıfırlanır; başka karakter/placeholder çizilmez.
- 360° hareket, yumuşak ve haritayla sınırlı kamera; Compatibility renderer, yatay mobil ekran.
- Sol analog hareket; sağ analog yalnız bakış/nişan yönü. İki parmak aynı anda kullanılabilir.
- Masaüstü: **WASD / oklar**, **sağ fareyi tutarak yönelme**. Analoglar sol fareyle de denenebilir.
- Faz 0'da düşman, silah/saldırı, inşa, envanter, kaynak veya multiplayer yoktur.

`scripts/player.gd` hareketi, `character_visual.gd` değiştirilebilir çizimi/animasyonu,
`input_router.gd` girişleri, `hud.gd` ekran yerleşimini yönetir. Ağaç/kayaların
çarpışması yalnız yerdeki ayak izindedir; gövdelerin arkasından yürünebilir.
Çevre kodla çizilir; 3D model yoktur. Kullanıcının yüklediği asker PNG'leri
`assets/mayhem_soldier/` altında değiştirilmeden saklanır. Tek `Sprite2D`,
yürüyüşte 8×6 atlası, dururken 8×1 idle atlasını kullanır. Her hücre 256×320,
ayak pivotu (128, 295), ölçek 91/256'dır; hareket/çarpışma/kamera kodu aynıdır.
Ön ve arka yürüyüşler gönderilen çizilmiş GIF karelerindendir. Diğer altı yön
geçici deformasyon taslaklarıdır; nihai/elle çizilmiş 48 kare diye sunulmaz.
Eski `scout_front_rig.gd` ve `assets/characters/scout_front_rig/` korunur,
aktif oyuncu tarafından çizilmez.
`.gdignore`, bu bağımsız projenin eski ana projeye kaynak olarak karışmasını önler.

Doğrulama komutları (Godot 4.3 executable'ı `godot` olarak varsayılmıştır):

```sh
godot --headless --path prototypes/phase0 --editor --import --quit
godot --headless --fixed-fps 60 --path prototypes/phase0 --script tests/prototype_test.gd
godot --headless --fixed-fps 60 --path prototypes/phase0 --script tests/soldier_atlas_test.gd
godot --headless --fixed-fps 60 --path prototypes/phase0 --script tests/soldier_rig_test.gd
godot --headless --path prototypes/phase0 --quit-after 180
```

Grafik ekranı bulunan masaüstünde `tests/capture.gd` üç ekran oranını ve karakterin
sekiz idle yönünü ve 48 yürüyüş karesini render eder. `MAYHEM_CAPTURE_DIR` verilmezse görüntüler `user://captures`
altına yazılır. Fiziksel Android dokunma/DPI/çentik ve cihaz performansı ayrıca denenmelidir.
Gerçek Godot 4.3 import/açılış, headless ve grafik ekranlı 57 kontrol geçti.
Atlasın 200 kontrolü yönleri, 48 kareyi, döngüyü, hızı, idle geçişini ve ayak
hizasını doğrular. Korunan eski rig için 37 bileşen kontrolü de geçer.
Önceki ana oyun doğrulaması: Godot 4.7.2'de 919 kontrol, 0 hata.
Ayrıntılar: [TEST_RESULTS.md](TEST_RESULTS.md).
[Godot render'ından sekiz yön yürüyüş önizlemesi](prototypes/phase0/evidence/soldier-8dir-walk.gif).

Elle kontrol: iki analogla aynı anda hareket et/yönel; parmağı analog dışına sürükleyip
bırak; ağaç ve kayalara yürü; köşelere gidip harita sınırını dene; uygulamadan çıkıp
dönünce karakterin kendiliğinden yürümediğini kontrol et.
Sekiz yön testi: WASD/oklarla dört ana ve dört çapraz yöne yürü. Her yönde durup
doğru idle'a geçtiğini kontrol et. Sağ analogu/sağ fareyi tutarken bakış yönü
hareket yönünden bağımsızdır; hareket yönünü görmek için nişanı bırak.

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
