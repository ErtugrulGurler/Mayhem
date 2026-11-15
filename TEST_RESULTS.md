# Doğrulama sonuçları

Tarih: 15 Kasım 2026. Motor: **4.6.3.stable.official.7d41c59c4**, headless Linux.

| Kontrol | Sonuç |
| --- | --- |
| Editor import / GDScript yükleme | Geçti; son çalıştırmada motor/script hatası yok |
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
- Godot **4.7.2 mevcut değil**; bu sürümde uyumluluk testi yapılmadı.
- Headless test görsel kaliteyi, dokunmatik donanımı veya GPU render sonucunu doğrulamaz.
- Android SDK/export template kurulumu, APK üretimi, fiziksel cihaz, ekran çentiği,
  farklı DPI değerleri ve telefon performansı doğrulanmadı.
- Uzun süreli dalga dengesi henüz oyun testi gerektirir.
- İlk editor denemesinde korumalı ev dizinine yazma hataları oluştu.
  XDG veri/ayar/önbellek yolları çalışma alanına yönlendirilerek tekrarlandı; son kontrol temiz.
