# CODEX TASK — MAYHEM / MAIN MENU & SCREEN FLOW v1.0

**Repo:** `ErtugrulGurler/Mayhem`  
**Başlangıç:** güncel `main` (başlamadan `git fetch`, branch durumunu incele)  
**Yeni dal:** `feature/main-menu-visual-identity-v1` (isim çakışırsa yeni uygun ad seç)  
**Hedef:** Godot **4.7.2 stable**, GDScript, Compatibility renderer, **Android yatay**; masaüstü editörde de çalışmalı.  
**Çıktı:** commit/push, `main` hedefli PR, test kanıtları; **PR'ı merge etme**.

## 0. Tasarımın otoritesi ve kaynaklar

Önce mevcut repoyu **incele**, tahmin yürütme. Şunları oku: `project.godot`, `README.md`, `prototype/session.gd`, `prototype/presentation/hud.gd`, `prototype/core/catalog.gd`, `prototype/systems/save*` ve ilgili tüm kayıt/test kaynakları; ayrıca `docs/DESIGN_V0_4.md`, `docs/REQUIREMENTS_V0_1.md` ve repoda varsa daha güncel izlenebilir gereksinimler. Eski sabit-yollu Tower Defense için yazılmış `GAME_REQUIREMENTS.md` **yeni Mayhem'in kaynağı değildir**.

Bu göreve eklenmiş **`MAYHEM_UI_THEME_REFERENCE.png` görselini** ana **görsel dil referansı** olarak kullan. PNG, **tam ekran arka plan resmi veya Godot'a doğrudan gömülecek işlevsel UI değildir**; çerçeve, renk, tipografi, boşluk, panel hiyerarşisi, düğme ve ikon ruhunu gösteren *concept art*tır. Menü kontrollerini Godot `Control` ve sahne elemanlarıyla gerçek, tıklanabilir bileşenler halinde uygula. Görseldeki her sayı, ekonomi, silah, HUD yerleşimi veya kamera açısı gereksinim sayılmaz. Görselde bulunabilecek seviye/para/XP göstergelerini oyuna ekleme.

**Son kullanıcı kararı:** Hacimli, sıcak, okunabilir çizgi film görselliği; giriş ekranının merkezinde savunulan **Merkez/teknolojik çekirdek**; temayla uyumlu tüm menüler; **Çıkış/Quit düğmesi yok**. Dört mevcut karakteri şimdilik basit ama seçilebilir ve farklı silüetli tut. 2.5D tam oyun dünyası ve ayrıntılı karakter sanatı **ayrı geliştirme aşaması**. Bu PR'da oyun mekaniğini sıfırdan yazma.

## 1. Beklenen kullanıcı deneyimi ve ana ekran kompozisyonu

Uygulama açılınca eski yeşil oyun haritası üzerinde açılan HUD paneli **yerine ayrı bir gerçek ana menü sahnesi** gelir. İlk anda oyun simülasyonu/dalgalar/üretim ilerlemez; kullanılmayan gameplay input'u menüde aktif olmaz.

**Landscape ana ekranın kompozisyonu:**
- **Üstte** tanınabilir, büyük `MAYHEM` logotype, altında küçük slogan: `Topla. İnşa et. Üret. Savun.`
- **Ortada** belirgin 2.5D hacim hissi veren **Merkez**: kalın geometrili, taş + ahşap + metal parçaları ve yumuşak sıcak turuncu aydınlatması olan bir **teknolojik savunma çekirdeği**. Temel tasarımdaki merkez **yalnız savunulacak HP hedefidir**; büyü, bedava üretim/iyileşme, mana veya portal işlevi varmış gibi gösterme. Aşırı fütüristik mavi büyü kulesi zorunlu değil; ilk çağla uyumlu ve çağlarla evrilebilir bir tasarım kullan.
- **Çevrede** hafif katmanlı orman/tepeler, taşlar, kontrollü sis/atmosfer, düşük maliyetli yavaş hareket eden yaprak, duman ve ışık parçacıkları. Hafif kamera/parallax veya çizim katmanlaması olabilir, fakat 3D motoruna geçiş ve oyunun tamamını yeniden modelleme yok.
- **Logo/çekirdek/menu dengesi:** çekirdek her zaman büyük ve net görünür; butonlar onu örtmez. Yeterli alan varsa menü, görseli bastırmayacak sol veya sağ taraftaki dikey panelde; dar landscape ekranlarda responsive olarak yeniden hizalanır. Dokunma alanları ve güvenli ekran kenarları korunur.
- Seçili düğme hafif büyüme/parlama; dokununca kısa geri bildirim; çekirdeğe dokunmak hafif ışık tepkisi versin ama gizli/yanıltıcı fonksiyon oluşturmasın. Düşük güçlü telefonda efektler azaltılabilsin.

**Renk/stil:** orman koyu yeşili, açık krem yazılar/yüzeyler, sıcak altın/turuncu vurgu, yumuşak gölgeler, yuvarlatılmış dikdörtgen düğmeler, kalın fakat okunaklı silüetler. Çizgi film hacmi: yan yüzey çizimleri, düzgün örtüşme, vurgulayıcı aydınlatma ve zemin temas gölgeleri; *pixel art değil*. Lisans sorunu doğuracak üçüncü taraf sprite/font indirme zorunlu olmasın; mümkün olduğunca Godot bileşenleriyle üret ve dış asset gerekiyorsa kaynağını/lisansını açıkla. Referans resimdeki ayrıntıları birebir kopyalayıp tek görseli arka plana yapıştırma.

## 2. Ana menü — işlevsel düğmeler

1. **Yeni Oyun** (birincil, en görünür): yeni session kurulum akışına geçer; doğrudan oyunu başlatmaz.
2. **Devam Et:** **yalnız geçerli `suspend`/ara verme kaydı** varsa etkin. Tıklanınca aynı dünya/oyuncu/üretim/seed/tutorial durumundan devam eder. Kayıt yoksa **disabled**, kısa açıklama `Devam edilecek kayıt yok`; düşülen checkpoint'i yanlışlıkla devam sayma. Bozuk kayıt kullanıcıya anlaşılır hata gösterir, kilitlenmez.
3. **Arkadaşlarla Oyna:** gerçek network/dedicated server yoksa **disabled + `Geliştiriliyor`** açıklaması. Sahte multiplayer menüsü veya çalışan olmayan lobby açma. Gelecek 1–4 kişi ve session slot rezervasyonu tasarımı korunur.
4. **İstatistikler:** var olan kayıtlı gerçek oturum/oyun sonu verilerini göster; veri yoksa `Henüz kayıtlı istatistik yok` yaz. Rastgele/uçuk demo değer üretme. Oyuncu hasarı ile kule hasarını ayır, rekoru sahte leaderboard'a dönüştürme. Var olan istatistik sistemini yeniden kullan; kalıcı geçmiş yoksa küçük ve güvenli ayrı geçmiş kaydı oluşturabilirsin, kapsamı açıkça belirt.
5. **Ayarlar:** çalışır işlevli kontrol ve görüntü seçenekleri (bkz. bölüm 5). Gerçek ses altyapısı yoksa çalışan ses ayarı varmış gibi gösterme; gerekirse yalnız uygulanabilenleri sun.

**Kesinlikle `Çıkış`, `Quit`, `Exit` düğmesi ekleme.** Eski `Eski kule savunması demosu` seçeneğini ana menüden kaldır; eski demo Git geçmişi veya geliştirici alanından erişilebilir olabilir. **Ana menüye `Bölüm Seç` ekleme:** checkpoint sonsuz dalga sistemini atlamak için serbest seçilebilir bölüm değildir. Debug atlatmaları yalnız geliştirici panelinde kalır.

## 3. Yeni oyun akışı — ekranlar ve davranışlar

Önerilen basit, tutarlı akış:
`Ana Menü → Yeni Oyun / Mod → Karakter Seçimi → Harita & Merkez Konumu → Özet/Onay → Oyun`.
Her ekranın **Geri** kontrolü ve Android geri jesti/fiziksel Back davranışı olmalı; seçimler geri/ileri gezinirken korunmalı, `Başlat` öncesi simülasyon veya kayıt mutasyona uğramamalı.

### 3.1 Mod seçimi
- `Tek Oyunculu` **aktif**, mevcut P0 mekaniğine bağlanır.
- `Çok Oyunculu (Geliştiriliyor)` **disabled**; mevcut kodun desteklemediği online katılımı taklit etme.
- Mod seçimi ayrı ekrana gereksiz sayıda dokunuş yaratıyorsa `Yeni Oyun` sayfasının ilk bölümüne göm; **en kısa anlaşılır akışı tercih et**.

### 3.2 Karakter seçimi
- Mevcut katalogdaki **Ada / Muhafız, Bora / İzci, Cem / Usta, Duru / Sıhhiyeci** kimliklerini ve şu an uygulanan HP/hız/melee/skill verilerini kullan. İsimleri veya oyun mekaniğini onaysız değiştirme.
- Dört büyük, tıklanabilir kart: **karakter adı + benzersiz renk/silüet + 1 satırlık oyun tarzı + mevcut özel yetenek simgesi/metni**. Büyük portreler sade placeholder olabilir; karmaşık karakter animasyonu/sprite üretimi bu PR'da şart değil.
- Seçim net görünür; `Devam` yalnız bir kart seçiliyken çalışır. İstersen ilk karakteri varsayılan seçebilirsin fakat seçim açıkça görünmeli.
- Yeni oyun dışında kalıcı karakter seviyesi, XP, para, unlocked skin üretme. Aynı karakter 4 kişilik gerçek co-op'ta tekrar seçilmeyecek; P0 tek oyunculu olduğu için online kilit simülasyonu yapma.

### 3.3 Harita / Merkez / Varyasyon
- **Mevcut tek uygulanmış orman/çayır haritası** aktif önizlemeyle gösterilsin. 3 ayrı harita hedefi gelecek kapsam; gerçekte bulunmayan haritalar **Geliştiriliyor / Kilitli** veya hiç listelenmesin.
- Mevcut iki merkez başlangıç konumu (batı/doğu) ve iki kontrollü varyasyon (A/B) kullanılabilir. Seçenekler temel dünya erişimini bozmamalı. Harita kartında oyun tarzı, küçük önizleme ve konum özetine yer ver; denge değerlerini hayali kesinlikte yazma.
- Merkez konumu oyuncunun kurduğu hazır üs veya bonus fabrikalar anlamına gelmez. **Yeni session merkez dışında savunma tesisi/duvar/fabrika olmadan başlar.**

### 3.4 Başlatma özeti ve çakışan kayıt
- Özet: `Tek Oyuncu · seçilen karakter · harita · merkez konumu · varyasyon`; `Başlat` butonu.
- Geçerli ara verme kaydı varken **Yeni Oyun** başlatılırsa, **eski ara verme kaydının üzerine yazılacağı açık bir onay** göster: `Eski oturumu silip yeni oyun başlat` / `İptal`. Onaysız eski kaydı silme.
- Gerçek yeni oyun, eski oyunun geliştirme ve item durumunu devralmaz. Başlangıç envanteri/güçleri mevcut katalog ve tasarım kararlarına göre oluşur. Tutorial ilk seferde gözükür.
- Başarılı sahne yüklemesi sonrasında HUD açılır, menü kapanır, input kontrolü oyuna devredilir.

## 4. Pause, geri dönüş, yenilgi ve oturum doğruluğu

- Oyun içindeki **Menü/Pause** ekranı aynı görsel temayı kullansın: `Oyuna Dön`, `Kaydet ve Ana Menü`, `Ayarlar`, `Kontroller`, `Rehberi Göster`. İsteğe bağlı aynı ekranda gerçek çalışan zoom.
- **Pause sırasında** yerel oyun zamanı, dalgalar, üretim, düşmanlar ve cooldown'lar ilerlemesin; zaten kayıt/menü sırasında donması gereken durumlar bozulmasın. Menüler açıkken analog ve silah input'ları dünyaya taşınmasın.
- `Kaydet ve Ana Menü`: önce tam `suspend` snapshot yaz; **kaydetme başarısızsa dünyadan çıkma**. Başarılı olursa ana menüye dön ve `Devam Et` etkinleşsin. `Ana Menü`ye kayıtsız çıkışı birincil/yaygın aksiyon yapma.
- `Devam Et` mevcut `user://suspend.bin` snapshot sözleşmesini ve RNG/world state'i korumalı, dosya geçerliliğini kontrol etmeli. Kaydedilmiş eski P0 dünyasını yeni UI sebebiyle sessizce sıfırlama.
- **Checkpoint** ayrı veri ve ayrı semantik: her 5 bölüm; yenilgiden sonra checkpoint'e dönme ile ara vermeden tam devam etme birbirine karışmaz. Yenilgi ekranı `Checkpoint'ten tekrar dene`, `Yeni Oyun`, `Ana Menü` seçeneklerini bağlama uygun ve gerekli onaylarla verir. Solo tam ölüm checkpoint kuralı değişmez.
- `Android Back`: modal açıkken modalı kapat; seçim ekranında geri git; oyun içinde pause aç; ana menüde oyundan çıkmaya çalışan ayrı bir Çıkış menüsü açma.

## 5. Ayarlar, erişilebilirlik ve teknik UI mimarisi

- Menü/sahne geçişleri için gerçek modüler sahneler öner: örn. `res://ui/main_menu.tscn`, `res://ui/character_select.tscn`, `res://ui/new_game_setup.tscn`, `res://ui/settings.tscn`; ortak Theme/StyleBox/renk/düğme bileşenleri tekrar kullanılabilsin. Kodun gerçek repo yapısına göre isimleri düzenleyebilirsin. **Eski `prototype/session.gd` komutlarını mümkün olduğunca koru, UI'den güvenli servis/adaptörle çağır.** Godot `project.godot` ana sahnesini yeni menüye çevir.
- **Ayarlar:** uygulanabilir olan kontrol şeması yardım ekranı; UI ölçeği (`Küçük/Normal/Büyük` veya ölçek kaydırıcısı) ve efekt kalitesi (`Düşük/Normal`), tercihen gerçek çalışan kamera zoom kontrolü. Seçimlerini `user://` altında sürümlü, güvenilir ayar dosyasına kaydet ve yeniden açılışta yükle. Ses ayarı yalnız AudioServer/bus ile gerçekten işlevsel kılabiliyorsan sun.
- Mevcut `twin-stick` mobil hareket/sağ nişan+otomatik saldırı davranışını, aim assist yokluğunu, fiziksel toplama/inşa/üretim mekaniklerini, kaynakları ve düşman dengelemesini değiştirme. UI konsept görselinde üçüncü şahıs omuz kamerası gibi görünen çizimler **gerçek kamera kararı değil**: oyun 3/4 üstten sabit bakışlı serbest dolaşan aksiyon oyunu olarak kalır.
- Yerleşimde 16:9, 19.5:9 ve 20:9 yatay ekran oranlarını doğrula; örnek test viewport'ları **960×540, 1920×1080, 2400×1080**. Katlanma/çentik ve Android navigation alanlarına mümkün olduğunca saygı göster. Metinler kesilmesin; kullanıcı etkileşimi en az yaklaşık **48 dp eşdeğerine** denk düşen hedef boyutlarında olsun; `Control` anchors/containers/minimum sizes ve gerektiğinde scroll kullan. Resmi birim dönüşümünü Godot viewport scaling'e göre hesapla; sanal pixel'i otomatik fiziksel dp varsayma.
- Türkçe karakterler (`İ, ı, ğ, ş, ç, ü, ö`) doğru çıkmalı; metinler taşmamalı. Yüksek kontrast, focus/pressed/disabled halleri; fare/klavye ve dokunma erişimi. Tek ekrandaki yüksek DOM-like karmaşıklığı önle.
- Ana menü dekoratif hareketleri **pause'tan etkilenmeyecek** biçimde yönet; oyunun gameplay zamanıyla karıştırma. Uygulama belleği/düşük FPS için ağır shader/çok büyük texture/bloom zorunluluğu yok.
- UI PNG'sini düz ve tek büyük texture olarak ekrana yapıştırıp üstüne görünmez düğme yerleştirme. Esas UI native Godot bileşenlerinden oluşmalı.

## 6. Kapsam dışı ve kesin yasaklı regresyonlar

- Oyun dünyasının tamamını gerçek 3D/2.5D motor mimarisine dönüştürme; bu, ayrı PR ve risk analizi gerektirir. Yalnız menü sahnesinde hacimli çizgi film hissi verilebilir.
- Yeni düşman, makine, ekonomi, teknoloji, loot sistemi, XP, para, sihir, portal, kalıcı buff ekleme.
- 4 gerçek oyunculu multiplayer veya leaderboard çalışıyormuş gibi davranma.
- Ana yapıyı kendiliğinden üreten/iyileştiren ya da ücretsiz kaynak veren merkez yapısına dönüştürme.
- Rastgele görsel kalite artışı uğruna okuma/performansı kötüleştirme; screenshot'taki sahte değerleri gösterme.
- Eski oyuna ait linki kullanıcı ana menüsüne taşıma; Git geçmişini koru.

## 7. Kabul kriterleri — her maddeye TESTED/PARTIAL/NOT TESTED kanıtı ver

| ID | Kabul kriteri |
|---|---|
| MM-001 | İlk açılışta ayrı ana menü görünür; gameplay HUD/analoglar ve simülasyon arka planda çalışmaz. |
| MM-002 | Menünün merkezinde teknolojik çekirdek belirgin, kontrollü animasyonla 3/4 hacimli görünür. |
| MM-003 | PNG referansının koyu yeşil-krem-altın UI dili tutarlı uygulanır; gerçek native kontrol bileşenleri kullanılır. |
| MM-004 | `Yeni Oyun` kurulum akışını açar; geri işlemleri ve seçim koruması çalışır. |
| MM-005 | Dört mevcut karakter ayrı kartlarda seçilebilir; gerçekten seçilen karakter session'a geçer. |
| MM-006 | Yalnız gerçekten uygulanmış harita/merkez/varyasyonlar aktif; başlangıçta hazır duvar/fabrika yok. |
| MM-007 | Geçerli ara verme kaydı yokken `Devam Et` disabled; varsa tam kayıttan sürer. |
| MM-008 | Ara verme kaydı varken yeni oyun başlatmak açık onay gerektirir; `İptal` kaydı korur. |
| MM-009 | Multiplayer olmayan prototipte `Arkadaşlarla Oyna` disabled ve `Geliştiriliyor` bilgisi taşır. |
| MM-010 | `İstatistikler` yalnız gerçek veriyi gösterir; boş veri güvenli işlenir. |
| MM-011 | `Ayarlar` içinde sunulan seçenekler çalışır ve kalıcıdır. |
| MM-012 | `Çıkış/Quit` düğmesi ana menüde ve pause ekranında yoktur. |
| MM-013 | Pause sırasında oyun zamanı, düşmanlar ve üretim durur; input dünyaya sızmaz. |
| MM-014 | `Kaydet ve Ana Menü` hatasız kaydeder; hata varsa çıkmaz; menüden Devam kayıtlı state'i döndürür. |
| MM-015 | Yenilgi sonrası checkpoint retry ile suspend resume mantığı karışmaz. |
| MM-016 | Menü ve alt ekranlarda Android Back ve desktop klavye/fare navigation çalışır. |
| MM-017 | 960×540, 1920×1080 ve 2400×1080 boyutlarında taşma/örtüşme/tıklama sorunu yok. |
| MM-018 | Mevcut toplama, inşa, üretim, savunma, kayıt, tutorial ve test fonksiyonları bozulmaz. |
| MM-019 | Godot 4.7.2 import + startup + scene-navigation + kayıt testleri gerçek motorla çalıştırılır; başarısızlar raporlanır. |
| MM-020 | UI ekranları ve görsel değişiklikler için en az ana menü + karakter seçimi + ayarlar + oyun içi pause ekran görüntüleri/kanıtları PR'a eklenir; imkânsızsa sebebi belirtilir. |

## 8. Codex geliştirme ve teslim sırası

1. **Repo analizi:** ana sahne, mevcut menü, kayıt dosyaları, `MayhemCatalog.CHARACTERS`, tutorial, eylem router ve test altyapısını haritalandır; mevcut davranışları kısa notla kaydet.
2. **Yeni modüler ana menü ve tema:** Godot `Control` sahneleri, tema, menü arka planı/merkez animasyonu, responsive düzen.
3. **Screen flow:** karakter/harita/özet, `Devam Et` ve kayıt doğrulama, ayarlar, istatistik, pause/yenilgi, geri dönüşler. Önce çalışır işlev, sonra görsel iyileştirme.
4. **Testler:** Godot 4.7.2 stable gerçekten bulunabiliyorsa `--headless --editor --import --quit` ve repo test komutları; ayrıca menü navigasyon, dosya yok/bozuk, new-game overwrite-confirm, pause, resume, UI overflow kontrolleri. Headless yalnız görsel kalite kanıtı değildir; mümkünse screenshot al ve görüntüleri gözle incele. Android fiziksel cihazda test etmediysen bunu açıkça belirt.
5. **Dokümantasyon:** `README.md` ve `docs/` altında bu ekranların akışı ve kullanıcı testi için 5 dakikalık kontrol listesi. Her kabul ID'si için implemented/tested/partial/not-done kanıt tablosu.
6. **GitHub:** yalnız feature branch'e commit/push, PR aç, **merge etme**. PR açıklamasında ekran görüntüleri, teknik yaklaşım, başlıca riskler, test komutları ve gerçek sonuçlar olsun. Türkçe kısa teslim özeti ver.

## 9. Tamamlanmış sayılma tanımı

Ana menü güzel görünmekle sınırlı değildir. Telefonda dokunarak `Yeni Oyun → karakter → harita → başlat → pause → kaydet ve menü → devam` zinciri oynanış ve kayıt kaybı olmadan tamamlanmalıdır. Gerçekte çalışmayan düğme veya ekranı **done** işaretleme. Diğer oyun mekanikleri ve önceki testler regressionsuz kalmalı. Yeni bilgi/karar gerekiyorsa kullanıcının üst düzey tasarım kararlarına uygun makul varsayım seç; önemli varsayımları PR'da ayrı belirt, fakat gereksiz sorularla işi durdurma.