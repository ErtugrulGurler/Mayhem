> 21 Kasım ayrı ana menü/pause akışı: [güncel rapor](menu/REPORT.md). Önceki aşağıdaki teslim kayıtları tarihçedir.

> 20 Kasım mobil UX revizyonu ve güncel 349 kontrol: [UX raporu](ux/REPORT.md). Aşağıdaki bölüm 19 Kasım P0 temel tesliminin kapsam kaydıdır.

# Prototip sınırları ve cihaz kabulü

Bu teslim tam P0 veya tam ürün değildir. Yeni oyunun tek yerel oyunculu dikey kesitidir.
104 satırın tek tek durumu REQUIREMENTS_TRACEABILITY.md içindedir. Test assertion sayısı
gereksinim sayısı veya Android PASS sayısı değildir.

## Açık P0 kapsamı
- Uzak tesise kritik saldırıda yönsel alarm uygulanmadı (PRD-010).
- İnşa sürükle/bırak ve hızlı tekrar var; uzun basmaya özel davranış yok.
- Minimap dünyadaki oyuncu/merkez/düşmanı çizer; ana dalganın giriş yönünü önceden göstermez.
- Boss sabit bölüm kimliğine, yüksek can/hasara sahiptir. Yardımcı faz seçimi snapshot'ta tutulur
  fakat farklı saldırı davranışlarına henüz bağlanmamıştır.
- Loot şu an düşük olasılıklı can/hız/cevherdir; çağlara göre silah ve gelişmiş ürün havuzları yok.
- Dört karakter basit profil ve sabit farklı melee/skill kullanır. Her profilin her eylemi
  bağımsız test edilmedi. Diğer üç skill için ayrı davranış testleri eklenmeli.
- Modifikasyon tek ortak ranged hasar seviyesidir; ayrı namlu/şarjör/optik modülleri yok.
- Manuel merkez onarımı var; otomatik tamir sistemi yok.
- Üretim takım toplamına yazılır; kişi başı üretim katkısı/çok oyunculu istatistik atfı yok.
- İnşa/üretim/klinik açık tesis çizimleri ve HUD için GPU veya Android görsel kabulü yapılmadı.
- Tek küçük, elle düzenlenmiş orman haritası, iki merkez ve iki kaynak varyasyonu var.
  60–90 saniyelik ürün haritası, üç biyom ve tüm çağların içerikleri tamamlanmadı.
- Konveyör tek kaynak/alıcı arasında görünür paket taşır. Bağla en erken kurulan uygun üreticiden
  alıcıya bağlar; hat yönü/öncelik seçme UI'si henüz yok. Otomatik hat seçimi beklenmedikse
  önce yalnız ilgili üretici/alıcıyı kur. İnşaatlar halen manuel teslim ister.
- Kablo Bağla en yakın iki elektrik yapısını seçer. Elle uç seçimi yok; aradaki düz hat
  araziden geçemiyorsa bağlantı kurulmaz. Yakıt tüketen izabe başlangıç örneğidir;
  jeneratör bu kesitte yalnız HP'ye bağlı sabit güç verir.
- Kaynakları kaçırmamak için yenilenebilir odun/taş/cevher mevcut. Nadir kaynak avantaj örneğidir;
  tam ileri çağ denge ve uzun oturum performans testi yok.

## P1/P2 — ertelenenler
Gerçek authoritative dedicated server, kimlik doğrulama, 1–4 istemci senkronizasyonu,
sunucunun boşken snapshot alıp kapanması ve tekil resume kilidi, ağda rejoin/karakter rezervasyonu,
takım kurtarma/canlanma, yenilgi oylaması, doğrulanmış rekor kategorisi, online leaderboard
ve cihaz içi session geçmişi uygulanmadı. Roster/klinik testleri sadece offline veri modelidir.

Atomik yerel kayıt + hash var; schema migration, son geçerli snapshot backup/rollback,
sunucu süreci kilidi ve bozuk disk/elektrik kesintisi testi yok.
Kayıt dosyaları kullanıcıya ait yerel verilerdir; güvenilir çok oyunculu sunucu kaydı değildir.

Boru, taşıyıcı araç, robot, splitter önceliği ve kapsamlı çağ içerikleri P1/P2'dir.
Düşman/kaynak miktarını oyuncu sayısına göre azaltan sistem eklenmedi.

## Kullanıcının Android manuel kontrol listesi — hepsi NOT RUN

README'deki ilk 10 dakika akışını iki yatay ekran oranında tekrarla: örneğin 16:9 ve 20:9.

| Adım | Beklenen | Bu ortamın sonucu |
|---|---|---|
| Godot Android 4.7.2 import + F5 | Karakter/konum menüsü; hata yok | NOT RUN |
| İki parmak, 60 sn hareket + nişan | Bağımsız iki analog; bırakılan taraf sıfırlanır | NOT RUN |
| Analoglar + dodge/skill, üç parmak | Ateş/hareket takılmaz; yanlış inşa oluşmaz | NOT RUN |
| İnşa sürükle/bırak ve hızlı yerleştirme | Önizleme yeşil/kırmızı; HUD/analog alanına kurulmaz | NOT RUN |
| Uzun basma | Mevcut sürümde ayrı davranış yok | NOT IMPLEMENTED |
| 16:9 ve 20:9, çentik/DPI | Okunabilir HUD, taşma yok, dokunma hedefleri yeterli | NOT RUN |
| Kaydet → editörü kapat → F5 → sürdür | Aynı konum/stok/RNG, tekrar ürün kazanımı yok | NOT RUN |
| Kaydet → sürdür → öl → tekrar F5 | Önceki suspend ile ölümden kaçış yok; checkpoint kullanılabilir | NOT RUN |
| Üretim zinciri + ilk dalga | Fiziksel stok azalır/artar; oyuncu ve kule birlikte savunabilir | NOT RUN |
| DEBUG 11/61 ile konveyör/kablo | Fiziksel paket ve anlık enerji kesintisi | NOT RUN |
| DEBUG 5/10 | Elite/boss uyarısı ve spawn; tamamlanınca checkpoint | NOT RUN |
| 10 dk oynama ve artan entity yükü | FPS/frametime, cihaz/çözünürlük/sıcaklık kaydedilir | NOT RUN |
| Uygulamayı arka plana al/geri dön | Takılı joystick yok, ara verme kaydı geçerli | NOT RUN |
| APK export/kurulum | 4.7.2 export templates, JDK, Android SDK ile APK | NOT RUN |

Performans hedef cihazı henüz belirtilmediğinden FPS eşiği kabul edilmiş gibi sunulmaz.
Godot editörünün kendi FPS/monitor panelinde ölçülen cihaz modeli, ekran boyutu,
maksimum düşman/yapı/paket sayısı ve p95 kare süresi sonraki rapora eklenmeli.
