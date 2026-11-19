
# MAYHEM — Eksiksiz Karar Kaydı (62 D + 42 A + 16 R)

**Kaynak:** Kullanıcının 19.11.2026 JSON çıktısı. Orijinal ham JSON bu pakete değişmeden eklenmiştir. Son kullanıcının talimatı eski tercihten üstündür. D-01.20/A-014 canlandırma modeli R-002/R-014 ile; A-039 ayrı repo modeli sonraki mevcut repo talimatıyla geçersizleşti.

## 62 önceki D-kararı

### D-01.01 — Harita ölçeği

**Alan:** Harita  
**Karar:** Orta-büyük: ana yapıdan en uzak erişilebilir noktaya normal yürüyüşle yaklaşık 60–90 saniye.
**Detay:** Yönsel tek yolculuk; gerçek dünya birimi, koşma/hız ve rota test sırasında belirlenecek.

### D-01.02 — Ana harita sayısı

**Alan:** Harita  
**Karar:** 3 ayrı, elle tasarlanmış ana harita. İlk geliştirmede bir tanesi tamamlanacak.
**Detay:** Haritaların orman/dağ/bataklık gibi temaları henüz seçilmedi.

### D-01.03 — Oturumlar arası harita varyasyonu

**Alan:** Harita  
**Karar:** Orta değişkenlik: ana coğrafya korunur; bazı kaynak noktaları, düşman girişleri, geçitler, köprüler ve engeller değişebilir.
**Detay:** Tamamen procedural harita değil; önceden tasarlanmış seçenekler arasından kontrollü varyasyon.

### D-01.04 — Yükselti ve geçitler

**Alan:** Harita  
**Karar:** Yükselti farkları doğal engel, hareket/geçit ve üretim hattı güzergâhı zorluğudur. Silah hasarına veya menziline bonus vermez.
**Detay:** Tepe, rampa, vadi, uçurum ve dar geçitler; fog of war henüz tasarımda yok.

### D-01.05 — Serbest inşa

**Alan:** İnşa & Merkez  
**Karar:** Duvarlar, kuleler, makineler ve taşıma hatları uygun arazide istenen yere kurulabilir.
**Detay:** Arazi, yükselti, doğal engel, mevcut yapı ve bağlantılar yerleştirmeyi sınırlar.

### D-01.06 — Harita geneline yayılma

**Alan:** İnşa & Merkez  
**Karar:** İnşa alanı merkeze bağlı bir yarıçapla sınırlandırılmayacak; uygun her yerde tesis, depo, savunma ve ileri karakol kurulabilir.

### D-01.07 — Duvarlara karşı farklı düşman AI

**Alan:** Düşman & Savunma  
**Karar:** Tam duvar kapatma serbest; düşman türüne göre yol arama, duvar yıkma, engel aşma/tırmanma gibi farklı tepkiler olacak.
**Detay:** Düşmanlar yalnız en kısa yolu izleyen robotlar olmayacak; kesin davranış modellemesi açık.

### D-01.08 — Üretim hatlarına baskın

**Alan:** Düşman & Savunma  
**Karar:** Üretim, depo ve lojistik hatlarını özel sabotajcılar veya baskın grupları hedefler; normal düşmanlar çoğunlukla ana yapıya yönelir.

### D-01.09 — Üretim tesisi hasarı

**Alan:** Üretim & Enerji  
**Karar:** Kademeli hasar: verim düşer, üretim durabilir, tesis onarılabilir veya tamamen yıkılabilir.

### D-01.10 — Yapıların onarımı

**Alan:** İnşa & Merkez  
**Karar:** Başlangıçta oyuncular manuel onarır; ilerleyen çağlarda tamir makineleri/robotlarla otomasyon açılır.

### D-01.11 — Tükenir ve tükenmez kaynaklar

**Alan:** Kaynak & Lojistik  
**Karar:** Bazı temel kaynak kaynakları sınırsız/sürekli erişilebilir; değerli kaynaklar tükenebilir. Yeni çağlarda yeni/niş kaynaklar açılır.
**Detay:** Sonsuz oturumlarda zorunlu temel kaynağın tükenmesi nedeniyle hard-lock oluşmaması hedeflenir.

### D-01.12 — Kaynakların fiziksel taşınması

**Alan:** Kaynak & Lojistik  
**Karar:** Malzemeler elde veya taşıma araçlarıyla fiziksel olarak taşınacak; doğrudan global malzeme havuzundan kullanılmayacak.
**Detay:** Küçük/büyük yük ayrımı daha sonra D-02.11 ile detaylandırıldı.

### D-01.13 — Yalnız fiziksel kaynak ekonomisi

**Alan:** Kaynak & Lojistik  
**Karar:** Kaynaklar takımın ortak kullanımında, yerel fiziksel depolarda. Para, soyut geliştirme puanı ve satın alınan karakter buff ekonomisi çıkarıldı.
**Detay:** Düşmanlardan can, fiziksel malzeme, silah veya geçici hız bonusu gibi drop olabilir; ana yapıdan pasif kaynak geliri daha sonra iptal edildi.

### D-01.14 — Üretim zinciri uzunluğu

**Alan:** Üretim & Enerji  
**Karar:** Başlangıçta basit üretim; sonraki çağlarda yaklaşık 2–4 aşamalı production line zincirleri.

### D-01.15 — Taşıma otomasyonu takvimi

**Alan:** Kaynak & Lojistik  
**Karar:** İlk 10 bölüm manuel kaynak taşıma. Ardından çağlarla birlikte fiziksel otomatik taşıma sistemleri açılır.

### D-01.16 — Zor ama toparlanabilir denge

**Alan:** Bölüm & Çağ  
**Karar:** Düşman gücü oyuncular geri kaldığında azalmaz. Kötü başlangıçtan doğru strateji ve yüksek beceriyle dönüş mümkün olmalı.

### D-01.17 — Bölümün tamamlanması

**Alan:** Bölüm & Çağ  
**Karar:** Ana düşman saldırısı temizlenince bölüm ilerler. Kısa geçiş olabilir; düşük seviyeli tehdit hiçbir zaman tamamen bitmez.
**Detay:** 4 kişilik ekip bölümleri daha hızlı temizleyebilir; bölüm geçişleri salt sabit süreye bağlı değil.

### D-01.18 — Boss ve güçlü saldırı sıklığı

**Alan:** Düşman & Savunma  
**Karar:** Her 10 bölümde büyük boss; aradaki 5. bölümlerde güçlü saldırılar. Checkpoint her 5 bölümde.

### D-01.19 — Yere düşme ve kurtarılma

**Alan:** Karakter & Savaş  
**Karar:** HP sıfırlanınca karakter sürünür, kan kaybeder ve sınırlı kurtarma süresi vardır. Takım arkadaşları kurtarabilir.
**Detay:** Solo oyuncu uygun koşullarda sürünerek güvenli noktaya ulaşabilir; süre/değerler açık.

### D-01.20 — Tam ölümün takım tarafından geri alınması

**Alan:** Karakter & Savaş  
**Karar:** Tamamen ölen oyuncu otomatik doğmaz; takımın özel kurtarma/geri getirme işlemi gerekir. Üzerindeki fiziksel kaynaklar ölüm noktasında kalır.
**Detay:** Önceki zamanla otomatik respawn kararı kullanıcı tarafından geri alındı. Multiplayer kurtarma prosedürü açık.

### D-01.21 — Singleplayer tam ölüm

**Alan:** Bölüm & Çağ  
**Karar:** Solo oyuncu tamamen ölürse doğrudan son checkpoint durumuna döner.
**Detay:** Yere düşme safhasında kendini kurtarma ihtimali D-01.19 ile birlikte korunur.

### D-01.22 — Yenilgi sonrası seçenekler

**Alan:** Bölüm & Çağ  
**Karar:** Takım tümden ölürse veya ana yapı yıkılırsa son checkpoint ya da sıfırdan yeni session seçilebilir. Multiplayer kararı oylamayla alınır.

### D-01.23 — Checkpoint ve geçici kayıt

**Alan:** Bölüm & Çağ  
**Karar:** Checkpoint kayıtları korunur; ayrıca ara vermek için aynı noktadan devam sağlayan geçici session kaydı vardır.
**Detay:** Geçici kayıt yenilgiye geri sarma veya checkpoint atlama aracı olamaz.

### D-01.24 — Her zaman katılım, başlangıç ekipmanı

**Alan:** Multiplayer & Kayıt  
**Karar:** Boş yer varsa oyuncu session’a istediği an katılır. Sonradan gelen, karakterinin doğuştan gelen yeteneği dışında ek ekipmansız başlar; mevcut fiziksel kaynaklarla ekipman hazırlar.
**Detay:** 1–4 oyuncu; 1–2 oyuncunun çok ileri aşamalara çıkması olağanüstü zor olabilir.

### D-01.25 — Bağımsız otoriter sunucu

**Alan:** Multiplayer & Kayıt  
**Karar:** Oyun, oyuncudan bağımsız bir dedicated server session’ında çalışır; host ayrılınca oyun durmaz.
**Detay:** Barındırma, maliyet, headless dağıtım ve veri güvenilirliği uygulama konularıdır.

### D-01.26 — Boş session duraklatma

**Alan:** Multiplayer & Kayıt  
**Karar:** Son oyuncu ayrılırsa session kaydedilir ve durur; düşmanlar ve üretim ilerlemez. Bir oyuncu döndüğünde sürer.

### D-01.27 — Rekor kategorisi

**Alan:** İstatistik & Rekor  
**Karar:** 1, 2, 3, 4 oyunculu liderlik tablolarında kategori, session boyunca aynı anda bulunan en yüksek oyuncu sayısı ile belirlenir.
**Detay:** Örneğin 30’a solo ulaşıp 50’de dört kişi olmuşsa 4 kişilik rekor; katılımın hile amaçlı manipülasyon sınırları açık.

### D-02.01 — Ana yapı yalnız savunma hedefi

**Alan:** İnşa & Merkez  
**Karar:** Savunulan ana yapı yalnızca HP/başarısızlık hedefi. İyileşme, üretim, silah atölyesi, depolar ayrı yapılar olarak kurulacak; başta duvar yok.
**Detay:** Önceki merkezden pasif gelir fikri iptal; üssün araçları oyuncuların kaynak toplaması ve inşasıyla açılır.

### D-02.02 — Ana yapı onarımı

**Alan:** İnşa & Merkez  
**Karar:** Ana yapı başlangıçta kaynakla manuel onarılır; ileride otomatik onarım teknolojileri açılır.

### D-02.03 — Ana yapının başlangıç konumu

**Alan:** Harita  
**Karar:** Her haritada önceden tasarlanmış birden fazla uygun ana yapı konumu bulunur; session başında bunlardan biri seçilir.
**Detay:** 3–5 noktası örnek verilmişti; kesin sayı seçilmedi.

### D-02.04 — Smart Snap yerleştirme

**Alan:** İnşa & Merkez  
**Karar:** Araziye serbest yerleştirme; yakın yapılar, duvarlar ve taşıma hatları otomatik hizalanabilir (Smart Snap).

### D-02.05 — Süreli, kendi kendine tamamlanan inşaat

**Alan:** İnşa & Merkez  
**Karar:** Fiziksel malzeme inşaat alanına teslim edilir; süre başlar, oyuncu başında beklemeden yapı tamamlanır.

### D-02.06 — Tamamlanmamış yapıya hasar

**Alan:** İnşa & Merkez  
**Karar:** İnşaat hâlindeki yapıların HP’si vardır; düşman saldırısı hasar verebilir, yapı tamamen yıkılabilir.

### D-02.07 — Sökme ve malzeme geri kazanımı

**Alan:** İnşa & Merkez  
**Karar:** Yapılar sökülebilir ama malzemenin bir kısmı kaybolur. Yeni konumda yeniden inşa gerekir.

### D-02.08 — Depo kapasitesi

**Alan:** Kaynak & Lojistik  
**Karar:** Depoların kapasitesi sınırlıdır. İlerleyen çağlarda daha büyük depolama çeşitleri/geliştirmeleri açılır.

### D-02.09 — Depo yıkımında stok kaybı

**Alan:** Kaynak & Lojistik  
**Karar:** Depo yıkılırsa içindeki kaynakların bir kısmı yok olur; kalan kaynaklar yere saçılır ve manuel toplanabilir.

### D-02.10 — İnşaat malzemesinin gerçek teslimi

**Alan:** Kaynak & Lojistik  
**Karar:** Bütün inşaat kaynakları fiziksel olarak inşaat alanına ulaşmalıdır; yakın depodan bile anlık çekme yoktur.
**Detay:** Çağlarla birlikte teslim taşıması otomatikleşebilir; kaynak konumu ve güzergâh önemlidir.

### D-02.11 — Küçük ve büyük kaynakların taşınması

**Alan:** Kaynak & Lojistik  
**Karar:** Küçük kaynaklar sınırlı envanterde; büyük/ağır kaynaklar elde veya taşıma araçlarıyla fiziksel taşınır.

### D-02.12 — Karma lojistik araçları

**Alan:** Kaynak & Lojistik  
**Karar:** Konveyörler, borular, taşıyıcı araçlar ve robotlar çağlarla kademeli açılır.

### D-02.13 — Çağlara göre enerji

**Alan:** Üretim & Enerji  
**Karar:** İlkel üretim elle veya yakıtla; ilerleyen çağlarda jeneratör ve elektrik şebekesiyle çalışır.

### D-02.14 — Fiziksel elektrik şebekesi

**Alan:** Üretim & Enerji  
**Karar:** Elektrik kablo ve direklerle taşınır. Hatlar hasarlanabilir, kapasite sınırları vardır.

### D-02.15 — Elektrik kesilince anlık durma

**Alan:** Üretim & Enerji  
**Karar:** Şebekeden elektrik kesilen bağlı makineler ve elektrikli savunmalar hemen durur; otomatik birikmiş yedek enerji yok.
**Detay:** Kullanıcı önerilen pil/akü alternatifi yerine A seçti. İleride bağımsız enerji kaynağı üretme olasılığı ayrıca değerlendirilir.

### D-02.16 — Yapı durumunu yerel gözlemleme

**Alan:** Üretim & Enerji  
**Karar:** Yakındaki yapılarda HP barı ve duman/yangın gibi görsel hasar belirtileri; uzakta yalnız kritik saldırıda kısa yön uyarısı. Global kontrol paneli yok.

### D-02.17 — Makineye özgü sabit ürün

**Alan:** Üretim & Enerji  
**Karar:** Her makine belirli bir ürün üretir. Yeni çağda eski ürün kaybolmaz, ürün ve makine çeşitliliği genişler.

### D-02.18 — Makine çıkış tamponu

**Alan:** Üretim & Enerji  
**Karar:** Her makinede sınırlı ürün çıkış alanı bulunur. Doluysa üretim durur. Önce manuel, sonra otomatik tahliye mümkündür.

### D-02.19 — Kapasite geliştirme ve paralel üretim

**Alan:** Üretim & Enerji  
**Karar:** Mevcut makine geliştirilebilir, ayrıca aynı ürünü yapan paralel üretim hatları kurulabilir.

### D-02.20 — Ayırıcılar ve kaynak öncelikleri

**Alan:** Üretim & Enerji  
**Karar:** Fiziksel lojistik hatlarındaki ayırıcı/yönlendiricilerle belirli ürün hattına öncelik verilebilir.

### D-02.21 — Savunma türüne göre tüketim

**Alan:** Düşman & Savunma  
**Karar:** Bazı basit savunmalar ek kaynak tüketmez; okçu/topçu/ateşli kuleler mühimmat, gelişmiş sistemler enerji veya yakıt tüketebilir.

### D-02.22 — Büyü yok, teknolojik çağlar

**Alan:** Bölüm & Çağ  
**Karar:** Tarihsel/teknolojik ilerleme var; büyü çağı ve büyü yetenekleri tasarımdan çıkarıldı.
**Detay:** Önceden önerilen Runik Ocak/Mana/büyü alternatifleri geçersiz çalışma örnekleridir.

### D-02.23 — 20 bölümde çağ geçişi

**Alan:** Bölüm & Çağ  
**Karar:** Yeni teknolojik çağ her 20 bölümde gelir. Çağ içindeki ürünler, silahlar ve makineler kademeli açılır.
**Detay:** Düşman gelişimi bölüme bağlı, oyuncunun teknolojiye yetişmesi ürettiği kaynak ve stratejiye bağlı.

### D-02.24 — Twin-stick nişan ve hareket

**Alan:** Karakter & Savaş  
**Karar:** Sol analog 360° hareket, sağ analog 360° nişan. Aim assist yok; silah kullanımı kolay ve akıcı olmalı.

### D-02.25 — Sağ analogla otomatik ateş

**Alan:** Karakter & Savaş  
**Karar:** Sağ analog yön verildiği sürece ilgili silah o yöne otomatik ateş eder; ayrı ateş tuşu yok.

### D-02.26 — Silah slotları, doğal yakın dövüş ve skills

**Alan:** Karakter & Savaş  
**Karar:** Her karakterde karaktere özgü yakın dövüş silahı + başlangıç hedefi iki ek silah slotu + cooldown bazlı skills. Mana sistemi yok.
**Detay:** Slot/skill sayılarını kodda sabit kısıtlara bağlamayacak modüler mimari.

### D-02.27 — Karaktere özgü sabit yetenekler

**Alan:** Karakter & Savaş  
**Karar:** Her karakterin doğuştan yakın dövüş silahı ve skill seti sabit. Ek silahlar değiştirilebilir.
**Detay:** Önce karma özelleştirme (C) seçilmiş, kullanıcı daha sonra açıkça A’ya çevirmiştir.

### D-02.28 — Aynı karakter seçilemez

**Alan:** Karakter & Savaş  
**Karar:** Bir takımda her karakter yalnızca bir oyuncu tarafından seçilebilir.

### D-02.29 — Esnek karakter rolleri

**Alan:** Karakter & Savaş  
**Karar:** Karakterler bazı işlerde avantajlı olabilir ama herkes savaş, toplama, inşa ve tamir gibi temel işleri yapabilir.

### D-02.30 — Oyuncu silahlarında gerçek mühimmat

**Alan:** Karakter & Savaş  
**Karar:** Oyuncular mühimmat üretir, taşır ve silaha doldurur. Yakın dövüş mühimmat gerektirmez.

### D-02.31 — Modüler silah parçaları

**Alan:** Karakter & Savaş  
**Karar:** Namlu, şarjör, optik gibi modifikasyonlar fiziksel kaynaklarla üretilebilir. Geliştirmeler yalnız session boyunca geçerlidir.

### D-02.32 — Silah modifikasyonu atölyede

**Alan:** Karakter & Savaş  
**Karar:** Modifikasyon yalnız inşa edilmiş silah atölyesinde yapılabilir; savaşta modifikasyon yapılmaz.

### D-02.33 — Silah dayanıklılığı yok

**Alan:** Karakter & Savaş  
**Karar:** Silahlar kullanıldıkça yıpranmaz, bozulmaz ve bakım kaynakları tüketmez.

### D-02.34 — Loot toplama şekli

**Alan:** Karakter & Savaş  
**Karar:** Can ve geçici bonuslar yaklaşınca otomatik alınır. Fiziksel kaynaklar ve düşen silahlar manuel etkileşimle toplanır.

### D-02.35 — Çağa uygun rastgele loot

**Alan:** Düşman & Savunma  
**Karar:** Düşmanlardan çıkan silah ve bonuslar mevcut çağın loot havuzundan şansla seçilir; nadir/güçlü ödüllerin olasılığı düşüktür.
**Detay:** Kullanıcının bu turdaki B seçimiyle onaylandı.

## 42 A-sorusu, kullanıcı seçimleri ve bütün orijinal seçenekler

### A-001 — Merkez sembolün çağlara göre kimliği

**Bağlam:** Savunulan yapı yalnız HP hedefi; büyü kaldırıldı. Sembole ve görsel evrimine karar vermeliyiz.  
**Kullanıcı seçimi: A — Tek sembol bütün çağlarda şekil değiştirir: ateş/ocak → endüstriyel çekirdek → reaktör.**

- A [SEÇİLDİ]: Tek sembol bütün çağlarda şekil değiştirir: ateş/ocak → endüstriyel çekirdek → reaktör.
- B [seçilmedi]: Merkez yapı görseli her çağda tamamen farklı nesneye dönüşür.
- C [seçilmedi]: Aynı görsel çekirdek tüm çağlarda korunur; yalnız çevresel tasarım değişir.

### A-002 — Üs çatısının ve içerideki tesislerin görünürlüğü

**Bağlam:** Başlangıçta hazır kale yok. Oyuncular kendi işlevsel binalarını kurabilir; görüşü engelleyen çatılar nasıl gösterilsin?  
**Kullanıcı seçimi: B — Tüm üretim/iyileşme tesisleri çatı gerektirmez, açık alanda çalışır.**

- A [seçilmedi]: Oyuncu yaklaşınca veya içeri girince çatı saydam olur; iç mekan aynı sahnede.
- B [SEÇİLDİ]: Tüm üretim/iyileşme tesisleri çatı gerektirmez, açık alanda çalışır.
- C [seçilmedi]: Çatılar ayrı iç mekân sahnesine geçişle çözülür.

### A-003 — İlk 10 bölümde başlangıç araçları

**Bağlam:** Sıfırdan başlayan oyuncu ilk kaynakları toplamak ve ilk tesisi kurmak için neyle başlasın?  
**Kullanıcı seçimi: C — Elle/etkileşimle ilk malzemeler toplanır; ilk alet daha sonra üretilir.**

- A [seçilmedi]: Her karakterin basit toplama aleti olur; başlangıçta başka ekipman yok.
- B [seçilmedi]: Ana yapı yakınında ücretsiz temel el aletleri bulunur.
- C [SEÇİLDİ]: Elle/etkileşimle ilk malzemeler toplanır; ilk alet daha sonra üretilir.

### A-004 — Temel kaynaklar ve çağlara özgü madenler

**Bağlam:** Üretim tariflerinin temel girdilerini netleştirmek gerekiyor.  
**Kullanıcı seçimi: A — Sade temel kaynak seti (odun, taş, cevher vb.), çağ ilerledikçe yeni türler.**

- A [SEÇİLDİ]: Sade temel kaynak seti (odun, taş, cevher vb.), çağ ilerledikçe yeni türler.
- B [seçilmedi]: Ayrıntılı çok sayıda ham maddeyle başlangıç.
- C [seçilmedi]: Her ana haritanın kendine özgü ham madde listesi olur.

### A-005 — İlk üretim tesisleri ve tarifleri

**Bağlam:** İlk bölümlerde en fazla 2–4 aşamalı zincir hedefleniyor. İlk hangi ürünler üretilmeli?  
**Kullanıcı seçimi: C — İlk ürünleri eşzamanlı aç; maliyet ve kaynak farklılaştır.**

- A [seçilmedi]: Önce duvar/tuzak/ok, sonra iyileşme ve mühimmat.
- B [seçilmedi]: Önce iyileşme/korunma, sonra savunma üretimi.
- C [SEÇİLDİ]: İlk ürünleri eşzamanlı aç; maliyet ve kaynak farklılaştır.

### A-006 — Çağların sırası ve sayısı

**Bağlam:** Her 20 bölümde ilerleme var; büyü yok. Kesin teknolojik dönemleri seçmedik.  
**Kullanıcı seçimi: A — Taş → Tunç/Demir → Orta Çağ → Sanayi → Modern → İleri/Kıyamet sonrası.**

- A [SEÇİLDİ]: Taş → Tunç/Demir → Orta Çağ → Sanayi → Modern → İleri/Kıyamet sonrası.
- B [seçilmedi]: Taş → Orta Çağ → Sanayi → Modern → İleri Teknoloji (daha az çağ).
- C [seçilmedi]: Tarihsel isimler yerine teknoloji seviyeleri I–V; görsel dönem sonradan belirlenir.

### A-007 — Teknoloji hangi eşikte açılır?

**Bağlam:** 20 bölüm/çağ; içeride otomasyon ve silahlar kademeli açılır. Hangi tetikleyici?  
**Kullanıcı seçimi: A — Kesin bölüm eşikleri, oyuncu performansından bağımsız.**

- A [SEÇİLDİ]: Kesin bölüm eşikleri, oyuncu performansından bağımsız.
- B [seçilmedi]: Bölüm eşikleri + özel boss sonrası belirli teknolojiler.
- C [seçilmedi]: Kaynak keşfi şartı, bölüm ilerlese de teknolojiler keşfedilince açılır.

### A-008 — Düşman AI hedef önceliği

**Bağlam:** Ana yapı, oyuncular, savunmalar ve sabotajcıların hedefleri için temel kural gerekir.  
**Kullanıcı seçimi: A — Düşman türüne göre kurallı davranışlar ve hedef önceliği.**

- A [SEÇİLDİ]: Düşman türüne göre kurallı davranışlar ve hedef önceliği.
- B [seçilmedi]: Dinamik olarak oyuncu/zayıf yapı/üretim tehdidini değerlendirir; tür etkisi de var.
- C [seçilmedi]: Büyük bölüm/boss olaylarında belirli hedefleri planlı seçerler.

### A-009 — Düşman dalgası ve kriz uyarıları

**Bağlam:** Ana saldırı arası küçük tehdit sürüyor; haksız sürprizlere karşı uyarı sınırını belirlemeliyiz.  
**Kullanıcı seçimi: A — Ana saldırı ve boss için uyarı, küçük baskınlar sürpriz olabilir.**

- A [SEÇİLDİ]: Ana saldırı ve boss için uyarı, küçük baskınlar sürpriz olabilir.
- B [seçilmedi]: Tüm ciddi baskınlar önceden yön/zaman uyarısı verir.
- C [seçilmedi]: Hiç uyarı yok; oyuncu çevreyi izlemeli.

### A-010 — Yakın dövüş, dodge ve skill kontrolü

**Bağlam:** Sağ analog ateş ediyor; karaktere özel yakın dövüş ve cooldown yetenekler var. Mobil ekranda ek eylemler nasıl yapılacak?  
**Kullanıcı seçimi: B — Yakın dövüş silaha geçişle; skills ayrı düğmeler; dodge ayrı tuş.**

- A [seçilmedi]: Ayrı yakın dövüş + 1–2 skill düğmesi, dodge hareket analoğundan hareketle.
- B [SEÇİLDİ]: Yakın dövüş silaha geçişle; skills ayrı düğmeler; dodge ayrı tuş.
- C [seçilmedi]: Eylemler bağlama duyarlı tek tuş üzerinden birleştirilir.

### A-011 — Başlangıç karakterleri ve becerileri

**Bağlam:** Karakterler benzersiz; her birinin sabit yakın dövüş ve skill seti vardır, esnek görev paylaşımı hedeflenir.  
**Kullanıcı seçimi: A — İlk sürümde 4 farklı karakter; her biri belirgin ama esnek rol.**

- A [SEÇİLDİ]: İlk sürümde 4 farklı karakter; her biri belirgin ama esnek rol.
- B [seçilmedi]: İlk sürümde 2 karakter, sonra 4’e çıkar.
- C [seçilmedi]: Her çağla yeni karakterler açılır (session içi seçim).

### A-012 — Hasar, can ve iyileşme kaynakları

**Bağlam:** İyileşme tesisi serbest kurulacak, can drop’u var; iyileşmenin ana ekonomi bağını seçelim.  
**Kullanıcı seçimi: C — İyileşme hem tesiste hem üretilmiş taşınabilir sağlık kitleriyle yapılır.**

- A [seçilmedi]: İyileşme tesisi fiziksel sarf malzemesi tüketir; can drop ücretsizdir.
- B [seçilmedi]: İyileşme tesisi kurulduktan sonra süreyle ücretsiz iyileştirir.
- C [SEÇİLDİ]: İyileşme hem tesiste hem üretilmiş taşınabilir sağlık kitleriyle yapılır.

### A-013 — Mühimmat doldurma ayrıntısı

**Bağlam:** Mühimmat üretilir/taşınır; şarjör ve yedek stok nasıl çalışsın?  
**Kullanıcı seçimi: A — Şarjör + envanterde yedek mühimmat, tek tuşla doldurma.**

- A [SEÇİLDİ]: Şarjör + envanterde yedek mühimmat, tek tuşla doldurma.
- B [seçilmedi]: Her şarjör fiziksel ayrı eşya; atölyede doldurulur.
- C [seçilmedi]: Silah yalnız envanterde uygun mühimmat varsa otomatik yeniden doldurulur.

### A-014 — Tam ölen takım arkadaşının geri getirilmesi

**Bağlam:** Otomatik respawn yok. Tek kişi için ölüm checkpoint; multiplayer’da özel kurtarma prosedürü açık.  
**Kullanıcı seçimi: A — Ölen oyuncunun bedeni/işareti üsse taşınır; iyileştirme tesisinde canlandırılır.**

- A [SEÇİLDİ]: Ölen oyuncunun bedeni/işareti üsse taşınır; iyileştirme tesisinde canlandırılır.
- B [seçilmedi]: Ekip arkadaşları kaynak harcayarak cesedin bulunduğu yerde canlandırır.
- C [seçilmedi]: Bir sonraki checkpoint’te takımın işlemiyle canlandırılabilir.

### A-015 — Checkpoint ve geçici kayıt içeriği

**Bağlam:** Kayıt yapı/üretim/envanter, oyuncu durumları, dünya varyasyonu ve düşman RNG içeriyor mu?  
**Kullanıcı seçimi: A — Tam dünya snapshot; değişken harita, makine, stok, karakter ve RNG durumu kaydedilir.**

- A [SEÇİLDİ]: Tam dünya snapshot; değişken harita, makine, stok, karakter ve RNG durumu kaydedilir.
- B [seçilmedi]: Yalnız checkpoint’te tam snapshot, geçici kayıtta kritik özet tutulur.
- C [seçilmedi]: Checkpoint sayısal gelişimi saklar; inşa durumu yeniden üretilir.

### A-016 — Oylama sistemi kuralları

**Bağlam:** Yenilgi sonrası devam/sıfırdan başlama kararı oylamayla alınacak; eşit oy ve devamsız oyuncu belirsiz.  
**Kullanıcı seçimi: A — Çoğunluk; eşitlikte checkpoint’e devam; çevrimdışı oyuncu oy kullanmaz.**

- A [SEÇİLDİ]: Çoğunluk; eşitlikte checkpoint’e devam; çevrimdışı oyuncu oy kullanmaz.
- B [seçilmedi]: Oybirliği gerekir, bir kişi engellerse checkpoint seçilir.
- C [seçilmedi]: Session sahibinin son karar hakkı vardır.

### A-017 — Checkpoint tekrarlarında skor ve süre

**Bağlam:** Skor ve istatistiklerin geri alınan 6–8. bölümleri nasıl sayacağı rekor adaletini etkiler.  
**Kullanıcı seçimi: C — Rekor en yüksek bölüm, süre tüm oturum, istatistikler deneme bazında ayrılır.**

- A [seçilmedi]: Rekor aktif en yüksek bölüme göre; istatistikler tüm denemelerde yapılan gerçek eylemleri sayar.
- B [seçilmedi]: Rekor ve istatistikler yalnız başarılı nihai run dalına göre; kaybedilen denemeler silinir.
- C [SEÇİLDİ]: Rekor en yüksek bölüm, süre tüm oturum, istatistikler deneme bazında ayrılır.

### A-018 — İstatistik ekranı ve atıf kuralları

**Bağlam:** Oyuncu hasarı, kaynak toplama, kill, süre ve bot sayısı istendi; kulelerin hasarı hangi oyuncuya yazılacak?  
**Kullanıcı seçimi: A — Oyuncu doğrudan hasarı ayrı, kule hasarı takım/yapı ayrı.**

- A [SEÇİLDİ]: Oyuncu doğrudan hasarı ayrı, kule hasarı takım/yapı ayrı.
- B [seçilmedi]: Kule hasarı onu kuran oyuncuya da eklenir.
- C [seçilmedi]: Kule hasarı son bakım/upgrade yapan oyuncuya eklenir.

### A-019 — Rekorun doğrulanması ve liste tipi

**Bağlam:** Dedicated server seçildi; skorları çevrimiçi karşılaştırırken sahte session riski var.  
**Kullanıcı seçimi: A — Sunucu onaylı online leaderboard + cihaz içi oturum geçmişi.**

- A [SEÇİLDİ]: Sunucu onaylı online leaderboard + cihaz içi oturum geçmişi.
- B [seçilmedi]: Yalnız kişisel/arkadaşlara açık rekor geçmişi.
- C [seçilmedi]: Çevrimiçi sıralama hiç yok, sadece oyun sonu raporu.

### A-020 — Ödül düşme sıklığı ve geçici bonuslar

**Bağlam:** Can, hız, silah ve fiziksel kaynak düşecek; buff kalıcı değil, şansa bağlı.  
**Kullanıcı seçimi: A — Belirli düşük ihtimaller; güçlü bonuslar kısa sürer ve birikmez.**

- A [SEÇİLDİ]: Belirli düşük ihtimaller; güçlü bonuslar kısa sürer ve birikmez.
- B [seçilmedi]: Loot büyük ölçüde boss/özel düşmandan düşer.
- C [seçilmedi]: Loot her düşmanda küçük ama sürekli oranla düşer, bonuslar birikebilir.

### A-021 — Üretim girdisi ve tampon yönetimi

**Bağlam:** Makinenin çıkışı sınırlı; girdi depolama kapasitesi ve kaynak yetişmediğinde davranış belirsiz.  
**Kullanıcı seçimi: A — Her makinenin sınırlı input ve output tamponu; girdi yoksa durur.**

- A [SEÇİLDİ]: Her makinenin sınırlı input ve output tamponu; girdi yoksa durur.
- B [seçilmedi]: Sadece output kapasitesi vardır; input geldiği an tüketilir.
- C [seçilmedi]: Makine girdileri yalnız konveyör bağlantısı üzerinden kabul eder.

### A-022 — Elektrik yetersizliğinde öncelik

**Bağlam:** Şebekenin kapasitesi sınırlı, elektrik kesilince sistem hemen duruyor. Talep üretimden büyük olursa?  
**Kullanıcı seçimi: B — Şebeke aşırı yükte tamamen kapanır, oyuncu sistemi düzeltir.**

- A [seçilmedi]: Oyuncu dağıtıcıda öncelik atar; kalan yük otomatik kapanır.
- B [SEÇİLDİ]: Şebeke aşırı yükte tamamen kapanır, oyuncu sistemi düzeltir.
- C [seçilmedi]: En son bağlanan makineler devre dışı kalır.

### A-023 — Sınırsız kaynak noktalarının üretim biçimi

**Bağlam:** Birkaç temel kaynak tükenmiyor. Sonsuz kaynak otomasyon kurulduğunda oyunun ekonomisini bozmasın.  
**Kullanıcı seçimi: A — Sabit düşük üretim debisi; daha çok verim için farklı kaynak noktaları bulunur.**

- A [SEÇİLDİ]: Sabit düşük üretim debisi; daha çok verim için farklı kaynak noktaları bulunur.
- B [seçilmedi]: Sınırsız elle kazı, hız oyuncuya/makineye bağlı.
- C [seçilmedi]: Sınırsız kaynak yalnız ana harita köşelerinde; uzun ve tehlikeli lojistik.

### A-024 — Haritaların biyom/tema dağılımı

**Bağlam:** 3 ana harita ve kontrollü varyasyon seçildi; görsel çeşit ve mekanik etkilerini belirlemeliyiz.  
**Kullanıcı seçimi: A — Orman, kanyon/dağ, bataklık gibi üç zıt biyom.**

- A [SEÇİLDİ]: Orman, kanyon/dağ, bataklık gibi üç zıt biyom.
- B [seçilmedi]: Üçü aynı biyomun farklı topografyaları.
- C [seçilmedi]: Biyomlar çağlara göre değişir; başlangıç haritaları benzer.

### A-025 — Ana yapı başlangıç noktasını kim seçer?

**Bağlam:** Haritada birden fazla hazırlanmış başlangıç yeri var; seçim rastgele mi olacak?  
**Kullanıcı seçimi: C — Harita seçimi sırasında lider başlangıç yerini seçer.**

- A [seçilmedi]: Oturum açarken rastgele belirlenir.
- B [seçilmedi]: Takım oylamayla seçer.
- C [SEÇİLDİ]: Harita seçimi sırasında lider başlangıç yerini seçer.

### A-026 — Harita varyasyonlarının erişilebilirlik güvencesi

**Bağlam:** Değişen köprü/geçit kaynak erişimini ve düşman yollarını kapatabilir.  
**Kullanıcı seçimi: A — Önceden onaylanmış varyasyon kombinasyonları + erişim kontrolleri.**

- A [SEÇİLDİ]: Önceden onaylanmış varyasyon kombinasyonları + erişim kontrolleri.
- B [seçilmedi]: Procedural varyasyon sonrası dinamik yol erişim testi.
- C [seçilmedi]: Harita varyasyonu kaynak/engel konumuyla sınırlansın, köprüler sabit olsun.

### A-027 — Yapı ve hat inşası için saldırı kısıtları

**Bağlam:** Oyuncu düşmanın üzerine duvar kurup saldırıyı durdurabilir mi? İnşaat süresi belli ama konumsal kısıt açık.  
**Kullanıcı seçimi: A — Düşman/oyuncu işgal ettiği alana inşa engeli, yakındaki saldırıdan zarar.**

- A [SEÇİLDİ]: Düşman/oyuncu işgal ettiği alana inşa engeli, yakındaki saldırıdan zarar.
- B [seçilmedi]: Savaş içinde her yerde inşa serbest; yapı süreyle tamamlanır.
- C [seçilmedi]: Ana saldırı sırasında yalnız tamir ve hafif barikat kurulabilir.

### A-028 — Onarım maliyeti ve inşa geri kazanım oranı

**Bağlam:** Onarım manuel/otomatik; kaynak türü, zaman ve kısmi söküm oranları yok.  
**Kullanıcı seçimi: A — Hasara oranlı kaynak ve süre; sökümde sabit yüzde geri kazanım.**

- A [SEÇİLDİ]: Hasara oranlı kaynak ve süre; sökümde sabit yüzde geri kazanım.
- B [seçilmedi]: Yapı türüne göre özel tarif ve geri kazanım tablosu.
- C [seçilmedi]: Söküm kaybı hasar durumuna göre değişir.

### A-029 — Silah ve yakın dövüş dengesi

**Bağlam:** Mühimmat kıt; yakın dövüş zorunlu yedek. Ustalık ve risk/ödül eğrisi açık.  
**Kullanıcı seçimi: A — Yakın dövüş yüksek risk/yüksek etki, mermi az; karakter sınıfları farklılaşır.**

- A [SEÇİLDİ]: Yakın dövüş yüksek risk/yüksek etki, mermi az; karakter sınıfları farklılaşır.
- B [seçilmedi]: Yakın dövüş güvenli ama düşük hasarlı yedek.
- C [seçilmedi]: Yakın dövüş yalnız kaynak toplama/son çare; ateşli silahlar ana hasar.

### A-030 — Bossların çok aşamalı savaşı

**Bağlam:** Her 10 bölümde boss; tema aynı ama karşılaşma birebir sabit değil.  
**Kullanıcı seçimi: A — Bossun sabit çekirdek hareket seti + rastgele seçilen ikinci faz/yardımcı düşmanlar.**

- A [SEÇİLDİ]: Bossun sabit çekirdek hareket seti + rastgele seçilen ikinci faz/yardımcı düşmanlar.
- B [seçilmedi]: Boss davranışı bütünüyle öğrenilebilir; yalnız spawn zamanları farklı.
- C [seçilmedi]: Bossun hedef ve saldırıları oyuncu savunmasına daha adaptif tepki verir.

### A-031 — Sonradan katılanın karakter seçimi

**Bağlam:** Karakterler takımda tekrar seçilemez. Geç katılan için boş karakterler arasından seçme ve ölüm/ayrılma durumları açık.  
**Kullanıcı seçimi: A — Aktif/geri dönme hakkı olan karakterler rezerve; yeni oyuncu boş karakter seçer.**

- A [SEÇİLDİ]: Aktif/geri dönme hakkı olan karakterler rezerve; yeni oyuncu boş karakter seçer.
- B [seçilmedi]: Çıkış yapanın karakteri hemen boşa çıkar; geri gelen başka karakter seçebilir.
- C [seçilmedi]: Karakter, session boyunca belirli hesaba bağlı kalır.

### A-032 — Çevrimdışı oyuncunun envanteri

**Bağlam:** Dedicated server session’ı devam ediyor; ayrılan oyuncunun kaynakları ve ekipmanı ne olacak?  
**Kullanıcı seçimi: C — Karakter yok olur, geri döndüğünde aynı ekipmanıyla doğar.**

- A [seçilmedi]: Karakter ve eşyalar güvenli konumda kalır, dışarıdaki envanter kilitlenir.
- B [seçilmedi]: Oyuncu ayrılırken envanterini takım deposuna bırakır.
- C [SEÇİLDİ]: Karakter yok olur, geri döndüğünde aynı ekipmanıyla doğar.

### A-033 — Ortak kaynağın suistimal edilmesi

**Bağlam:** Herkes malzemeleri kullanabilir; yanlış harcama ve kasıtlı sabotaj sosyal sürtüşme yaratabilir.  
**Kullanıcı seçimi: C — Herkes her şeyi harcayabilir, geçmiş/izin sistemi hiç yok.**

- A [seçilmedi]: Harcama serbest, işlem geçmişi gösterilir; oylama yalnız kritik kararlarda.
- B [seçilmedi]: Büyük harcamalar için takım oylaması.
- C [SEÇİLDİ]: Herkes her şeyi harcayabilir, geçmiş/izin sistemi hiç yok.

### A-034 — Ekipman/üretim katkısı istatistikleri

**Bağlam:** Oyun sonu yalnız hasar/kill/kaynak değil, üretim ve tamir rolünü de adil göstermeli mi?  
**Kullanıcı seçimi: A — Hasar + kill + kaynak + tamir + üretim katkısı; takım toplamları.**

- A [SEÇİLDİ]: Hasar + kill + kaynak + tamir + üretim katkısı; takım toplamları.
- B [seçilmedi]: Sadece istenen temel hasar/kill/kaynak/süre; ek metrik yok.
- C [seçilmedi]: Detaylı kişi bazlı üretim, lojistik, savunma, revive, inşa ayrıntıları.

### A-035 — Oturumu isteyerek bitirme

**Bağlam:** Oyun saatlerce sürebilir; checkpoint’ten devam var, liderlik hedefi var.  
**Kullanıcı seçimi: C — Final yok, rekor sonsuza kadar sürer; yalnız yenilgi/manuel bırakma vardır.**

- A [seçilmedi]: Oyuncular istediği an ara verir; session ancak tüm takım kapatır veya yeni run açarsa sona erer.
- B [seçilmedi]: Belirli bölümde gönüllü final ve kazanç raporu olur; ardından devam seçilebilir.
- C [SEÇİLDİ]: Final yok, rekor sonsuza kadar sürer; yalnız yenilgi/manuel bırakma vardır.

### A-036 — Mobil inşa arayüzü

**Bağlam:** Büyük haritada Smart Snap ve fiziksel lojistik çizimi için hızlı dokunmatik arayüz gerekir.  
**Kullanıcı seçimi: B — Parmakla sürükleme, uzun basma ve hızlı yerleştirme.**

- A [seçilmedi]: İnşa menüsü → hayalet önizleme → döndür/hizala → onayla.
- B [SEÇİLDİ]: Parmakla sürükleme, uzun basma ve hızlı yerleştirme.
- C [seçilmedi]: Tam ekran strateji/inşa moduna geçiş.

### A-037 — Kamera ve harita farkındalığı

**Bağlam:** Sabit açılı 2D, zoom, 60–90 saniyelik uzaklık var; mini harita ve işaretleyici gerekip gerekmediğini belirlemeliyiz.  
**Kullanıcı seçimi: A — Kamera karakteri takip eder; zoom ve basit minimap vardır.**

- A [SEÇİLDİ]: Kamera karakteri takip eder; zoom ve basit minimap vardır.
- B [seçilmedi]: Kamera karakteri takip eder; minimap yok, sadece yön göstergeleri.
- C [seçilmedi]: Kamera serbest pan/zoom; oyun sırasında ayrı keşif haritası vardır.

### A-038 — Dedicated server barındırma ve session ömrü

**Bağlam:** Oyuncu ayrıldığında oyun duruyor; maliyet, kaç saat/gün tutulacağı, yeniden bağlanma belirsiz.  
**Kullanıcı seçimi: A — Sunucu boşken session snapshot kaydedilir, işlem kapanır; istekte yeniden başlar.**

- A [SEÇİLDİ]: Sunucu boşken session snapshot kaydedilir, işlem kapanır; istekte yeniden başlar.
- B [seçilmedi]: Sunucu sürekli ayakta kalır, yalnız fizik simülasyonu durur.
- C [seçilmedi]: Başlangıçta tek test sunucusu, üretimde yönetilen bulut altyapısı.

### A-039 — Oynanabilir eski prototipten geçiş

**Bağlam:** GitHub’da mevcut klasik TD prototip; hedef mimari serbest gezen oyuncu, inşa ve dedicated server gerektiriyor.  
**Kullanıcı seçimi: C — Yeni repo açılır; eski repo yalnız deneme olarak kalır.**

- A [seçilmedi]: Mevcut repo içinde yeni oyun çekirdeği kurulur; işe yarar kod/çizim/testler seçilerek taşınır.
- B [seçilmedi]: Eski prototipten adım adım refactor ile tüm sistemi dönüştür.
- C [SEÇİLDİ]: Yeni repo açılır; eski repo yalnız deneme olarak kalır.

### A-040 — Performans hedefleri ve otomasyon sınırları

**Bağlam:** Android’de 4 oyuncu, AI, üretim ve çok sayıda yapı aynı anda çalışacak.  
**Kullanıcı seçimi: A — Önce hedef cihaz sınıfı ve fps, ardından entity/üretim sınırı testle belirlensin.**

- A [SEÇİLDİ]: Önce hedef cihaz sınıfı ve fps, ardından entity/üretim sınırı testle belirlensin.
- B [seçilmedi]: Sabit düşük makine/düşman limitleri konulsun.
- C [seçilmedi]: Limit koymadan optimize ederek ilerle.

### A-041 — Özel düşmanların yapı hedefleme bilgisi

**Bağlam:** Sabotajcı her fabrikayı uzak mesafeden otomatik biliyor mu, yoksa algı mı gerekiyor?  
**Kullanıcı seçimi: A — Yalnız keşif/algılama veya tasarlanmış baskın bilgisine göre hedef seçerler.**

- A [SEÇİLDİ]: Yalnız keşif/algılama veya tasarlanmış baskın bilgisine göre hedef seçerler.
- B [seçilmedi]: İlgili türler haritadaki üretim binalarının yerini daima bilir.
- C [seçilmedi]: Gürültü/ısı/enerji kullanımı gibi üretim izlerine yönelirler.

### A-042 — Bot takım arkadaşı seçeneği

**Bağlam:** Solo oyuncu da oynayabilir, botlar önce opsiyonel fikir olarak konuşuldu; düşman/zorluk scaling olmamalı.  
**Kullanıcı seçimi: A — İlk sürümde oyuncu botu yok, ileride eklenebilir.**

- A [SEÇİLDİ]: İlk sürümde oyuncu botu yok, ileride eklenebilir.
- B [seçilmedi]: İlk sürümde isteğe bağlı basit yardımcı bot.
- C [seçilmedi]: Tek kişilikte çok oyunculu gibi 1–3 botla tam takım kurulabilir.

## Kullanıcı tarafından asistanın kararına bırakılan 16 R-çözümü

### R-001 — Checkpoint tekrar RNG modeli

**Karar:** Ara verme kaydı harita, düşman ve RNG durumunu aynen sürdürür. Yenilgi sonrası checkpoint geri yüklemesi sabit map/boss kimliğini korur, yalnız sonraki çatışma varyasyonları için attempt_index temelli yeni alt tohum üretir.

**Dayanak:** T1 / A-015 / A-030

### R-002 — Takım canlanması ve klinik

**Karar:** Takımdan en az bir aktif oyuncu hayattaysa ölen üye, aktif oyun süresine bağlı bir bekleme sonunda tekrar doğar. Çalışır durumdaki klinik süreyi kısaltır; klinik hiç yoksa daha uzun beklenir. Oyuncu tamamen ölmeden önce sürünerek yardım arayabilir. Tek oyuncunun tam ölümü checkpoint tetikler.

**Dayanak:** T2 / D-01.19–21 / A-014; son kullanıcı talebi

### R-003 — Altıncı çağdan sonra sonsuz oyun

**Karar:** Altı dönem sırasıyla 1–20 Taş, 21–40 Tunç/Demir, 41–60 Orta Çağ, 61–80 Sanayi, 81–100 Modern, 101–120 İleri/Kıyamet Sonrası. 121+ yeni çağ açılmaz; boss/elite/AI baskısı ve sayısal zorluk ölçeklenir, 20 bölümlük üst kademe döngüleri devam eder.

**Dayanak:** T3 / A-006 / D-02.23 / A-035

### R-004 — Lobby lideri ve server otoritesi

**Karar:** Dedicated server oyun durumunun tek otoritesidir. Lobby lideri ilk katılan yetkili oyuncudur; ayrılırsa aktifler arasından katılım sırasına göre atanır. Lider sadece harita/başlangıç noktasını başlatma öncesi belirler; ortak kaynak üzerinde veto hakkı yoktur.

**Dayanak:** T4 / D-01.25 / A-025 / A-033

### R-005 — Session kadro kilidi

**Karar:** Bir session en fazla dört BENZERSİZ oyuncu kimliği kaydeder. Boş yerler ilk dört kimlik dolana kadar doldurulabilir; kayıtlı kişi ayrılsa da koltuğu ona ait kalır, beşinci kimlik katılamaz. İlk dört oyuncunun tümü ayrıldığında da yalnız aynı kimlikler geri gelebilir. Yeni session tüm kayıtları sıfırlar.

**Dayanak:** T5 / A-031 / D-01.24; son kullanıcı talebi

### R-006 — Şebeke kilitlenmesini önleme

**Karar:** Şebekeye yük ekleme ya da bağlı makineyi elle kapatma elektrik gerektirmez. Aşırı yükte ağ tamamen kapanır; talep üretim kapasitesinin altına düşünce otomatik tekrar devreye girer. Başlangıç/güvenli kurtarma için manuel yakıtlı üretim ayrı çalışabilir.

**Dayanak:** T6 / A-022 / D-02.15

### R-007 — Sonsuz mod için kaynak güvencesi

**Karar:** Her teknolojik çağda asgari yaşayabilir savunma/mühimmat/onarım zinciri yalnız yenilenebilir temel kaynaklar veya tekrar elde edilebilen ürünlerle sürdürülebilir. Tükenebilir nadir kaynaklar avantaj, performans ve seçenek sağlar; zorunlu soft-lock yaratamaz.

**Dayanak:** T7 / D-01.11 / A-023

### R-008 — Ortak kaynak kullanım yetkisi

**Karar:** Tüm kimliği doğrulanmış aktif takım üyeleri ortak fiziksel malzemeyi izin onayı olmadan kullanabilir. Harcama etkisi server tarafından atomik doğrulanır; kullanıcıya işlem geçmişi, veto veya kişisel para sistemi eklenmez.

**Dayanak:** T8 / A-033 / D-01.13

### R-009 — Rekor sayımı ve oyuncu varlığı

**Karar:** 1–4 kişilik sınıflandırma, aynı anda aktif ve oyunu kontrol eden doğrulanmış benzersiz oyuncu sayısının tepesine göre yapılır. Salt bağlanıp hiç oynamayan kişi rekor oyuncusu sayılmaz; test için asgari 30 sn oyun katılımı veya bir aktif bölüm geçişine iştirak koşulu kullanılır. Süre ve tekrar denemeler ayrıca kaydedilir.

**Dayanak:** T9 / D-01.27 / A-017

### R-010 — Sunucu kapanma ve geri yükleme

**Karar:** Son üye ayrıldığında snapshot atomik yazılır, bellek boşaltılır ve o session server işlemi kapanabilir. Aynı session için eşzamanlı resume isteklerinde tek kilit/tek server otoritesi vardır. Kayıt versiyonu, bütünlük kontrolü ve son geçerli snapshot rollback gerekir.

**Dayanak:** T10 / A-038 / D-01.26

### R-011 — Binaların görünümü

**Karar:** İlk prototipte iyileşme, üretim ve depolar açık alandaki yapılardır; saydam çatıya veya ayrı iç mekân sahnesine gerek yoktur. İleri tarihte dekoratif çatı seçilebilir.

**Dayanak:** T11 / A-002

### R-012 — Mobil kontrol çakışmaları

**Karar:** Twin-stick dokunma alanları inşa sürükleme ve HUD düğmelerinden ayrılır. Yerleştirme modundayken sağ joystick alanı yapı yerleştirme sayılmaz. 16:9 ve dar/uzun ekranlarda touch hedefleri prototipte test edilir.

**Dayanak:** T12 / A-010 / A-036 / A-037

### R-013 — Yenilgi ve oylama uygulama

**Karar:** Yenilgide çevrimiçi oyuncular çoğunlukla checkpoint veya sıfırdan başlatmayı seçer; eşitlikte checkpoint seçilir. Çevrimdışı üyeler oya dahil edilmez; solo doğrudan seçer.

**Dayanak:** A-016 / D-01.22

### R-014 — Aylak/süreli canlandırma davranışı

**Karar:** Canlanma bekleme süresi yalnız en az bir takım üyesi hayattayken oyun zamanı ilerlediğinde azalır; boş server duraklamasında işlemez. Çalışan klinik olup olmaması doğma zamanını etkiler. İyileşme tesisi yarım kalmış/hasarlıysa hızlandırma uygulamaz.

**Dayanak:** R-002 / D-01.26

### R-015 — Oyuncu slotu ve karakter rezervasyonu

**Karar:** Benzersiz dört oyuncu kimliği ve benzersiz karakter seçimi ayrı kurallardır. Bağlantısı kopan karakter yok olur, slot ve eşyaları korunur; geri döndüğünde aynı karakter/eşya ile başlar.

**Dayanak:** R-005 / A-031 / A-032

### R-016 — Prototip yaklaşımı

**Karar:** Tam ürün değil; P0 dikey kesit bir harita varyasyonu, tek yerel oyuncu, dört basit sınıf tanımı ve örnek üretim/savunma/ölüm/otomasyon akışlarını oynanabilir gösterir. Dedicated multiplayer, üretim kapasitesi ve 6 çağın tam içerikleri P1+ ayrı test edilmelidir.

**Dayanak:** Kullanıcının işlev testli, basit karakterli prototip isteği

**Not:** Bu liste seçilmeyen alternatifleri de tarihçe olarak korur; seçenekleri kodlama şartı olarak yorumlama. Güncel kaynak gerçeği en son kullanıcı talimatıdır.
