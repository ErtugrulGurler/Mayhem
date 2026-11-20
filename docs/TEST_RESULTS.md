> 20 Kasım mobil UX revizyonu ve güncel 349 kontrol: [UX raporu](ux/REPORT.md). Aşağıdaki bölüm 19 Kasım P0 temel tesliminin kapsam kaydıdır.

# Mayhem P0 — gerçek test sonuçları

Tarih: **19 Kasım 2026**, Linux headless.
Motor: **4.7.2.stable.official.ed1daf0bf**.
Resmi Godot 4.7.2 Linux binary kullanıldı; 4.6.3 sonucu bu teslimin kanıtı değildir.

Çalıştırıcı: tools/verify.py. Her test ayrı motor sürecinde, izole XDG veri/ayar/cache
dizinlerinde çalıştı; kişisel oyun kaydı kullanılmadı.
Tam komutlar, sürüm ve çıkış kodları: [evidence/commands.json](evidence/commands.json).

| İşlem | Komut (godot = yukarıdaki 4.7.2 binary) | Exit | Sonuç |
|---|---|---|---|
| Import | godot --headless --path . --editor --import --quit | 0 | PASS |
| Açılış | godot --headless --path . --quit-after 180 | 0 | PASS |
| İlk iki taslak | godot --headless --path . --script tests/session_rules_smoke.gd | 0 | 18 kontrol, 0 hata |
| Sistemler | godot --headless --path . --script tests/p0/systems_test.gd | 0 | 103 kontrol, 0 hata |
| Entegre zincir | godot --headless --path . --script tests/p0/loop_test.gd | 0 | 18 kontrol, 0 hata |
| Yeni sahne/UI | godot --headless --path . --script tests/p0/scene_test.gd | 0 | 12 kontrol, 0 hata |
| Eski demo smoke | godot --headless --path . --script tests/smoke_test.gd | 0 | 17 kontrol, 0 hata |
| Eski demo savaş | godot --headless --path . --script tests/combat_test.gd | 0 | 5 kontrol, 0 hata |

Yeni prototip/taslaklar **151**, eski demo **22**, toplam **173** kontrol.
Bu sayı gereksinim PASS sayısı değildir. 104 satırın durumu REQUIREMENTS_TRACEABILITY.md'dedir.

Import çıktısındaki **Unable to open Android 'build-tools' directory.** bildirimi
Android SDK/export ortamı eksikliğidir. GDScript veya runtime hatası görülmedi.
APK üretilmedi; bu bildirim gizlenmedi.

## Kanıtın kapsamı
- İlk session_rules taslağı değiştirilmeden Godot'ta 18 kontrolle çalıştırıldı.
- Sistem testleri: envanter/mesafe, şantiye, inşa hasarı/tamir/söküm, depo yıkımı,
  tamponlar, hasarlı/paralel üretim, iki enerji ağı, overload/kesinti, fiziksel lojistik,
  silah slotları/reload/melee, klinik/medkit, düşman duvar/sabotaj davranışı,
  bütün çağ sınırları, dört merkez/varyasyon kaynak erişimi, save/RNG ve istatistik.
- Loop testi yapı malzemelerini ve üretim girdilerini kaynak noktalarından toplar.
  Oyuncu konumları test düzeneğiyle ayarlanır; ürün/maliyet doğrudan verilmez.
  İzabe → mühimmat → kule zincirinden sonra gerçek ilk dalga normal simülasyonla ilerler.
  Scriptli oyuncu hareket/melee/skill komutlarıyla aktif savunur; kule de ateşler.
  Gözlem: bölüm 2, yenilgi yok, üç tesis korunmuş, takım/kule hasarı 41.
- Beşinci bölüm elite ve onuncu bölüm boss spawn'ı gerçek wave sistemiyle doğrulanır.
  Checkpoint geçişinde beşinci saldırının temizlenmesi fixture ile izole edilir:
  beş doğal dalganın tamamının kazanıldığı iddia edilmez. UNRANKED kaydı korunur.
- Scene testi gerçek yeni sahneyi yükler; menü, kamera, zoom, komutlar ve save/retry
  düğme yollarını çalıştırır. Analoglar sentetik InputEventScreenTouch nesneleriyle sınanır;
  fiziksel Android iki parmak veya gerçek fare tıklama testi değildir.
- Roster/rejoin/klinik testleri offline model; gerçek ağ testi değildir.
- Eski scenes/scripts dosyalarının main ile içerik farkı yok; legacy testler geçti.

## İlk çalıştırmalarda bulunan ve düzeltilenler
Godot tip çıkarımı hataları giderildi. Script kaynağının reload metoduyla çakışan
oyuncu reload adı reload_weapon olarak değiştirildi. Bozuk kaydı decode etmeden önce
magic/hash kontrolü eklendi. Son nadir birimin yanlışlıkla sınırsız kaynağa dönüşmesi önlendi.
Araç son çalıştırmada sıfır script/runtime hatasıyla tamamlandı; başarısız ara loglar PASS sayılmadı.

## Test edilmedi
GPU/görsel kabul, Android fiziksel dokunma, FPS, DPI/çentik, APK kurulum/export,
gerçek 1–4 istemci, dedicated server lifecycle, uzun dönem denge.
Manuel adımlar PROTOTYPE_LIMITATIONS.md ve README.md içindedir.
