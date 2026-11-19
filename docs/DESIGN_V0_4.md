# MAYHEM — Tasarım Kararları v0.4 (Kapanış / Gereksinim Girdisi)

> Tarih: 19.11.2026 · Kaynak JSON: `docs/SOURCE_DECISIONS_2026-11-19.json` · Durum: Tasarım gereksinimleştirme girdisi, balans değerleri prototip varsayımıdır.

## Kararların otoritesi
Son kullanıcı ifadesi > önceki kullanıcı ifadesi > devredilen konulardaki asistan tasarım kararı > eski sabit yol prototipi. 62 önceki ve 42 yeni seçim korunmuştur; asistanın çözüm kararları ayrıca `docs/RESOLVED_DESIGN_DECISIONS.json` içinde izlenir.

## Kullanıcının en son açık kuralları
- **Kadro kilidi:** Dört benzersiz oyuncu kimliği bir session’a girdiğinde slotlar onlara aittir. Ayrılanın yerine başka kişi giremez; aynı kişi geri döner. Boş slotlar ilk dört tamamlanana dek doldurulabilir.
- **Canlanma:** Multiplayer’da en az bir oyuncu sağsa tamamen ölen oyuncu süre sonunda geri döner; çalışan iyileştirme tesisi süreyi kısaltır, kurmamak cezadır. Solo tam ölüm checkpoint yenilgisidir.
- **Görsel prototip:** Öncelik fonksiyon; tüm karakterler ilk prototipte basit çizimler. Tüm mekanikler veriyle genişletilebilir tasarlanır.

## Önceki 62 karar
| ID | Alan | Karar |
|---|---|---|
| D-01.01 | Harita | Orta-büyük: ana yapıdan en uzak erişilebilir noktaya normal yürüyüşle yaklaşık 60–90 saniye. |
| D-01.02 | Harita | 3 ayrı, elle tasarlanmış ana harita. İlk geliştirmede bir tanesi tamamlanacak. |
| D-01.03 | Harita | Orta değişkenlik: ana coğrafya korunur; bazı kaynak noktaları, düşman girişleri, geçitler, köprüler ve engeller değişebilir. |
| D-01.04 | Harita | Yükselti farkları doğal engel, hareket/geçit ve üretim hattı güzergâhı zorluğudur. Silah hasarına veya menziline bonus vermez. |
| D-01.05 | İnşa & Merkez | Duvarlar, kuleler, makineler ve taşıma hatları uygun arazide istenen yere kurulabilir. |
| D-01.06 | İnşa & Merkez | İnşa alanı merkeze bağlı bir yarıçapla sınırlandırılmayacak; uygun her yerde tesis, depo, savunma ve ileri karakol kurulabilir. |
| D-01.07 | Düşman & Savunma | Tam duvar kapatma serbest; düşman türüne göre yol arama, duvar yıkma, engel aşma/tırmanma gibi farklı tepkiler olacak. |
| D-01.08 | Düşman & Savunma | Üretim, depo ve lojistik hatlarını özel sabotajcılar veya baskın grupları hedefler; normal düşmanlar çoğunlukla ana yapıya yönelir. |
| D-01.09 | Üretim & Enerji | Kademeli hasar: verim düşer, üretim durabilir, tesis onarılabilir veya tamamen yıkılabilir. |
| D-01.10 | İnşa & Merkez | Başlangıçta oyuncular manuel onarır; ilerleyen çağlarda tamir makineleri/robotlarla otomasyon açılır. |
| D-01.11 | Kaynak & Lojistik | Bazı temel kaynak kaynakları sınırsız/sürekli erişilebilir; değerli kaynaklar tükenebilir. Yeni çağlarda yeni/niş kaynaklar açılır. |
| D-01.12 | Kaynak & Lojistik | Malzemeler elde veya taşıma araçlarıyla fiziksel olarak taşınacak; doğrudan global malzeme havuzundan kullanılmayacak. |
| D-01.13 | Kaynak & Lojistik | Kaynaklar takımın ortak kullanımında, yerel fiziksel depolarda. Para, soyut geliştirme puanı ve satın alınan karakter buff ekonomisi çıkarıldı. |
| D-01.14 | Üretim & Enerji | Başlangıçta basit üretim; sonraki çağlarda yaklaşık 2–4 aşamalı production line zincirleri. |
| D-01.15 | Kaynak & Lojistik | İlk 10 bölüm manuel kaynak taşıma. Ardından çağlarla birlikte fiziksel otomatik taşıma sistemleri açılır. |
| D-01.16 | Bölüm & Çağ | Düşman gücü oyuncular geri kaldığında azalmaz. Kötü başlangıçtan doğru strateji ve yüksek beceriyle dönüş mümkün olmalı. |
| D-01.17 | Bölüm & Çağ | Ana düşman saldırısı temizlenince bölüm ilerler. Kısa geçiş olabilir; düşük seviyeli tehdit hiçbir zaman tamamen bitmez. |
| D-01.18 | Düşman & Savunma | Her 10 bölümde büyük boss; aradaki 5. bölümlerde güçlü saldırılar. Checkpoint her 5 bölümde. |
| D-01.19 | Karakter & Savaş | HP sıfırlanınca karakter sürünür, kan kaybeder ve sınırlı kurtarma süresi vardır. Takım arkadaşları kurtarabilir. |
| D-01.20 | Karakter & Savaş | Tamamen ölen oyuncu otomatik doğmaz; takımın özel kurtarma/geri getirme işlemi gerekir. Üzerindeki fiziksel kaynaklar ölüm noktasında kalır. |
| D-01.21 | Bölüm & Çağ | Solo oyuncu tamamen ölürse doğrudan son checkpoint durumuna döner. |
| D-01.22 | Bölüm & Çağ | Takım tümden ölürse veya ana yapı yıkılırsa son checkpoint ya da sıfırdan yeni session seçilebilir. Multiplayer kararı oylamayla alınır. |
| D-01.23 | Bölüm & Çağ | Checkpoint kayıtları korunur; ayrıca ara vermek için aynı noktadan devam sağlayan geçici session kaydı vardır. |
| D-01.24 | Multiplayer & Kayıt | Boş yer varsa oyuncu session’a istediği an katılır. Sonradan gelen, karakterinin doğuştan gelen yeteneği dışında ek ekipmansız başlar; mevcut fiziksel kaynaklarla ekipman hazırlar. |
| D-01.25 | Multiplayer & Kayıt | Oyun, oyuncudan bağımsız bir dedicated server session’ında çalışır; host ayrılınca oyun durmaz. |
| D-01.26 | Multiplayer & Kayıt | Son oyuncu ayrılırsa session kaydedilir ve durur; düşmanlar ve üretim ilerlemez. Bir oyuncu döndüğünde sürer. |
| D-01.27 | İstatistik & Rekor | 1, 2, 3, 4 oyunculu liderlik tablolarında kategori, session boyunca aynı anda bulunan en yüksek oyuncu sayısı ile belirlenir. |
| D-02.01 | İnşa & Merkez | Savunulan ana yapı yalnızca HP/başarısızlık hedefi. İyileşme, üretim, silah atölyesi, depolar ayrı yapılar olarak kurulacak; başta duvar yok. |
| D-02.02 | İnşa & Merkez | Ana yapı başlangıçta kaynakla manuel onarılır; ileride otomatik onarım teknolojileri açılır. |
| D-02.03 | Harita | Her haritada önceden tasarlanmış birden fazla uygun ana yapı konumu bulunur; session başında bunlardan biri seçilir. |
| D-02.04 | İnşa & Merkez | Araziye serbest yerleştirme; yakın yapılar, duvarlar ve taşıma hatları otomatik hizalanabilir (Smart Snap). |
| D-02.05 | İnşa & Merkez | Fiziksel malzeme inşaat alanına teslim edilir; süre başlar, oyuncu başında beklemeden yapı tamamlanır. |
| D-02.06 | İnşa & Merkez | İnşaat hâlindeki yapıların HP’si vardır; düşman saldırısı hasar verebilir, yapı tamamen yıkılabilir. |
| D-02.07 | İnşa & Merkez | Yapılar sökülebilir ama malzemenin bir kısmı kaybolur. Yeni konumda yeniden inşa gerekir. |
| D-02.08 | Kaynak & Lojistik | Depoların kapasitesi sınırlıdır. İlerleyen çağlarda daha büyük depolama çeşitleri/geliştirmeleri açılır. |
| D-02.09 | Kaynak & Lojistik | Depo yıkılırsa içindeki kaynakların bir kısmı yok olur; kalan kaynaklar yere saçılır ve manuel toplanabilir. |
| D-02.10 | Kaynak & Lojistik | Bütün inşaat kaynakları fiziksel olarak inşaat alanına ulaşmalıdır; yakın depodan bile anlık çekme yoktur. |
| D-02.11 | Kaynak & Lojistik | Küçük kaynaklar sınırlı envanterde; büyük/ağır kaynaklar elde veya taşıma araçlarıyla fiziksel taşınır. |
| D-02.12 | Kaynak & Lojistik | Konveyörler, borular, taşıyıcı araçlar ve robotlar çağlarla kademeli açılır. |
| D-02.13 | Üretim & Enerji | İlkel üretim elle veya yakıtla; ilerleyen çağlarda jeneratör ve elektrik şebekesiyle çalışır. |
| D-02.14 | Üretim & Enerji | Elektrik kablo ve direklerle taşınır. Hatlar hasarlanabilir, kapasite sınırları vardır. |
| D-02.15 | Üretim & Enerji | Şebekeden elektrik kesilen bağlı makineler ve elektrikli savunmalar hemen durur; otomatik birikmiş yedek enerji yok. |
| D-02.16 | Üretim & Enerji | Yakındaki yapılarda HP barı ve duman/yangın gibi görsel hasar belirtileri; uzakta yalnız kritik saldırıda kısa yön uyarısı. Global kontrol paneli yok. |
| D-02.17 | Üretim & Enerji | Her makine belirli bir ürün üretir. Yeni çağda eski ürün kaybolmaz, ürün ve makine çeşitliliği genişler. |
| D-02.18 | Üretim & Enerji | Her makinede sınırlı ürün çıkış alanı bulunur. Doluysa üretim durur. Önce manuel, sonra otomatik tahliye mümkündür. |
| D-02.19 | Üretim & Enerji | Mevcut makine geliştirilebilir, ayrıca aynı ürünü yapan paralel üretim hatları kurulabilir. |
| D-02.20 | Üretim & Enerji | Fiziksel lojistik hatlarındaki ayırıcı/yönlendiricilerle belirli ürün hattına öncelik verilebilir. |
| D-02.21 | Düşman & Savunma | Bazı basit savunmalar ek kaynak tüketmez; okçu/topçu/ateşli kuleler mühimmat, gelişmiş sistemler enerji veya yakıt tüketebilir. |
| D-02.22 | Bölüm & Çağ | Tarihsel/teknolojik ilerleme var; büyü çağı ve büyü yetenekleri tasarımdan çıkarıldı. |
| D-02.23 | Bölüm & Çağ | Yeni teknolojik çağ her 20 bölümde gelir. Çağ içindeki ürünler, silahlar ve makineler kademeli açılır. |
| D-02.24 | Karakter & Savaş | Sol analog 360° hareket, sağ analog 360° nişan. Aim assist yok; silah kullanımı kolay ve akıcı olmalı. |
| D-02.25 | Karakter & Savaş | Sağ analog yön verildiği sürece ilgili silah o yöne otomatik ateş eder; ayrı ateş tuşu yok. |
| D-02.26 | Karakter & Savaş | Her karakterde karaktere özgü yakın dövüş silahı + başlangıç hedefi iki ek silah slotu + cooldown bazlı skills. Mana sistemi yok. |
| D-02.27 | Karakter & Savaş | Her karakterin doğuştan yakın dövüş silahı ve skill seti sabit. Ek silahlar değiştirilebilir. |
| D-02.28 | Karakter & Savaş | Bir takımda her karakter yalnızca bir oyuncu tarafından seçilebilir. |
| D-02.29 | Karakter & Savaş | Karakterler bazı işlerde avantajlı olabilir ama herkes savaş, toplama, inşa ve tamir gibi temel işleri yapabilir. |
| D-02.30 | Karakter & Savaş | Oyuncular mühimmat üretir, taşır ve silaha doldurur. Yakın dövüş mühimmat gerektirmez. |
| D-02.31 | Karakter & Savaş | Namlu, şarjör, optik gibi modifikasyonlar fiziksel kaynaklarla üretilebilir. Geliştirmeler yalnız session boyunca geçerlidir. |
| D-02.32 | Karakter & Savaş | Modifikasyon yalnız inşa edilmiş silah atölyesinde yapılabilir; savaşta modifikasyon yapılmaz. |
| D-02.33 | Karakter & Savaş | Silahlar kullanıldıkça yıpranmaz, bozulmaz ve bakım kaynakları tüketmez. |
| D-02.34 | Karakter & Savaş | Can ve geçici bonuslar yaklaşınca otomatik alınır. Fiziksel kaynaklar ve düşen silahlar manuel etkileşimle toplanır. |
| D-02.35 | Düşman & Savunma | Düşmanlardan çıkan silah ve bonuslar mevcut çağın loot havuzundan şansla seçilir; nadir/güçlü ödüllerin olasılığı düşüktür. |

## Formdan gelen 42 karar
| ID | Alan | Tercih |
|---|---|---|
| A-001 | İnşa & Merkez | **A** — Tek sembol bütün çağlarda şekil değiştirir: ateş/ocak → endüstriyel çekirdek → reaktör. |
| A-002 | İnşa & Merkez | **B** — Tüm üretim/iyileşme tesisleri çatı gerektirmez, açık alanda çalışır. |
| A-003 | Kaynak & Lojistik | **C** — Elle/etkileşimle ilk malzemeler toplanır; ilk alet daha sonra üretilir. |
| A-004 | Kaynak & Lojistik | **A** — Sade temel kaynak seti (odun, taş, cevher vb.), çağ ilerledikçe yeni türler. |
| A-005 | Üretim & Enerji | **C** — İlk ürünleri eşzamanlı aç; maliyet ve kaynak farklılaştır. |
| A-006 | Bölüm & Çağ | **A** — Taş → Tunç/Demir → Orta Çağ → Sanayi → Modern → İleri/Kıyamet sonrası. |
| A-007 | Bölüm & Çağ | **A** — Kesin bölüm eşikleri, oyuncu performansından bağımsız. |
| A-008 | Düşman & Savunma | **A** — Düşman türüne göre kurallı davranışlar ve hedef önceliği. |
| A-009 | Düşman & Savunma | **A** — Ana saldırı ve boss için uyarı, küçük baskınlar sürpriz olabilir. |
| A-010 | Karakter & Savaş | **B** — Yakın dövüş silaha geçişle; skills ayrı düğmeler; dodge ayrı tuş. |
| A-011 | Karakter & Savaş | **A** — İlk sürümde 4 farklı karakter; her biri belirgin ama esnek rol. |
| A-012 | Karakter & Savaş | **C** — İyileşme hem tesiste hem üretilmiş taşınabilir sağlık kitleriyle yapılır. |
| A-013 | Karakter & Savaş | **A** — Şarjör + envanterde yedek mühimmat, tek tuşla doldurma. |
| A-014 | Multiplayer & Kayıt | **A** — Ölen oyuncunun bedeni/işareti üsse taşınır; iyileştirme tesisinde canlandırılır. |
| A-015 | Multiplayer & Kayıt | **A** — Tam dünya snapshot; değişken harita, makine, stok, karakter ve RNG durumu kaydedilir. |
| A-016 | Multiplayer & Kayıt | **A** — Çoğunluk; eşitlikte checkpoint’e devam; çevrimdışı oyuncu oy kullanmaz. |
| A-017 | İstatistik & Rekor | **C** — Rekor en yüksek bölüm, süre tüm oturum, istatistikler deneme bazında ayrılır. |
| A-018 | İstatistik & Rekor | **A** — Oyuncu doğrudan hasarı ayrı, kule hasarı takım/yapı ayrı. |
| A-019 | Multiplayer & Kayıt | **A** — Sunucu onaylı online leaderboard + cihaz içi oturum geçmişi. |
| A-020 | Karakter & Savaş | **A** — Belirli düşük ihtimaller; güçlü bonuslar kısa sürer ve birikmez. |
| A-021 | Üretim & Enerji | **A** — Her makinenin sınırlı input ve output tamponu; girdi yoksa durur. |
| A-022 | Üretim & Enerji | **B** — Şebeke aşırı yükte tamamen kapanır, oyuncu sistemi düzeltir. |
| A-023 | Kaynak & Lojistik | **A** — Sabit düşük üretim debisi; daha çok verim için farklı kaynak noktaları bulunur. |
| A-024 | Harita | **A** — Orman, kanyon/dağ, bataklık gibi üç zıt biyom. |
| A-025 | Harita | **C** — Harita seçimi sırasında lider başlangıç yerini seçer. |
| A-026 | Harita | **A** — Önceden onaylanmış varyasyon kombinasyonları + erişim kontrolleri. |
| A-027 | İnşa & Merkez | **A** — Düşman/oyuncu işgal ettiği alana inşa engeli, yakındaki saldırıdan zarar. |
| A-028 | İnşa & Merkez | **A** — Hasara oranlı kaynak ve süre; sökümde sabit yüzde geri kazanım. |
| A-029 | Karakter & Savaş | **A** — Yakın dövüş yüksek risk/yüksek etki, mermi az; karakter sınıfları farklılaşır. |
| A-030 | Düşman & Savunma | **A** — Bossun sabit çekirdek hareket seti + rastgele seçilen ikinci faz/yardımcı düşmanlar. |
| A-031 | Multiplayer & Kayıt | **A** — Aktif/geri dönme hakkı olan karakterler rezerve; yeni oyuncu boş karakter seçer. |
| A-032 | Multiplayer & Kayıt | **C** — Karakter yok olur, geri döndüğünde aynı ekipmanıyla doğar. |
| A-033 | Multiplayer & Kayıt | **C** — Herkes her şeyi harcayabilir, geçmiş/izin sistemi hiç yok. |
| A-034 | İstatistik & Rekor | **A** — Hasar + kill + kaynak + tamir + üretim katkısı; takım toplamları. |
| A-035 | Multiplayer & Kayıt | **C** — Final yok, rekor sonsuza kadar sürer; yalnız yenilgi/manuel bırakma vardır. |
| A-036 | Mobil & Teknik | **B** — Parmakla sürükleme, uzun basma ve hızlı yerleştirme. |
| A-037 | Mobil & Teknik | **A** — Kamera karakteri takip eder; zoom ve basit minimap vardır. |
| A-038 | Mobil & Teknik | **A** — Sunucu boşken session snapshot kaydedilir, işlem kapanır; istekte yeniden başlar. |
| A-039 | Mobil & Teknik | **C** — Yeni repo açılır; eski repo yalnız deneme olarak kalır. |
| A-040 | Mobil & Teknik | **A** — Önce hedef cihaz sınıfı ve fps, ardından entity/üretim sınırı testle belirlensin. |
| A-041 | Düşman & Savunma | **A** — Yalnız keşif/algılama veya tasarlanmış baskın bilgisine göre hedef seçerler. |
| A-042 | Mobil & Teknik | **A** — İlk sürümde oyuncu botu yok, ileride eklenebilir. |

## Devredilen açık noktalar için çözümler
### R-001 — Checkpoint tekrar RNG modeli
**Karar:** Ara verme kaydı harita, düşman ve RNG durumunu aynen sürdürür. Yenilgi sonrası checkpoint geri yüklemesi sabit map/boss kimliğini korur, yalnız sonraki çatışma varyasyonları için attempt_index temelli yeni alt tohum üretir.
*Gerekçe/iz:* T1 / A-015 / A-030

### R-002 — Takım canlanması ve klinik
**Karar:** Takımdan en az bir aktif oyuncu hayattaysa ölen üye, aktif oyun süresine bağlı bir bekleme sonunda tekrar doğar. Çalışır durumdaki klinik süreyi kısaltır; klinik hiç yoksa daha uzun beklenir. Oyuncu tamamen ölmeden önce sürünerek yardım arayabilir. Tek oyuncunun tam ölümü checkpoint tetikler.
*Gerekçe/iz:* T2 / D-01.19–21 / A-014; son kullanıcı talebi

### R-003 — Altıncı çağdan sonra sonsuz oyun
**Karar:** Altı dönem sırasıyla 1–20 Taş, 21–40 Tunç/Demir, 41–60 Orta Çağ, 61–80 Sanayi, 81–100 Modern, 101–120 İleri/Kıyamet Sonrası. 121+ yeni çağ açılmaz; boss/elite/AI baskısı ve sayısal zorluk ölçeklenir, 20 bölümlük üst kademe döngüleri devam eder.
*Gerekçe/iz:* T3 / A-006 / D-02.23 / A-035

### R-004 — Lobby lideri ve server otoritesi
**Karar:** Dedicated server oyun durumunun tek otoritesidir. Lobby lideri ilk katılan yetkili oyuncudur; ayrılırsa aktifler arasından katılım sırasına göre atanır. Lider sadece harita/başlangıç noktasını başlatma öncesi belirler; ortak kaynak üzerinde veto hakkı yoktur.
*Gerekçe/iz:* T4 / D-01.25 / A-025 / A-033

### R-005 — Session kadro kilidi
**Karar:** Bir session en fazla dört BENZERSİZ oyuncu kimliği kaydeder. Boş yerler ilk dört kimlik dolana kadar doldurulabilir; kayıtlı kişi ayrılsa da koltuğu ona ait kalır, beşinci kimlik katılamaz. İlk dört oyuncunun tümü ayrıldığında da yalnız aynı kimlikler geri gelebilir. Yeni session tüm kayıtları sıfırlar.
*Gerekçe/iz:* T5 / A-031 / D-01.24; son kullanıcı talebi

### R-006 — Şebeke kilitlenmesini önleme
**Karar:** Şebekeye yük ekleme ya da bağlı makineyi elle kapatma elektrik gerektirmez. Aşırı yükte ağ tamamen kapanır; talep üretim kapasitesinin altına düşünce otomatik tekrar devreye girer. Başlangıç/güvenli kurtarma için manuel yakıtlı üretim ayrı çalışabilir.
*Gerekçe/iz:* T6 / A-022 / D-02.15

### R-007 — Sonsuz mod için kaynak güvencesi
**Karar:** Her teknolojik çağda asgari yaşayabilir savunma/mühimmat/onarım zinciri yalnız yenilenebilir temel kaynaklar veya tekrar elde edilebilen ürünlerle sürdürülebilir. Tükenebilir nadir kaynaklar avantaj, performans ve seçenek sağlar; zorunlu soft-lock yaratamaz.
*Gerekçe/iz:* T7 / D-01.11 / A-023

### R-008 — Ortak kaynak kullanım yetkisi
**Karar:** Tüm kimliği doğrulanmış aktif takım üyeleri ortak fiziksel malzemeyi izin onayı olmadan kullanabilir. Harcama etkisi server tarafından atomik doğrulanır; kullanıcıya işlem geçmişi, veto veya kişisel para sistemi eklenmez.
*Gerekçe/iz:* T8 / A-033 / D-01.13

### R-009 — Rekor sayımı ve oyuncu varlığı
**Karar:** 1–4 kişilik sınıflandırma, aynı anda aktif ve oyunu kontrol eden doğrulanmış benzersiz oyuncu sayısının tepesine göre yapılır. Salt bağlanıp hiç oynamayan kişi rekor oyuncusu sayılmaz; test için asgari 30 sn oyun katılımı veya bir aktif bölüm geçişine iştirak koşulu kullanılır. Süre ve tekrar denemeler ayrıca kaydedilir.
*Gerekçe/iz:* T9 / D-01.27 / A-017

### R-010 — Sunucu kapanma ve geri yükleme
**Karar:** Son üye ayrıldığında snapshot atomik yazılır, bellek boşaltılır ve o session server işlemi kapanabilir. Aynı session için eşzamanlı resume isteklerinde tek kilit/tek server otoritesi vardır. Kayıt versiyonu, bütünlük kontrolü ve son geçerli snapshot rollback gerekir.
*Gerekçe/iz:* T10 / A-038 / D-01.26

### R-011 — Binaların görünümü
**Karar:** İlk prototipte iyileşme, üretim ve depolar açık alandaki yapılardır; saydam çatıya veya ayrı iç mekân sahnesine gerek yoktur. İleri tarihte dekoratif çatı seçilebilir.
*Gerekçe/iz:* T11 / A-002

### R-012 — Mobil kontrol çakışmaları
**Karar:** Twin-stick dokunma alanları inşa sürükleme ve HUD düğmelerinden ayrılır. Yerleştirme modundayken sağ joystick alanı yapı yerleştirme sayılmaz. 16:9 ve dar/uzun ekranlarda touch hedefleri prototipte test edilir.
*Gerekçe/iz:* T12 / A-010 / A-036 / A-037

### R-013 — Yenilgi ve oylama uygulama
**Karar:** Yenilgide çevrimiçi oyuncular çoğunlukla checkpoint veya sıfırdan başlatmayı seçer; eşitlikte checkpoint seçilir. Çevrimdışı üyeler oya dahil edilmez; solo doğrudan seçer.
*Gerekçe/iz:* A-016 / D-01.22

### R-014 — Aylak/süreli canlandırma davranışı
**Karar:** Canlanma bekleme süresi yalnız en az bir takım üyesi hayattayken oyun zamanı ilerlediğinde azalır; boş server duraklamasında işlemez. Çalışan klinik olup olmaması doğma zamanını etkiler. İyileşme tesisi yarım kalmış/hasarlıysa hızlandırma uygulamaz.
*Gerekçe/iz:* R-002 / D-01.26

### R-015 — Oyuncu slotu ve karakter rezervasyonu
**Karar:** Benzersiz dört oyuncu kimliği ve benzersiz karakter seçimi ayrı kurallardır. Bağlantısı kopan karakter yok olur, slot ve eşyaları korunur; geri döndüğünde aynı karakter/eşya ile başlar.
*Gerekçe/iz:* R-005 / A-031 / A-032

### R-016 — Prototip yaklaşımı
**Karar:** Tam ürün değil; P0 dikey kesit bir harita varyasyonu, tek yerel oyuncu, dört basit sınıf tanımı ve örnek üretim/savunma/ölüm/otomasyon akışlarını oynanabilir gösterir. Dedicated multiplayer, üretim kapasitesi ve 6 çağın tam içerikleri P1+ ayrı test edilmelidir.
*Gerekçe/iz:* Kullanıcının işlev testli, basit karakterli prototip isteği

## Balans/test aşamasına kalan değerler
Bölüm başına düşman adedi, yürüme ve taşıma hızları, hasar/can değerleri, yapım tarifleri, maliyetler, yeniden doğma süresi, şebeke kapasitesi, mobil performans, üretim debileri ve sunucu işletme maliyeti veri tablosundan ayarlanacaktır. Prototipte seçilen sayılar **kullanıcı tarafından onaylanmış balans** anlamına gelmez.

## Güncel repo iş akışı (19.11.2026 kullanıcı teyidi)
Mevcut `ErtugrulGurler/Mayhem` GitHub reposu kullanılır. Codex yeni bir feature branch açar, eski sabit-yol prototipini git geçmişi ve gerekirse `legacy/` altında koruyarak yeni oyunu geliştirir ve PR oluşturur. İnceleme ve test ardından `main`e merge edilir. Eski A-039 ayrı repo varsayımı, bu kullanıcı talebiyle bu teslim akışı bakımından geçersiz kılındı.
