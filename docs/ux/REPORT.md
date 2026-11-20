# Mobil arayüz ve oynanabilirlik revizyonu

20 Kasım 2026 · başlangıç: main / 22c1650 · dal: feature/mobile-ux-tutorial.
Hedef ve kullanılan motor: **Godot 4.7.2.stable.official.ed1daf0bf**, Compatibility.

## Sonuç

Sürekli görünen işlem sıraları kaldırıldı. Normal görünümde beş temel alt düğme,
üst Menü ve rehberin Atla düğmesi var; kuşanılmış menzilli silah için hızlı Doldur eklenir.
İnşa, çanta, tesis, seçenekler ve geliştirici panellerinden aynı anda yalnız biri açık olur.
Listeler kaydırılır; dokunma hedefleri en az 48×48 mantıksal pikseldir.

Tesis yanına gelince kaynak toplama, şantiyeye teslim veya tesis paneli açma önerilir.
Panelde yalnız o nesneyle ilgili işlemler sunulur; söküm ayrıca onay ister.
Menüler stokları uzaktan harcamaz; önceki mesafe ve kapasite kısıtları sürer.
Kısa geri bildirimler yükleme, yanlış yerleşim, dolu çanta ve eksik malzemeyi açıklar.

On adımlı rehber: odun → taş → izabe yeri → inşa teslimi → metal üret/al →
mühimmat tezgâhı → mühimmat üret/al → kule → kuleyi doldur → ilk saldırıyı karşıla.
Girdiye ihtiyaç varsa rehber ilgili kaynağa yönlendirir; hazır ürün çantaya alınmadan
ilgili üretim adımı tamamlanmaz. Rehber mevcut fiziksel veriyi gözler, malzeme vermez.
Atla/yeniden göster ve save/resume/checkpoint verisi desteklenir. Eski kayıtlar uyarlanır.

Kaynaklar ağaç/kaya/cevher/kristal/kütük; tesisler fırın/tezgâh/kasa/kule/klinik/enerji
ikonları kullanır. Oyuncu miğfer/pelerin, düşman sivri silüet kullanır.
Yakın nesne sarı, görev hedefi açık turkuaz işaretlenir. Ekran dışındaki göreve ok yöneltir.
Malzeme, girdi, çıktı, mühimmat ve enerji bekleme durumları ayrı etiketlenir;
hasarlı tesiste kırmızı halka, HP ve duman görülür. Grafikler özgün vektör placeholder'lardır.

## Çalıştırılan kontroller

tools/verify.py son çalıştırması, tüm süreçler exit 0:

| Kontrol | Sonuç |
|---|---|
| Godot 4.7.2 editor import | PASS |
| 180 kare headless açılış | PASS |
| session_rules_smoke | 18/18 |
| P0 systems | 103/103 |
| P0 loop | 18/18 |
| P0 scene | 12/12 |
| UX tutorial | 24/24 |
| UX layout | 141/141 |
| UX pointer | 11/11 |
| Legacy smoke + combat | 22/22 |
| Toplam | **349/349** |

Ham çıktılar ../evidence altında; komut, sürüm ve exit kodları commands.json içindedir.
Önceki 173 kontrol korunur; 176 UX kontrolü eklendi. Eski scene testinin sabit touch
koordinatları responsive analog merkezlerinden türetildi; kabul kontrolleri kaldırılmadı.

Tutorial testi bütün inşa malzemelerini gerçekten toplar, mobil komutları kullanır,
girdiyi yükler ve ürünleri alır. Kule + scriptli aktif oyuncu gerçek ilk saldırıyı bitirir.
Konumlandırma/oyuncu komutları test düzeneğidir; dokümansız bir insanla kullanılabilirlik
araştırması yapıldığı iddia edilmez. Enerji/lojistik/dalga/checkpoint regresyonları da geçti.

Layout testi gerçek Godot Control/Container düzenini **960×540 (16:9),
1200×540 (20:9), 960×720 (4:3)** SubViewport'larında çalıştırır.
Başlangıç, normal, menzilli ekipman, inşa, çanta, seçenekler, geliştirici, tesis,
söküm onayı ve yenilgi durumları kontrol edilir. ScrollContainer dışında kalan liste
öğeleri görünür hit bölgelerine dahil edilmez. Düğme çakışması ve sınır aşımı bulunmadı.
Normal HUD'de merkez etkileşim alanı boş; konservatif HUD ayak izi toplamı,
geçici geri bildirim dahil ekranın %45'inden azdır.

Pointer testi Viewport.push_input ile Godot GUI hattına sentetik fare ve ScreenTouch
olayları gönderir; doğrudan pressed sinyali değildir. Başlat, inşa listesi, onay,
menü/panel kapama ve dokunma ayrımı çalışır. Üçüncü touch yeteneği tetiklerken
iki analog sahipliğini korur. Bu sonuç fiziksel Android donanım testi değildir.

## Ekran görüntüleri ve görsel inceleme

Xorg dummy display + Mesa llvmpipe OpenGL 4.5 / Compatibility üzerinde gerçek motor çizimi.
Headless görüntü taklidi veya oluşturulmuş tasarım resmi değil.
Komut (çalışan sanal X display gerektirir):

    DISPLAY=:99 LIBGL_ALWAYS_SOFTWARE=1 godot --path . --audio-driver Dummy --resolution 960x540 --script tests/ux/capture.gd

Açılış, rehber, inşa, yerleştirme ve çanta görüntüleri otomatik alındı.
Window.size değiştirilip gerçek viewport boyutu render logunda doğrulandı.
Görüntüler incelendi; metin kesilmesi, önerilen yapının listede geri kalması ve
isim/durum etiketlerinin okunabilirliği düzeltilerek tekrar alındı.

- [İlk görev / 16:9](02-first-task.png)
- [İlk görev / 20:9](02-task-1200x540.png)
- [İlk görev / 4:3](02-task-960x720.png)
- [Önerilen tarifin önde olduğu inşa paneli](03-build-panel.png)
- [Yeşil yerleşim önizlemesi ve ayrı onay](04-placement.png)
- [Çanta paneli](05-inventory.png)
- [Nesne silüetleri, hasar ve bekleme durumu](06-readable-objects.png)

Son nesne galerisi görsel fixture'dır; bu stok/yapıların oynanarak üretildiğine kanıt değildir.
Gerçek üretim akışı tutorial/loop testinde ayrıca doğrulanır.
Render sürücüsü V-Sync değiştirmeyi desteklemediğini bildirir. Bu, FPS veya telefon
performans testi değildir. Import ayrıca eksik Android build-tools bildirir.

## Kabul kriterleri ve açık doğrulamalar

| Kriter | Kanıt / sınır |
|---|---|
| Ekranın çoğu oynanış | Üç oran geometri testi + gerçek render görüntüleri geçti |
| Oyuncunun görevlerden yön bulması | Görev metni/progresi/hedefi mevcut; 24 otomatik kontrol. İnsan kullanılabilirlik testi yapılmadı |
| Temel işlevlere mobil UI erişimi | Genel/bağlamsal panellerde tüm eski işlemler var; sentetik GUI touch testi geçti |
| Gerekli nesne/işlem belirgin | Görev halkası/ok, seçili halka, önerilen tarif, bağlamsal düğme; görüntüler incelendi |
| Tutorial bitmesi ve loop korunması | Gerçek fiziksel zincir + ilk dalga tamamlandı; eski regresyonlar geçti |
| Test raporu ve eksikler | Bu rapor, ham loglar ve aşağıdaki NOT RUN listesi |

**NOT RUN:** fiziksel Android, gerçek iki/üç parmak donanımı, farklı DPI/çentik/güvenli
alan, telefon FPS/ısınma, APK export/kurulum, insanla ilk kullanıcı testi.
Sanal Linux kontrolü bunların yerine geçmez. Önceki P0 ürün eksikleri (gerçek networking,
boss yardımcı fazı, çağ içerikleri vb.) bu UI çalışmasında geliştirilmedi.

Android manuel kabul: F5 → yeni oturum → rehberi belgesiz tamamla; aynı anda hareket/aim/skill;
kaydırılabilir tesis ve çanta panelleri; geçersiz inşa; çanta doluluğu; save/reload; rehber atla/aç.
16:9 ve geniş telefon oranında metinleri, düğmeleri ve çentiği kontrol et.
Dalga/hazırlık ve küçük baskın zamanlaması aynıdır; rehber sırasında dünya durmaz.
