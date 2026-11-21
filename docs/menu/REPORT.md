# Ana menü ve ekran akışı v1

21 Kasım 2026 · kaynak main: 76c94c2.
Görev: docs/tasks/MAYHEM_CODEX_MAIN_MENU_V1_PROMPT.md.
Dal: feature/main-menu-visual-identity-v1.

Kullanıcının son mesajı, görev dosyasındaki “merge etme” notunu değiştirerek
test sonrasında doğrudan main'e birleştirmeye yetki verdi.

## Uygulanan akış

F5, ayrı ui/main_menu.tscn sahnesini açar. Ana menüde gameplay örneği yoktur:
düşman, üretim, dalga ve joystick çalışmaz. Menü dekoru kendi zamanını kullanır.

Yeni Oyun → Tek oyuncu / dört karakter → harita, merkez ve varyasyon → özet →
gerekiyorsa eski ara verme kaydını silme onayı → oyun.
Seçimler geri/ileri gezinirken saklanır; Başlat öncesi dünya veya kayıt değiştirilmez.
Dört katalog profili/HP/hız/melee/skill aynen korunur. Başlangıç envanteri ve tesisler boştur.

Devam Et yalnız doğrulanmış user://suspend.bin ile etkinleşir. Checkpoint, devam kaydı değildir.
Dosya başlığı/hash, sürüm, dünya ve iç veri biçimi doğrulanır; bozuk veri anlamlı
mesajla reddedilir. Resume player/buffer/world/RNG/tutorial durumunu aynen korur.
Yeni oyun mevcut kayıt varken İptal ve açık silme onayı olmadan dosyayı kaldırmaz.

Pause: Oyuna Dön, Kaydet ve Ana Menü, Ayarlar, Kontroller, Rehberi Göster.
Gameplay zamanı, üretim, AI, dalga ve cooldown durur; input dünyaya sızmaz.
Yazma başarısızsa dünya korunur ve pause'ta kalınır. Başarılıysa gameplay sahnesi
kaldırılır, ana menüde Devam Et etkinleşir. Yenilgi ekranı checkpoint/yeni oyun/ana
menü sunar. Suspend yenilgide geçersizleşir; checkpoint retry ayrı saldırı alt-seed'i kullanır.

Ayarlar: küçük/normal/büyük UI metin/hedef boyutları, düşük/normal dekor ve kamera
zoom'u gerçekten uygulanır; sürümlü ConfigFile geçici dosya + rename ile saklanır.
Ses ayarı yoktur, çünkü ses altyapısı yoktur.
İstatistikler gerçek suspend veya son gerçek oturumdan gelir. Son gerçek kayıt
last_statistics.json içinde tutulur; kapsamlı session geçmişi/leaderboard değildir.
Kişisel hasar ve takım/kule hasarı ayrı gösterilir.

Ana menüde Quit/Exit/Çıkış, Bölüm Seç veya eski demo bağlantısı yoktur.
Arkadaşlarla Oyna disabled ve Geliştiriliyor olarak etiketlidir.
Eski demo dosyaları/git geçmişi korunmuştur; multiplayer eklenmemiştir.

## Mimari ve görsel kaynak

- ui/app_flow.gd: sahne yaşam döngüsü, güvenli kayıt/başlatma ve geri dönüş adaptörü.
- ui/screens/*.tscn: native Control ekranları, ortak ekran scripti.
- ui/services: ayarlar, kayıt doğrulama ve son gerçek istatistik.
- ui/menu_theme.gd: ortak orman yeşili/krem/altın tema, focus/hover/pressed/disabled halleri.
- ui/art: özgün katmanlı orman, 3/4 hacimli teknolojik çekirdek, dört sade karakter, harita önizlemesi.
- prototype/session.gd: mevcut komutlar korunur; managed flow ve yerel pause adaptörü eklenir.

Taş/ahşap/metal yüzeyler, temas gölgesi, sıcak çekirdek ışığı, duman/yapraklar ve
dokunma ışık tepkisi özgün Godot çizimleridir. PNG arka plan/UI olarak yapıştırılmadı.
Üçüncü şahıs 3D kamera veya yeni oyun ekonomisi uygulanmadı.

**Orijinal PNG dosyası açık:** sohbet görseli görünür olsa da binary dosya ortamda
yoktu ve yeniden dosya eki istendi. İstenen docs/design/MAYHEM_UI_THEME_REFERENCE.png
henüz eklenemedi. [Durum ve sınır](../design/REFERENCE_STATUS.md).
Başka görsel orijinal PNG gibi sunulmadı.

## Godot 4.7.2 test kanıtları

Motor: 4.7.2.stable.official.ed1daf0bf. Linux, izole XDG veri/ayar/cache dizinleri.

    python3 tools/verify.py --godot /path/to/Godot_v4.7.2-stable_linux.x86_64

| Süreç | Exit / kontrol |
|---|---|
| Editor import | 0 |
| Ana sahne startup, 180 kare | 0 |
| Önceki systems/scene/tutorial/layout/pointer/session ve legacy testleri | 349 kontrol, 0 hata |
| Menu navigation | 39 kontrol, 0 hata |
| Menu layout | 516 kontrol, 0 hata |
| Menu pointer | 15 kontrol, 0 hata |
| Toplam | **919 kontrol, 0 hata; 14 motor süreci exit 0** |

Ham komut/sürüm/exit kodu: ../evidence/commands.json.
Menu testleri ../evidence/menu_*.txt.
Navigation: dosya yok/bozuk/nested bozuk veri, checkpoint ayrımı, overwrite onayı/iptal,
dört gerçek profil, pause freeze, başarısız yazmada kalma, byte eşit resume,
ayarların kaydedilmesi/uygulanması, düşük efektte dekorun durması ve gerçek istatistik.
Pointer: gerçek Godot GUI olay hattına sentetik fare/dokunma, Enter/Esc focus,
tam yeni oyun–pause–save–continue zinciri, dropdown kapanması ve Android Back sinyali.
Bunlar fiziksel telefon testi değildir.

Layout: 960×540, 1920×1080, 2340×1080 (19.5:9), 2400×1080 (20:9);
0.9 / 1.0 / 1.1 UI ölçeğinde on ekran. Scroll clipping dahil görünür hit bölgelerinde
sınır/örtüşme ve minimum 48 mantıksal piksel kontrolü. İlk turdaki minimum-size
hesabından kaynaklanan taşma düzeltildi; başarısız ara çıktılar PASS sayılmadı.

Sanal piksel fiziksel dp olarak varsayılmadı.
Menülerde Android için minimum mantıksal yükseklik:
max(54 × UI ölçeği, 48 × DPI / (160 × viewport stretch)).
Örnek: 1080 fiziksel yükseklik / 540 logical = 2 stretch;
420 DPI için en az 63 logical px gerekir. 54 px'in her cihazda 48 dp olduğu iddia edilmez.
Android'de DisplayServer güvenli alanı window konumu ve stretch ile logical alana çevrilir.
DPI/safe-area dönüşümü fiziksel cihazda doğrulanmadı; HUD'nin cihaz ergonomisi ayrıca ölçülmeli.

## Render / görsel inceleme

Xorg dummy + Mesa llvmpipe OpenGL 4.5 / Compatibility / Dummy audio ile gerçek render.
Ana menü, çekirdek dokunması, karakter, harita, özet, pause, ayarlar, 2D gameplay,
Devam etkin menü ve üç büyük çözünürlük toplam 12 görüntü.
Görüntüler incelendi; metinler ve çekirdeğin düğmelerle örtüşmemesi kontrol edildi.
render.txt sürücüyü, piksel boyutunu, exit kodunu ve CORE TOUCH pulse=1.0 kanıtını içerir.

    DISPLAY=:99 LIBGL_ALWAYS_SOFTWARE=1 godot --path . --audio-driver Dummy --resolution 960x540 --script tests/menu/capture.gd

- [Ana menü](01-main-menu.png)
- [Karakter kartları](02-character.png)
- [Harita](03-map.png)
- [Özet](04-summary.png)
- [Pause](05-pause.png)
- [Ayarlar](06-settings.png)
- [Korunan yukarıdan 2D oynanış](07-top-down-gameplay.png)
- [Devam etkin](08-continue-enabled.png)

V-Sync desteği sanal sürücüde yoktur. Import Android build-tools eksikliğini bildirir.
APK, Android donanımı, ısınma/FPS, çentik ve gerçek iki/üç parmak testi yapılmadı.

## Kabul tablosu

TESTED aşağıda belirtilen motor/GUI/render kanıtıdır; fiziksel Android anlamına gelmez.

| ID | Durum | Kanıt / açık nokta |
|---|---|---|
| MM-001 | TESTED | Ayrı entry scene; ana menüde game=null; startup |
| MM-002 | TESTED | Hacimli özgün çekirdek render, bağımsız dekor zamanı, native core touch pulse |
| MM-003 | PARTIAL | Native koyu yeşil/krem/altın tema uygulandı; orijinal PNG binary eksik |
| MM-004 | TESTED | Navigation ve pointer; geri/seçim korunması ve başlatma öncesi kayıt eşitliği |
| MM-005 | TESTED | Dört gerçek profil başlatıldı; native kart dokunması; render |
| MM-006 | TESTED | Tek gerçek harita, iki merkez/varyasyon; boş inventory/structures |
| MM-007 | TESTED | Eksik/bozuk kayıt disabled, nested doğrulama, exact resume, checkpoint ayrımı |
| MM-008 | TESTED | Onay ekranı; İptal sonrası disk byte eşitliği; onaydan sonra yeni boş dünya |
| MM-009 | TESTED | Disabled Arkadaşlarla Oyna; geliştiriliyor açıklaması |
| MM-010 | TESTED | Boş/bozuk güvenli istatistik, gerçek stats, ayrı kişisel/takım alanı |
| MM-011 | TESTED | Persist/reload UI/efekt/zoom; gerçek zoom ve dekor clock testi |
| MM-012 | TESTED | 516 layout kabulünde yasak düğme taraması; ana/pause render |
| MM-013 | TESTED | Pause snapshot byte eşitliği; AI/üretim/cooldown ve input freeze |
| MM-014 | TESTED | Yazma hatasında aynı dünyada kalma; başarılı save/unload/continue exact state |
| MM-015 | TESTED | Suspend silinmesi, checkpoint retry/new seed; ayrı yenilgi ekranı |
| MM-016 | PARTIAL | Native Enter/Esc/fare/touch ve go_back_requested sinyali geçti; fiziksel Android jesti yok |
| MM-017 | PARTIAL | Dört çözünürlük, üç UI ölçeği, hit testler; DPI/çentik fiziksel kabulü yok |
| MM-018 | TESTED | Mevcut 349 regresyon geçti; denge/input/catalog/üretim kuralları korunur |
| MM-019 | TESTED | Gerçek Godot 4.7.2; 14 motor süreci, komut/exit/loglar |
| MM-020 | TESTED | 12 gerçek render; ana/karakter/ayarlar/pause dahil, görsel inceleme yapıldı |

## Beş dakikalık kullanıcı kontrolü

1. Güncel main'i al, Godot 4.7.2 ile project.godot → F5. Oyun haritası/HUD yerine ana menü açılmalı.
2. Kayıt yoksa Devam disabled. Yeni Oyun → karakter → harita; geri gidip seçimlerin kaldığını gör.
3. Başlat → hareket/nişan dene. Menü açınca düşman/üretim/sayaç durmalı; Ayarlar/Back ile gez.
4. UI ölçeği/efekt/zoom uygula. Kaydet ve Ana Menü → Devam; aynı konum/envanter/tutorial sürmeli.
5. Tekrar kaydet ve menüye dön. Yeni Oyun → Başlat → İptal: eski Devam kaydı korunmalı.
   Confirm ile sıfırdan açıldığında boş çanta/tesis olmalı. Android Back modal/alt sayfa/pause zincirini dene.

Henüz NOT TESTED: fiziksel Android input/gesture, DPI/çentik, telefon performansı,
APK export/kurulum, insanla kullanılabilirlik çalışması. Gerçek multiplayer/leaderboard ve
önceki P0 kapsam eksikleri bu menü çalışmasında geliştirilmedi.
