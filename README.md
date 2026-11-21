# Mayhem

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
