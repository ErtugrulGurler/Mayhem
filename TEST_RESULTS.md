# Doğrulama sonuçları

Ana oyun testleri, kökteki `project.godot` ile Godot 4.7.2 üzerinde çalışır.
[P0 mekanikleri ve testleri](docs/TEST_RESULTS.md) ve
[menü ve kayıt testleri](docs/menu/REPORT.md) ilgili kabul senaryolarını içerir.

## Ana proje temizliği ve oyuncu çizimi

Godot `4.7.2.stable.official.ed1daf0bf` ile editör importu, 180 kare açılış
ve 12 regresyon paketi geçti. Toplam 919 kontrol ve 14 başarılı motor süreci var.
Compatibility renderer ile gerçek oturum sahnesinin 960×540 görüntüleri temizliğin
öncesiyle karşılaştırıldı. Nişan, ağır yük ve koruma, yakın saldırı, oyuncuyla
örtüşen inşa alanı ve yaralı oyuncu görüntülerinin her birinde piksel farkı sıfırdı.
Bu karşılaştırma mevcut dört profili temsil eden geometrik oyuncu çiziminin
katmanlara ayrılmasını sınar. Fiziksel Android cihazında test yapılmadı.

## Bağımsız Faz 0 arşivi

Eski Godot 4.3 projesinin asker atlasları, ön yön rig denemesi ve bunlara özgü
testler son Faz 0 sürümünde saklanır. O sürümde 463 kontrol geçmişti.
Kaldırılan dizinde 303 asset ve metadata dosyası, 12 doğrulama çıktısı,
9 betik, 6 test, 3 sahne, `project.godot` ve `.gdignore` vardı. Ana proje
kaynak yollarında ve UID başvurularında bu projeye bağımlılık bulunmadı.
[Dönemin tam raporu ve görsel kanıtları](https://github.com/ErtugrulGurler/Mayhem/blob/d0bffcbb12b5cb646f3f5b6722b6d160e7085d24/TEST_RESULTS.md)

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
