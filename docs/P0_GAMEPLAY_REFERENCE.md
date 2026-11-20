> 19 Kasım P0 tesliminin tarihsel kullanım notları. Güncel mobil kontroller için kök README ve oyun içi rehber geçerlidir.

# Mayhem — aksiyon, üretim ve üs savunması

**Godot 4.7.2 / GDScript / Compatibility / yatay Android.**
Tek yerel oyunculu P0 dikey kesit. Dört basit karakterden biriyle kaynak topla,
malzemeyi fiziksel olarak taşı, tesis kur, mühimmat üret ve HP hedefi olan merkezi koru.
Gerçek ağlı co-op bu sürümde yoktur.

## Aç / dene

PR merge edildikten sonra mevcut klonda:
```sh
git switch main
git pull --ff-only origin main
```
İlk kez:
```sh
git clone https://github.com/ErtugrulGurler/Mayhem.git
```
Merge öncesi deneme dalı: `feature/mayhem-p0-functional`.
Android Git istemcisinden bu dalı checkout edebilir veya GitHub'da dalı seçip Code → Download ZIP kullanabilirsin.
ZIP'i tamamen aç; yalnız tek script indirme. Godot Android 4.7.2 proje listesinde
klasörün kökündeki **project.godot** dosyasını içe aktar, **F5 / Projeyi Çalıştır** ile aç.
Karakter, merkez konumu ve harita varyasyonunu seçip **Sıfırdan başla**.
İlk kurulumda yalnız merkez vardır; çanta ve iki menzilli slot boştur.

## İlk 10 dakikanın yolu

1. **0–2 dk:** Sol analog hareket, sağ analog sabit yönde sürekli saldırı.
   Başlangıçta yakın dövüştesin. Ayrı **Kaç** ve **Yetenek** düğmelerini dene.
   Yeşil odun, açık gri taş ve kahverengi cevher noktalarında **Topla**; basılı tutmak yerine tekrar dokun.
   Her etkileşim 2 malzeme, 0.7 sn kaynak cooldown; çanta 30 birim.
2. **2–4 dk:** Üst menüden **İzabe** seç; ekrandaki üst-orta boş araziye dokun/sürükle-bırak.
   Önizleme yeşil olmalı. Analogların üzeri yerleştirme alanı değildir.
   Şantiyeye yaklaş ve **Topla** ile **2 odun + 4 taş** teslim et.
   4 sn sonra kendiliğinden tamamlanır. İnşa için kaynak uzaktaki çanta/depolardan çekilmez.
3. **4–6 dk:** İzabeye **2 cevher + 1 odun** götür, **Yükle**; 3 sn sonra **2 metal** çıkar.
   **Ürün** ile al. **Mühimmat** tezgâhı için **4 odun + 2 taş** teslim et.
   **1 metal + 1 odun** yükle → **8 mermi**. Girdi ve çıktı kutuları 24 birimle sınırlı.
4. **6–8 dk:** **Kule** şantiyesine **6 odun + 3 taş** teslim et. Mühimmatı taşı, kule yanında
   **Yükle**. Kule boşken ateş etmez; doluyken menzilde otomatik ateşler.
   **Dalga** düğmesi saldırıdan 5 sn önce uyarır. İlk hazırlık 180 sn; sonraki hazırlık 30 sn.
   Oyuncuyla da savaş: tek kuleye güvenip üretimi savunmasız bırakma.
5. **8–10 dk:** Yakın tesise **Tamir** (1 odun / en çok 30 HP), **Geliştir** (2 metal + 2 odun)
   veya **Sök** uygula. Kaynak kısmen yere iade edilir.
   Beşinci saldırı sonrası checkpoint alınır. **Kaydet** ara verir; menüde **Ara verme kaydını sürdür**
   aynı dünya/RNG ile döner. Yenilgide checkpoint veya yeni oturum seç.

Hızlı mekanik denemesi için **DEBUG** düğmesi sırayla 5/10/11/21/41/61/81/101/121'e gider.
Oturum **UNRANKED** olur; ücretsiz stok veya bina verilmez, sonraki saldırıyı **Dalga** ile başlat.
Yeni oturum debug işaretini temizler; checkpoint retry temizlemez.

## Diğer denemeler

- **Yay tezgâhı:** 3 odun + 2 taş ile kur; 3 odun + 1 taş yükle → yay.
- **Saçmalı tezgâhı:** 4 odun + 4 taş ile kur; 2 metal + 2 odun → saçmalı.
  Ürünü al, **Silah** ile hedef slotu seç, **Kuşan**; tekrar **Silah** ile melee/slot1/slot2 değiştir.
  Mermi taşı ve **Doldur**. Nişan yardımı yoktur; mermiler verilen yönde gider.
- **Parça atölyesi:** 5 odun + 3 taş; 1 metal + 1 odun → parça.
  Parçayı alıp çalışan atölye yanında **Modifiye** ile basit hasar seviyesi artırılır.
- **Klinik:** 6 odun + 4 taş; yanında 1 odunla iyileşme.
  **Medkit tezgâhı:** 4 odun + 3 taş; 2 odun + 1 taş → medkit; **İyileş** ile tüket.
- **Depo:** 5 odun; 60 birim. Yıkılınca stokun yarısı kaybolur, yarısı elle toplanan loot olur.
- **Konveyör (11+):** 3 odun + 2 metal. Bir üretici ve bir uygun alıcı arasına kur.
  İki uç da konveyöre en çok 180 birim uzakta olsun. **Bağla** en erken kurulmuş uygun kaynak/alıcıyı bağlar.
  Gerekirse tek hatla izabe → mühimmat, ayrı hatla mühimmat → kule düzenini dene.
- **Elektrik (61+ / Sanayi):** Jeneratör (4 taş + 4 metal), elektrikli mühimmat
  tezgâhı (4 metal + 3 taş), araya kablo (1 metal) kur.
  Kablo yanında **Bağla**: en yakın iki tamamlanmış elektrik yapısını bağlar (220 birim).
  Jeneratör kapasitesi 4, tüketici yükü 3. İki tüketici overload yapar; **Aç/Kapat** ile biri kapatılınca düzelir.
  Kabloyu kapat/sök: tüketici anında durur. Ayrı ağlar birbirine enerji aktarmaz.
- Ağır kütük elde taşınır ve yavaşlatır; **Bırak** ile yere bırakılır, bu kesitte araç yoktur.
- Kırmızı HP sıfırda sürünme/12 sn kan kaybı; solo tam ölüm yenilgi.
  Dört gerçek oyunculu canlanma henüz ağda çalışmaz; yalnız veri modeli testlidir.

## Masaüstü kontrolleri

WASD hareket; sağ fare basılıyken nişan/otomatik saldırı; E toplama/teslim (basılı tutma da desteklenir).
F yükle, G ürün al, T tamir, X sök, Q silah slotu, R doldur, Space dodge, C skill, H medkit.
Sol fare: seçili inşa önizlemesini dünya alanında yerleştir.
`Zoom + / -` kamerayı sınırlar içinde değiştirir.

## Test / mimari

Linux'ta (Python standart kitaplığı dışında bağımlılık yok):
```sh
python3 tools/verify.py --godot /path/to/Godot_v4.7.2-stable_linux.x86_64
```
Araç sürümü doğrular, izole kayıt dizinlerinde import/runtime ve testleri çalıştırır;
ham çıktılar `docs/evidence/` altındadır. Testleri kişisel Android oyun kaydın üzerinde çalıştırma.

`prototype/core/`: veri, durum, envanter, istatistik, arazi ve offline roster modeli.
`prototype/systems/`: oyuncu/savaş/inşa/üretim/lojistik/enerji/AI/dalga/kayıt.
`prototype/presentation/`: dokunma, HUD, çizimler ve minimap.
`prototype/session.gd`: yalnız sahne bileşimi ve komut yönlendirme.
Simülasyon durumu nesnesiz Dictionary/Vector2 verisidir; snapshot mermileri ve yoldaki ürünleri de içerir.

- [104 gereksinim ve durum](docs/REQUIREMENTS_TRACEABILITY.md)
- [Gerçek test sonuçları](docs/TEST_RESULTS.md)
- [Eksikler ve Android manuel kontrol listesi](docs/PROTOTYPE_LIMITATIONS.md)
- [120 karar](docs/DECISIONS_ALL_120.md)
- [Eski demonun README'si](docs/LEGACY_README.md)

Eski demo `scenes/main.tscn` ve `scripts/` altında değiştirilmeden korunur;
başlangıç menüsünden de açılır. Eski altın/sabit-yol kuralları yeni oyuna uygulanmaz.
APK export için 4.7.2 Android template/JDK/SDK ayrıca gerekir; bu teslim APK içermez.
