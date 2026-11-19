# MAYHEM — CODEX TEK METİN / TAM KAYIPSIZ DEVİR

**Bu belgenin tamamı Codex görevine tek seferde yapıştırılabilir.** Görev talimatından sonra 104 test edilebilir gereksinim ve bütün 120 karar kaydı yer alır. Seçilmeyen seçenekler yalnız tarihçe içindir. Kodlama/kanıt P0/P1/P2 olarak kademelenir.

---

# CODEX GÖREVİ — MAYHEM / KAYIPSIZ DEVİR / FONKSİYONEL GODOT PROTOTİPİ

**GitHub repo:** `ErtugrulGurler/Mayhem`  
**Başlangıç branch'i:** `feature/mayhem-p0-functional` (bu branch yoksa `main` üzerinden yeni feature branch aç; `main`e doğrudan commit yapma).  
**Hedef:** Godot 4.7.2 / GDScript / Compatibility, önce Android yatay ekran; basit çizimli fakat temel mekanikleri gerçekten oynanabilir **2D aksiyon + co-op üs savunması + fiziksel üretim/lojistik** prototipi.  
**Çıktı:** Commits/push + **main hedefli PR**, çalışan Godot testleri, gereksinim/test izlenebilirliği ve Android'de deneme adımları. PR'ı kullanıcı onayı olmadan merge etme.

## 1. Önce kaynakları oku. Eski oyunla karıştırma.

Repo'daki şu dosyaları **tamamıyla** oku:

1. `docs/DESIGN_V0_4.md` — geçerli tasarım özeti; **62 D-kararı + 42 cevaplanmış A-kararı + 16 R-çözümü**.
2. `docs/REQUIREMENTS_V0_1.md` — 87 gereksinim, ID, öncelik ve acceptance criteria.
3. `docs/CODEX_IMPLEMENTATION_BRIEF.md` — önceki geliştirme/test brifi.
4. Mevcut `project.godot`, sahneler ve kod; önceki prototipin ne yaptığını öğrenmek için, **yeni tasarımı tayin etmek için değil**.
5. `feature/mayhem-p0-functional` üzerinde bulunan `prototype/session_rules.gd` ve `tests/session_rules_smoke.gd`: ChatGPT'nin commitlediği **TEST EDİLMEMİŞ** ilk iki taslak. Bunları Godot'ta test et; doğruysa kullan, hatalıysa düzelt/değiştir.

**Bu göreve ayrıca iliştirildiyse** `MAYHEM_REQUIREMENTS_TRACEABLE_V0_2.md`, `MAYHEM_DECISIONS_ALL_120.md`, `MAYHEM_KARARLAR_2026-11-19.json` kaynaklarını da oku; bunları `docs/` altında versiyonlu koru. Ekler yoksa mevcut repo dokümanlarında zaten yer alan seçimleri esas al, eksik karar uydurma. En son kullanıcı kararı > önceki kullanıcı kararı > asistanın devredilmiş R-çözümü > eski prototip.

**DİKKAT:** Repo'nun eski `GAME_REQUIREMENTS.md` ve `README.md` dosyaları sabit yol/altınlı/tek haritalı Kingdom Rush benzeri eski demoyu anlatıyor. **Yeni Mayhem gereksinimi değiller**. Önceki çalışan demonun git geçmişini koru; yeni ürün kodu için ayrı sahne ve mimari kur, yeni README hazırlayabilirsin.

## 2. Kullanıcıyla netleştirilmiş ürün vizyonu

**Kamera ve karakter:** Cat Quest benzeri okunabilirlik; Cult of the Lamb benzeri çizgi film karakter estetiği, pixel art değil. Sabit 2D bakış açısı, karakteri izleyen zoomlu kamera, basit minimap. Android yatay ekran. Sol analog 360° hareket, sağ analog bağımsız 360° nişan ve yön tutuldukça otomatik ateş, **aim assist YOK**. Yakın dövüş silah slotundan seçilir; dodge ve cooldown'lı skills ayrı tuşlarda. İlk prototipte **4 farklı, basit placeholder karakter**, sabit karaktere özel melee/skill, iki değiştirilebilir ranged silah; herkes toplayabilir, savaşabilir, inşa/tamir edebilir. Mana ve silah dayanıklılığı yok. Karakter çizimi/animasyonlarıyla zaman harcama.

**Oyun döngüsü:** Oyuncu tek başına veya 1–4 kişilik co-op ile **yalnız HP/yenilgi hedefi olan merkezi** savunur. Başlangıçta duvar, atölye, klinik, fabrika, depo, ücretsiz ekipman, kaynak gelir makinesi YOK. Oyuncu ilk kaynağı el/etkileşimle toplar → fiziksel olarak taşır → yapı yerleştirir → inşaat yerine malzeme teslim eder → süre sonunda bina oluşur → üretim/onarım/savunma/cephane zincirleri kurar. Binalar merkezden bağımsız, uygun arazinin her yerinde. Global kaynak havuzu, para, meta puan, büyü/portal, runlar arası kalıcı güç **YOK**.

**Haritalar:** Nihai üründe 3 elle hazırlanmış harita (orman, kanyon/dağ, bataklık), merkez konumu seçimli, kontrollü coğrafi varyasyonlar (köprü/geçit/engel, kaynak, giriş yönü), zorunlu kaynakların yolu önceden doğrulanmış. Merkezden en uzak noktaya yürüyüş 60–90 saniye hedefi. Yükselti navigasyon ve yapı/lojistik engelidir, silah hasar/menzil bonusu vermez. P0'da küçük **tek test haritası** ve örnek varyasyon yeterli; tamamen procedural dünya istemiyoruz.

**İnşa/kaynak:** Serbest yerleştirme + Smart Snap; oyuncu/düşman işgalindeki yere yapı kurulamaz. Malzeme gerçekten şantiyeye ulaşmadan inşaat başlamaz; teslim sonrası oyuncu başında durmasa da süreyle tamamlanır. Yapım hâlindeki yapılar da düşman saldırısıyla hasarlanır, yıkılır. Tamir kaynak ister; söküm kısmi iade verir. Kapasiteli depolar, depo yıkımında kısmi yok oluş + yere dökülen loot. Küçük kaynak envanterde; büyük yük elde/araçla ve taşıma kısıtıyla. Temel kaynaklar sınırsız ama düşük debili, nadir kaynaklar tükenebilir; nadir tükenmesi asgari savunmayı imkânsız kılamaz. Ortak fiziksel kaynakları herkes kullanır, multiplayer'da server atomik işlem doğrular, oyuncuya para/veto sistemi ekleme.

**Üretim/elektrik:** Her makine **tek belirli ürünü** üretir; ayrı sınırlı input/output buffer, input bitince veya output dolunca durma, hasarda verim kaybı, upgrade ve paralel hat. İlk çağ basit, ileride 2–4 aşamalı zincir. Örnek hammadde → metal → mühimmat → kule/silah; başlangıçta basit alternatif üretim ve klinik/medkit/duvar seçenekleri farklı maliyetlerle açık. **İlk 10 bölüm manuel taşıma**, 11+ konveyör, daha sonra boru/araç/robot ve splitter öncelikleri. İlk manuel/yakıtlı üretim, ileri dönemde fiziksel kablo/direkle bağlı elektrik; kesinti bağlı makineleri **anında** durdurur. Overload tüm ilgili ağı kapatır, yük düşürünce düzelir; iki ayrı şebeke birbirine enerji aktarmaz. Global uzak makina kontrol paneli yok; yakın yapı HP/hasar belirtileri, uzak kritik saldırı yön uyarısı.

**Düşmanlar ve dalgalar:** Her yönden saldırı, normal tür merkez hedefi, sabotajcı üretim/depo/konveyör/enerji hedefi. Tam duvar kapatmak serbest; düşman türüne göre yol arama/duvar kırma/engel aşma, pathfinding kilitlenmemeli. AI her şeyi bilen zayıf-yapı avcısı değil; algılama, tür kuralı veya planlı baskına dayanır. Ana/boss saldırıları önceden uyarılır, küçük baskın sürpriz olabilir. Ana saldırı temizlenince bir sonraki bölüm gelir; küçük tehdit devam edebilir. 5/15/25... güçlü saldırı ve **her 5 bölümde checkpoint**; **10/20/30... boss**. Boss kimliği aynı bölüm için sabit, yardımcı faz/AI değişken. Düşman sayısı, kaynak ve zorluk **1, 2, 3, 4 kişiye göre ASLA otomatik ölçeklenmez**. Solo çok zordur; beceriyle yüksek dalgalara çıkma teorik olarak mümkündür.

**Teknolojik çağlar:** 1–20 Taş, 21–40 Tunç/Demir, 41–60 Orta Çağ, 61–80 Sanayi, 81–100 Modern, 101–120 İleri/Kıyamet Sonrası. İçerikler bölüm eşiğinde kademeli açılır, performans bağımlı değil. 121+ yeni çağ/son yok; mevcut üst çağda artan boss ve zorluk. Oyunun nihai hedefi sonsuz **rekor denemesi**; her yeni session sıfırdan.

**Savaş/ölüm:** Ranged gerçek fiziksel üretilmiş mühimmat harcar; şarjör + yedek stok + tuşla reload; melee mermi harcamaz. Silah parçaları fiziksel üretilir, modifikasyon yalnız inşa edilmiş atölyede. Düşmandan can/geçici kısa bonus yaklaşınca alınır, silah/malzeme manuel. HP sıfırda yere düşme, sürünme/kan kaybı ve takım arkadaşının erken kurtarma imkânı. **Son kullanıcı revizyonu:** Tam ölümde yaşayan başka takım arkadaşı varsa karakter süre sonunda **otomatik canlanır**, çalışan klinik süreyi azaltır, klinik yokluğu cezadır; cesedi kliniğe taşıma ZORUNLU DEĞİL. Solo tam ölüm checkpoint/yenilgi. Server boşken revive timer durur.

**Multiplayer kimlik kuralı — DEĞİŞTİRME:** Session'a **en fazla 4 farklı gerçek oyuncu kimliği** kaydedilir. İlk 4 kayıt tamamlanınca birisi ayrılsa da yerine 5. oyuncu **ASLA** giremez. Yalnız ilk 4 kişi eski slotuna/karakterine/eşyasına geri döner. Dört kayıt henüz dolmamışsa boş slot yeni oyuncuya açık. Aynı karakter takımda iki kez seçilemez. Geç gelen oyuncunun başlangıç ekipmanı yok; mevcut fiziksel stoklardan üretir. Server authoritative dedicated, host'a bağlı değil. Son kişi çıkınca atomik tam kayıt, üretim/AI duraklatma ve server process kapatabilme; geri gelince tekil resume. Takım yenilgisinde aktif oyuncular çoğunluk oylar, eşitlik checkpoint.

**Kayıt/rekor:** Checkpoint full world snapshot: harita varyasyonu, yapılar/HP, üretim/makine buffer'ları, depo stokları, karakter/ekipman, RNG. **Ara verme kaydı aynı noktada ve aynı RNG ile sürer**. **Yenilgi/checkpoint retry** dünya ve boss kimliğini korur fakat yeni saldırı alt-seed'i türeterek boss yardımcı saldırı düzeninde değişiklik sağlar. Checkpoint save ile geçici pause save birbirinin exploit'i olmaz. Oyun sonunda süre, dalga rekoru, kill, doğrudan oyuncu hasarı, kule/team hasarı ayrı, kaynak, tamir, üretim ve deneme bazlı istatistikler. 1/2/3/4 kişilik rekor aktif eşzamanlı en yüksek katılımcıya göre, sahte tek saniyelik katılım sayılmadan. Online leaderboard P2.

## 3. Gereksinimler: neyi uygulayacak ve nasıl izleyeceksin?

Repodaki `docs/REQUIREMENTS_V0_1.md` **87 gereksinim içerir** (64 P0 + 22 P1 + 1 P2). Bu görev paketinde ayrıca `MAYHEM_REQUIREMENTS_TRACEABLE_V0_2.md` **104 gereksinim** (önceki 87 aynen + 17 ek) ve 12 entegre kabul senaryosu içerir. Eki aldıysan `docs/REQUIREMENTS_V0_2.md` olarak commit et. Almadıysan aşağıdaki 17 ek ID'yi v0.1'e ekleyip aynı v0.2'yi üret:

- `SYS-007`: oturumlar arası güç/para/mana/büyü yok (P0); `SYS-008`: otomatik zorluk azaltma yok (P1); `SYS-009`: altı çağ ve sabit 20 dalga eşiği (P0); `SYS-010`: dört basit karakter profili (P0).
- `BLD-011`: bina çatısı/iç sahne yerine açık tesis (P0); `BLD-012`: başlangıç üretim/savunma/klinik seçenekleri farklı maliyetle erişilebilir (P0).
- `CBT-015`: melee yüksek risk/yüksek etki, ranged ammo (P0); `CBT-016`: melee slot, ayrı dodge/skill ve touch çakışma önleme (P0).
- `ENM-008`: boss/ana dalga uyarısı (P0); `ENM-009`: AI algılama/planlı baskın kuralları (P1).
- `PRD-011`: savunma türü mühimmat/enerji tüketim farkı (P0).
- `NET-006`: persistent kimlik/karakter rejoin kilidi (P1).
- `SAV-007`: son kişi çıkınca snapshot + pause + server kapatma (P1); `SAV-008`: yalnız aktif oyuncuların çoğunluk oylaması (P1).
- `NFR-006`: mobil sürükleme/uzun basma/hızlı yerleştirme ve touch ayrımı (P0); `NFR-007`: ilk sürümde takım botu yok (P0); `NFR-008`: mevcut repoda feature/PR ile geliştirme (P0).

Her gereksinim `ID / priority / implementation path / automated test / status / observed evidence / remaining issue` alanlarıyla raporlanmalı. **P0/P1/P2 ayrımını bozma.** Gerçek 4 kişi multiplayer, tüm 3 harita ve bütün 6 çağ içeriği ilk PR'da bitti diye iddia etme. Fakat P0'da farklı mekanikleri **geliştirici/debug (UNRANKED) modunda ileri dalgaya atlayıp test edebilmemi** sağla. Önce küçük fakat gerçekten çalışan zincir teslim et; sonra diğer P0'ları genişlet.

## 4. Gerçek geliştirme ve test beklentim

1. Önce repoyu ve branch'i kontrol et; eski demo ile yeni oyun çatışmasını belgele. Main'i değiştirme, history rebase/force-push yapma. Branch üzerinde yeni Godot scene/script mimarisi kur; `Player/Input`, `Inventory`, `Building`, `Production`, `Logistics`, `PowerGraph`, `EnemyAI/Waves`, `Save`, `Stats`, `HUD` ayrı sorumluluklarda olsun. Modüler/data-driven mimari; devasa tek `main.gd` olmasın.
2. Godot 4.7.2 binary erişimi varsa **gerçekten çalıştır**: `godot --headless --path . --editor --import --quit`, test scriptleri ve `godot --headless --path . --quit-after 180`. Sadece Python statik kontrol yetmez. Sürüm/komut/çıkış kodu/log özeti PR'a eklensin. Motor yoksa kurmayı dene; mümkün olmazsa test edilmedi diye yaz.
3. Modül ve end-to-end testleri: toplama → fiziksel transfer → malzeme teslimi → inşa → üretim → ammo → otomatik savunma, input/output doluluğu, elektrik kesintisi/overload/ayrı ağlar, düşman duvar tepkisi, 5-wave checkpoint, tam restore, retry RNG, solo ölüm, roster rejoin ve hastane hızlandırma veri-modeli, istatistik ayrıştırması. Otomatik simülasyon multiplayer ağ testinin yerini tutmaz.
4. Android fiziksel test yapamıyorsan PASS deme. Touchscreen iki parmak, geniş/dar ekran, FPS, HUD taşması ve editor import konularını kullanıcıya açık manuel test listesiyle aktar. PC'de de fare/klavyeyle oynama imkânı ver.
5. İşlevlerin hepsi uygulanamazsa yarım sistemlere PASS verme, gizleme; **çalışan oyun döngüsünü** önce hazırla. Her P0 satır için `VERIFIED / IMPLEMENTED UNTESTED / PARTIAL / NOT IMPLEMENTED`; P1/P2 için `DEFERRED` kullan. Mevcut ilk taslak ZIP'i veya önceden söylenen statik PASS sayısını Godot PASS sayma.
6. Çalışma tamamlandığında commit, push ve **main'e karşı Pull Request aç; merge etme**. PR'da hangi gereksinimlerin karşılandığı, test komutları ve gerçek sonuç, açık eksikler, kullanıcı için Android Godot F5 testi bulunmalı. `README.md` yeni prototype göre güncellenmeli; eski demo korunmalıdır.

## 5. Benim senden beklediğim somut teslim

- Gerçek GitHub PR URL, çalıştığın branch, commit özeti.
- `docs/REQUIREMENTS_TRACEABILITY.md`, `docs/TEST_RESULTS.md`, `docs/PROTOTYPE_LIMITATIONS.md`.
- Android Godot'ta `git pull` / clone sonrasında **oyunu nasıl açacağım, ilk 10 dakikada hangi mekanikleri hangi sırada test edeceğim** açıklaması.
- Şüpheli/eksik teknoloji veya mekanikler için tamamlandı yalanı yok; açık eksik listesi.

**Definition of Done:** Yeni Mayhem oyununun en az bir uçtan uca kaynak toplama → malzeme taşıma → inşaat → üretim → kule savunması → dalga → checkpoint döngüsü oynanabilir olmalı; Godot runtime/import ve logic testleri gerçekten çalıştırılmış olmalı. Dört karakter basit olsun. Mevcut eski demo başarı kanıtı değildir. Kullanıcı yalnız PR'ı merge edip Android telefondan pull yaparak denemek istiyor. Soruları varsayılan olarak bana yöneltme; ana çerçeveye sadık prototip değerlerini config'te belgeli seç.


---

# EK A — Gereksinim Baseline

# MAYHEM — Traceable Requirements v0.2 (104 gereksinim)

> Girdi: 62 önceki D-kararı, 42 cevaplanmış A-kararı, 16 R-çözümü, son kullanıcı açıklamaları. Bu belge **gereksinimdir**, testin geçtiğini iddia etmez.

## Öncelik ve geçersiz kayıtlar

- **Son kullanıcı kararı:** 4 benzersiz kimlik ve kalıcı slot/karakter rezervasyonu; ayrılanın yerine 5. kullanıcı giremez, aynı kişi dönebilir. Dört kişi dolana dek boş yere yeni oyuncu gelebilir.
- **Son kullanıcı kararı:** Multiplayer'da başka biri hayattaysa tam ölen karakter oyun süresiyle canlanır; çalışan klinik beklemeyi kısaltır. Solo tam ölüm checkpoint. Eski D-01.20 ve A-014'teki cesedi kliniğe taşıma zorunluluğu **geçersizdir**.
- **Son kullanıcı kararı:** Dört karakter ilk prototipte basit, mekanikler öncelikli; görsel detay ertelendi.
- **Son kullanıcı repo talimatı:** Eski A-039 ayrı repo seçimi sonradan `ErtugrulGurler/Mayhem` üzerinde feature branch + PR olarak değişti.
- P0 = oynanabilir dikey kesit; P1 = gerçek 1–4 co-op/sunucu ve ileri içerik; P2 = servis ve cilalama. P0/P1/P2 satırları otomatik PASS sayılamaz.
- Checkpoint yenilgi retry'si aynı dünya/boss ile yeni saldırı alt-seed'i oluşturur; ara verme kaydı tam RNG ile birebir sürer.
- Sayısal parametreler (HP, süre, recipe, FPS hedefi, canlanma süresi) **prototip balans varsayımıdır**, kullanıcı tarafından kesinleştirilmemiştir.

## v0.1'deki 87 gereksinim (ID, metin ve kabul kriterleri korunmuştur)

## Gereksinim tabloları

### SYS
| ID | Seviye | Gereksinim | Test edilebilir kabul kriteri | İz |
|---|---|---|---|---|
| SYS-001 | P0 | Sistem 2D yatay ekran, takip kamerası ve zoom sağlayacaktır. | Karakter hareket ederken kamera onu izler; zoom sınırlar içinde değişir. | A-037 |
| SYS-002 | P0 | Her yeni session tüm oyun içi teknoloji/ekipman/inşa durumunu sıfırdan başlatacaktır. | Yeni session ilk bölüme, boş dünyaya ve başlangıç karakterine döner. | D-01.23,D-02.01 |
| SYS-003 | P1 | Tek oyuncu da aynı kaynak ve düşman zorluğuyla oynayabilecektir. | 1 ve 4 oyunculu oturum için düşman tabloları aynı olacak; solo için ayrı indirim uygulanmayacak. | D-01.24 |
| SYS-004 | P0 | Oyunun hedefi ana yapının HP değerini sıfırın üstünde tutmaktır. | Ana yapı HP=0 olduğunda yenilgi süreci başlar; ana yapı craft/heal üretmez. | D-02.01 |
| SYS-005 | P1 | 1–4 oyunculu kayıt kimliği modelini ve 4 farklı karakter seçimini destekleyecektir. | Aynı session’da 5. kimlik reddedilir; aynı karakter iki kişiye verilmez. | R-005,D-02.28 |
| SYS-006 | P1 | Oyun süresi sınırsız devam edebilecektir. | Son çağdan sonra oyun otomatik sonlanmaz; bölüm zorluğu artmaya devam eder. | A-035,R-003 |

### MAP
| ID | Seviye | Gereksinim | Test edilebilir kabul kriteri | İz |
|---|---|---|---|---|
| MAP-001 | P1 | Ürün üç elle tasarlanmış ana haritayı destekleyecektir. | Orman/kanyon/bataklık örnek haritaları yüklenebilir; P0 yalnız orman. | D-01.02,A-024 |
| MAP-002 | P0 | Haritalar onaylı ılımlı varyasyonlara sahip olacaktır. | Bir başlangıç konumu ve varyasyon seçildiğinde zorunlu kaynaklara erişim korunur. | D-01.03,A-026 |
| MAP-003 | P0 | Ana yapı, haritaya özgü birden çok başlangıç noktasından seçilebilir olacaktır. | Seçilen konum aynı session boyunca korunur; yeni session farklı olabilir. | D-02.03,A-025 |
| MAP-004 | P0 | Yükselti/nehir/uçurum ve doğal engeller geçiş/inşa/hat güzergâhını sınırlayacaktır. | Engel üstüne yerleşim yapılamaz; geçerli yoldan geçilebilir; menzil/hasar bonusu oluşmaz. | D-01.04 |
| MAP-005 | P1 | Merkezden uç noktaya normal yürüyüş hedefi 60–90 sn olacaktır. | Ürün haritasında dengeleme testiyle seyahat süresi ölçülür; P0 küçültülmüş test alanı kullanabilir. | D-01.01 |
| MAP-006 | P0 | Mobil oyuncuya minimap ve kamera zoom sağlanacaktır. | Mini harita ana yapı, oyuncu ve alarm yönünü gösterir. | A-037 |

### BLD
| ID | Seviye | Gereksinim | Test edilebilir kabul kriteri | İz |
|---|---|---|---|---|
| BLD-001 | P0 | Haritanın uygun her noktasında serbest yapı konumlandırma desteklenecektir. | Çarpışma olmayan uygun zeminlere kurulur; merkez etrafında radius kilidi yoktur. | D-01.05,D-01.06 |
| BLD-002 | P0 | Yerleştirme Smart Snap sağlayacaktır. | Yakın duvar/hat/tesisler hizalanır; zorunlu grid kullanılmaz. | D-02.04 |
| BLD-003 | P0 | İnşaat için tüm fiziksel kaynakların sahaya getirilmesi gerekecektir. | Uzak depoda stok bulunsa bile inşaat başlayamaz; malzemeler manuel veya lojistikle sahaya teslim edilmelidir. | D-02.05,D-02.10 |
| BLD-004 | P0 | Yeterli kaynak teslim edilen yapı süre sonunda otomatik tamamlanacaktır. | Oyuncu uzaklaşsa da inşa süreci devam eder. | D-02.05 |
| BLD-005 | P0 | Tamamlanmamış yapı hasar alabilir ve yıkılabilir olacaktır. | Düşman inşaat sırasında 0 HP yaratırsa inşa iptal olur. | D-02.06 |
| BLD-006 | P0 | Yapılar sökülebilir ve kısmi malzeme geri kazanılabilir olacaktır. | Sökülen yapı kaybolur, oyuncuya maliyetin yüzde değeri kadar malzeme geri döner. | D-02.07,A-028 |
| BLD-007 | P0 | Bütün yapılar hasar oranına uygun kaynaklarla onarılacaktır. | Eksik HP kaynak getirilip onarılabilir; full HP üstü yok. | D-01.10,A-028 |
| BLD-008 | P0 | Ana yapı ilk dönemlerde manuel, ileriki çağlarda otomatik onarılabilir olacaktır. | Onarım maliyet ve zamanı uygulanır; otomasyon yalnız kilit açılınca çalışır. | D-02.02 |
| BLD-009 | P0 | Oyuncunun/düşmanın işgal ettiği araziye inşaat yerleştirilemeyecektir. | İşgal alanı denemesi reddedilir. | A-027 |
| BLD-010 | P0 | İyileşme, üretim, depo ve savunma tesisleri ayrı kurulabilir yapılar olacaktır. | Ana yapı içerisinde otomatik heal/craft sunulmaz. | D-02.01,A-002 |

### RES
| ID | Seviye | Gereksinim | Test edilebilir kabul kriteri | İz |
|---|---|---|---|---|
| RES-001 | P0 | Kaynak ekonomisi yalnız fiziksel ve takım ortak malzemelerden oluşacaktır. | Oyun içi para, mana veya harcanabilir meta puan bulunmaz. | D-01.13 |
| RES-002 | P0 | Temel kaynaklar tükenmeyen düşük verimli yataklardan toplanabilecektir. | Kaynak noktasından tekrar tekrar ham madde elde edilir; zaman/debi sınırı korunur. | D-01.11,A-023 |
| RES-003 | P1 | Nadir kaynaklar sınırlı miktarda bulunabilir; asgari sürdürülebilir savunma engellenmez. | Nadir kaynak tükenmesi minimum ok/mühimmat/onarım üretimini imkânsızlaştırmaz. | D-01.11,R-007 |
| RES-004 | P0 | İlk kaynaklar alet gerektirmeden toplanabilecektir. | Oyun başında boş envanter ile etkileşim ham kaynak verir. | A-003 |
| RES-005 | P0 | Kaynaklar fiziksel olarak player/depo/makine/inşaat yeri arasında taşınacaktır. | Global kaynaktan uzakta otomatik harcama yapılamaz. | D-01.12,D-02.10 |
| RES-006 | P0 | Küçük malzemeler sınırlı envanterde, büyük malzemeler ayrı taşıma kapasitesinde tutulacaktır. | Envanter kapasitesi aşan küçük ürün alınamaz; büyük parça taşırken hareket kısıtı vardır. | D-02.11 |
| RES-007 | P0 | Depoların kaynak kapasitesi sınırlı olacaktır. | Depo kapasite doluyken yeni ürün kabul etmez. | D-02.08 |
| RES-008 | P0 | Depo yıkılınca ürünün bir kısmı kaybolacak, diğer kısmı fiziksel loot olarak yere dökülecektir. | Yere dökülen ürünler etkileşimle alınabilir. | D-02.09 |
| RES-009 | P1 | Ortak malzemeyi bütün aktif kimlikler izin gerektirmeden kullanabilecektir. | Server kaynak transferini atomik kontrol eder; oyuncu bazlı para hesabı yoktur. | A-033,R-008 |

### PRD
| ID | Seviye | Gereksinim | Test edilebilir kabul kriteri | İz |
|---|---|---|---|---|
| PRD-001 | P0 | Üretim zincirleri çağlara göre 1–4 aşamalı tariflerden oluşacaktır. | En az bir hammadde -> ürün, bir ara ürün -> başka ürün testi geçer. | D-01.14 |
| PRD-002 | P0 | Her makine tek sabit ürüne özel olacaktır. | Aynı makinede menüden sınırsız tarif değiştirme yok; yeni çağda yeni makine açılır. | D-02.17 |
| PRD-003 | P0 | Makine input ve output buffer kapasitesine uyacaktır. | Input yoksa durur; output dolunca durur. | D-02.18,A-021 |
| PRD-004 | P0 | Makine hasar aldıkça verimi azalabilecek; durabilir veya tamamen yıkılabilir olacaktır. | Düşük HP olan makine üretimi yavaşlatır; 0 HP silinir. | D-01.09 |
| PRD-005 | P0 | Oyuncular makineyi seviye yükselterek veya paralel makine kurarak kapasite artırabilecektir. | İki aynı makine veya upgrade üretim hızını artırır. | D-02.19 |
| PRD-006 | P0 | Lojistik otomasyonu ilk on bölümden sonra açılacaktır. | 1–10 manuel transfer, 11+ konveyör / bağlantı. | D-01.15 |
| PRD-007 | P1 | İleri çağlarda konveyör, boru, araç ve robot lojistiği desteklenecektir. | P0 konveyör örneği; P1 boru+taşıyıcı araç+robot. | D-02.12 |
| PRD-008 | P1 | Ayırıcılar/yönlendiriciler fiziksel akışın önceliğini belirleyecektir. | Aynı kaynak istenen iki hatta birisi önceliklendirilebilir. | D-02.20 |
| PRD-009 | P0 | Makineler global yönetim panelinden uzaktan kontrol edilemeyecektir. | Makine ayrıntıları yanındayken görülebilir. | D-02.16 |
| PRD-010 | P0 | Uzak tesisler sadece kritik saldırıda yönsel uyarı oluşturacaktır. | Uzakta her küçük hasar UI spam yapmaz; kritik eşiği tetikler. | D-02.16 |

### PWR
| ID | Seviye | Gereksinim | Test edilebilir kabul kriteri | İz |
|---|---|---|---|---|
| PWR-001 | P0 | İlkel üretim manuel/yakıtlı, ileri üretim elektrikle çalışacaktır. | Sanayi aşamasında jeneratör ve elektrikli cihaz üretim testi. | D-02.13 |
| PWR-002 | P0 | Elektrik bağlantısı fiziksel kablo/direk ağıyla sağlanacaktır. | Bağlantı yokken enerji tüketen makine çalışmaz. | D-02.14 |
| PWR-003 | P0 | Enerji kesilmesi elektrikli makineleri/savunmaları anında durduracaktır. | Kesik kablo testi sistemleri durdurur, bağlantı geri gelince normalleşir. | D-02.15 |
| PWR-004 | P0 | Talep mevcut kapasiteyi aşınca ağın tamamı kapanacaktır. | Overload durumda tüm enerji tüketicileri durur, talep düşürülünce gelir. | A-022,R-006 |

### CBT
| ID | Seviye | Gereksinim | Test edilebilir kabul kriteri | İz |
|---|---|---|---|---|
| CBT-001 | P0 | Oyuncu sol analogla hareket, sağ analogla yön/otomatik ateş kullanacaktır. | Aynı anda iki touch id hareket ve ateş sağlar; aim assist yok. | D-02.24,D-02.25 |
| CBT-002 | P0 | Karakterlerin kendilerine özgü sabit yakın dövüş ve cooldown skill seti olacaktır. | 4 karakter datasında skill alanı ayrı, mana sistemi yoktur. | D-02.26,D-02.27 |
| CBT-003 | P1 | Takımda aynı karakter iki oyuncu tarafından seçilemeyecektir. | Müsait olmayan karakterin seçimi server tarafından reddedilir. | D-02.28 |
| CBT-004 | P0 | Her karakter savaşma, toplama, inşa ve tamir yapabilecektir. | Bütün karakter modelleri temel eylemlerde engellenmez. | D-02.29 |
| CBT-005 | P0 | Karakter iki ek silah slotu ve değişmeyen yakın dövüş slotuna sahip olacaktır. | İki ateşli silah ve melee geçişi doğrulanır; veri modeli sabit slot sayısını hardcode etmez. | D-02.26 |
| CBT-006 | P0 | Mühimmat fiziksel olarak üretilir ve silahlara yeniden doldurulur. | Envanterde uygun ammo yoksa reload başarısızdır; yakın dövüşte ammo harcanmaz. | D-02.30,A-013 |
| CBT-007 | P0 | Silah parçaları fiziksel kaynaklarla üretilir, modifikasyon yalnız atölyede yapılır. | Atölye dışında upgrade reddedilir. | D-02.31,D-02.32 |
| CBT-008 | P0 | Silahlar kullanım sonucu bozulmayacaktır. | Ateş sayısına bağlı dayanıklılık değeri yoktur. | D-02.33 |
| CBT-009 | P0 | Dodge ve skill düğmeleri twin-stick ile birlikte çalışacaktır. | Dodge cooldown; skill ayrı eylem, analogla çakışmıyor. | A-010 |
| CBT-010 | P0 | Can/heal ve süreli hız bonusları otomatik; fiziksel loot ve silah manual alınacaktır. | Yakınlıkla can/hız artar; silah/taş için etkileşim gerekir. | D-02.34 |
| CBT-011 | P0 | Ödül olasılıkları düşüktür, güçlendirmeler kısa süreli ve üst üste birikmez. | Loot tabloları mevcut çağa göre çalışır ve güçlü drop erken çağda gelmez. | D-02.35,A-020 |
| CBT-012 | P0 | Canı sıfırlanan oyuncu sürünme ve kan kaybı safhasına geçecektir. | Süre sonunda tam ölüm olur; sürünme hızı normalden düşüktür. | D-01.19 |
| CBT-013 | P1 | Süreli canlanma klinikle hızlanacak; klinik olmadan daha uzun sürecektir. | Hayatta takım arkadaşı varsa recovery timer clinic aktifken daha kısa; solo tam ölüm checkpoint. | R-002,R-014 |
| CBT-014 | P0 | İyileşme tesisleri ve üretilen medkitlerle can iyileştirilebilecektir. | Clinic ve medkit ayrı eylemler; medkit fiziksel sarf malzemesidir. | A-012 |

### ENM
| ID | Seviye | Gereksinim | Test edilebilir kabul kriteri | İz |
|---|---|---|---|---|
| ENM-001 | P0 | Ana saldırılar normal / hızlı / kuşatmacı / sabotajcı ve boss gibi türler içerecektir. | En az üç farklı hedef türünün davranışı izlenebilir. | D-01.07,D-01.08 |
| ENM-002 | P0 | Normal düşmanlar çoğunlukla merkez HP hedefini izleyecektir. | Merkeze ulaşınca HP azalır, engel olursa duvara saldırabilir. | D-01.08 |
| ENM-003 | P0 | Sabotajcılar görülen üretim, depo veya enerji sistemini hedefleyecektir. | Üretime yaklaşınca yapı HP düşer; map geneli omniscience yoktur. | A-008,A-041 |
| ENM-004 | P0 | Her on bölümde boss, ara beşinci bölümde güçlü saldırı olacaktır. | 5. bölümde elite, 10. bölümde boss çıkışı doğrulanır. | D-01.18 |
| ENM-005 | P0 | Aynı bölümün boss kimliği korunur, yardımcı faz dağılımı tekrar denemede değişebilir. | Checkpoint retry yeni sub-seed seçer, boss ID değişmez. | A-030,R-001 |
| ENM-006 | P0 | Ana saldırı temizlenince bölüm ilerler, küçük tehdit devam edebilir. | Düşmanları temizleyen ekip sonraki bölüm başlar; kalan mini tehdit süreli devam eder. | D-01.17 |
| ENM-007 | P1 | Düşman sayısı ve kaynak miktarı oyuncu sayısına göre ölçeklenmeyecektir. | Aynı bölüm konfigürasyonu 1 ve 4 oyuncuya aynı parametreleri üretir. | D-01.24 |

### SAV
| ID | Seviye | Gereksinim | Test edilebilir kabul kriteri | İz |
|---|---|---|---|---|
| SAV-001 | P0 | Her beş bölüm sonunda checkpoint kaydı alınacaktır. | 5/10/... başlangıç geçişinde tam dünya, silahlar, makine stokları snapshot. | D-01.23,A-015 |
| SAV-002 | P0 | Ara verme kaydı aynı yerden aynen devam ederken checkpoint retry yalnız gelecek rastgele karşılaşmayı değiştirir. | Resume eşit dünya/RNG; retry aynı terrain farklı future event sub-seed. | R-001 |
| SAV-003 | P0 | Tek oyuncu tam ölürse veya merkez HP sıfırlanırsa checkpoint ya da yeni session seçimi sunulacaktır. | Kaydedilmiş geçerli state geri yüklenir; geçici save exploit ile kullanılamaz. | D-01.21,D-01.22 |
| SAV-004 | P1 | Multiplayer yenilgi kararında çevrimiçi oyuncular çoğunluk kuralıyla oy kullanacaktır. | 2–2 eşitlik checkpoint; çevrimdışı oyuncu sayılmaz. | R-013 |
| SAV-005 | P1 | Boş session kaydedilip sunucu işlemi kapatılabilecek ve tekrar açılabilecektir. | Aynı oturum id ile snapshot güvenli biçimde yüklenir. | R-010 |
| SAV-006 | P1 | Kayıt bütünlüğü şema ve atomik swap ile korunacaktır. | Bozuk kayıt son çalışan checkpoint’i yok etmez. | R-010 |

### NET
| ID | Seviye | Gereksinim | Test edilebilir kabul kriteri | İz |
|---|---|---|---|---|
| NET-001 | P1 | Dedicated authoritative server client seçimlerini doğrulayacaktır. | Client kaynak stok/HP/hasar değerini tek başına değiştiremez. | D-01.25 |
| NET-002 | P1 | Her session en çok dört benzersiz oyuncu kimliğini kalıcı olarak rezerve edecektir. | Dört kimlik kaydolunca beşinci reddedilir; ayrılan eski kimlik dönebilir. | R-005 |
| NET-003 | P1 | Ayrılan oyuncunun karakteri görünmez olur, ekipman ve kimliği saklanır. | Aynı kimlikle rejoin aynı ekipmanla olur. | A-032,R-015 |
| NET-004 | P1 | Oyuncu sayısından bağımsız zorluk uygulanacaktır. | 1–4 kişi farklı UI/oyun yoğunluğu, aynı wave config. | D-01.24 |
| NET-005 | P1 | Session lideri harita/başlangıç seçer, ayrılınca aktif oyuncuya liderlik geçer. | Leadership owner değil; dedicated server otoritesi değişmez. | R-004 |

### STA
| ID | Seviye | Gereksinim | Test edilebilir kabul kriteri | İz |
|---|---|---|---|---|
| STA-001 | P0 | Oyun sonunda kişi başı doğrudan hasar, öldürme, kaynak, tamir ve üretim sayıları gösterilecektir. | Statistikler oyuncu kimliğiyle ayrılır ve toplamları doğrulanır. | A-034 |
| STA-002 | P0 | Kule hasarı ve öldürmesi oyuncu hasarına eklenmeyecektir. | Kule sayıları takım/yapı alanında ayrı tutulur. | A-018 |
| STA-003 | P0 | Oturumda geçen gerçek aktif oyun süresi, ulaşılan en yüksek bölüm ve denemeler ayrı saklanacaktır. | Checkpoint retry zamanı ve eylem sayıları doğru türetilir. | A-017 |
| STA-004 | P1 | 1–4 oyunculu leaderboard doğrulanmış eşzamanlı oyuncu tepesine göre ayrılacaktır. | Kısa/aktif olmayan katılım rekoru manipüle edemez. | D-01.27,R-009 |
| STA-005 | P2 | Online liderlik tablosu sunucu imzasıyla doğrulanacak, cihazda da session geçmişi tutulacaktır. | Client manipülasyon ile online skor ekleyemez. | A-019 |

### NFR
| ID | Seviye | Gereksinim | Test edilebilir kabul kriteri | İz |
|---|---|---|---|---|
| NFR-001 | P0 | Prototip tek yerel oyuncu ve dört basit karakter veri tanımıyla bir gerçek gameplay loop sunacaktır. | Ana hedef koruma, toplama, inşa, düşman, üretim, can, loot, wave, kayıt ve istatistik işlemleri deneyimlenebilir. | R-016 |
| NFR-002 | P0 | Godot 4.7.2 ve Compatibility renderer hedeflenecektir. | Godot editor import ve headless testleri engine mevcut ortamda geçer. | User platform |
| NFR-003 | P0 | Geliştirme testleri P0 çekirdek mekaniklerini otomatik kontrol edecektir. | Bağımsız pure tests veri/decision coverage; Godot yüklüyse headless script smoke. | User request |
| NFR-004 | P1 | Gerçek mobil FPS, UI ve ağ gecikmesi sayısal testle belirlenecektir. | En az iki ekran oranında manuel test, headless ve Android test sınırlaması not edilir. | A-040 |
| NFR-005 | P0 | Eski sabit yol projesinin dosyaları değiştirilmeden yeni prototip ayrı repo için hazırlanacaktır. | Yeni paket ayrı `project.godot` içerir; eski GitHub repo etkilenmez. | A-039 |

## Kabul politikası
- Bir gereksinim yalnız **Godot import/çalıştırma ve ilgili test/manuel kabul adımı** ile doğrulandığında “geçti” olarak işaretlenir.
- P0 için basitleştirilmiş örnek uygulama, P1/P2 için yerine geçen kanıt değildir.
- Dedicated sunucu, dört istemci, mobil fiziksel performans, online leaderboard ve altı çağın bütün içeriği **P1/P2** olarak ayrılır.
- Kararların tamamı `DESIGN_V0_4.md` dosyasında izlenebilir.


## v0.2 — 17 ek gereksinim (önceki iz açıkları)

| ID | Öncelik | Gereksinim | Kabul kriteri | İz |
|---|---|---|---|---|
| SYS-007 | P0 | Oturumlar arası kalıcı güç, para, mana, büyü ve portal bulunmaz. | Yeni session sıfırdan başlar; meta bonus/mana arayüzü yoktur. | D-02.22,D-01.13 |
| SYS-008 | P1 | Zorluk oyuncular geri kaldığında veya az kişi olduğunda düşürülmez. | Aynı wave config 1–4 oyuncuda aynıdır. | D-01.16,D-01.24 |
| SYS-009 | P0 | Altı çağ seçilen sırada ve 20 dalgalık sabit eşiklerde açılır. | 1–20 Taş, 21–40 Tunç/Demir, 41–60 Orta Çağ, 61–80 Sanayi, 81–100 Modern, 101–120 İleri/Kıyamet sonrası, 121+ altıncı çağ sürer. | A-006,A-007,D-02.23 |
| SYS-010 | P0 | Prototipte dört basit veri odaklı karakter bulunur. | Dört karakter profili yüklenir; detaylı sprite gerektirmez. | A-011,R-016 |
| BLD-011 | P0 | Prototip binaları çatıya ihtiyaç duymayan açık tesislerdir. | İç mekân sahnesi veya çatıdan dolayı karakterin gizlenmesi yoktur. | R-011,A-002 |
| BLD-012 | P0 | İlk dönemde temel savunma/iyileştirme/üretim seçenekleri farklı maliyetlerle eşzamanlı erişilebilir. | Başlangıçta bedava bina yok; seçenekler farklı kaynak gerektirir. | A-005,D-02.01 |
| CBT-015 | P0 | Yakın dövüş riskli ama etkili, menzilli silah mühimmat tüketir. | Melee menzili kısa, hasarı etkili; ammo gerektirmez. | A-029,D-02.30 |
| CBT-016 | P0 | Mobilde melee silah seçimiyle, dodge ve skill ayrı tuşlarla sağlanır. | İki analog, skill ve dodge aynı anda çakışmadan çalışır. | A-010,R-012 |
| ENM-008 | P0 | Ana saldırı ve boss önceden uyarılır; küçük baskınlar sürpriz olabilir. | Ana dalga/boss öncesi alarm olur, küçük saldırı alarm zorunlu değildir. | A-009 |
| ENM-009 | P1 | Düşman AI hedefleme türüne göre ve algılama/planlı baskın bilgisiyle çalışır. | Keşfedilmemiş uzak tesisi keyfî hedeflemez. | A-041,A-008 |
| PRD-011 | P0 | Savunmalar türüne göre enerji/mühimmat tüketebilir veya tüketmeyebilir. | Mühimmatsız kule ateş etmez, basit tuzak çalışabilir. | D-02.21 |
| NET-006 | P1 | Session oyuncu kimliği ve karakter rezervasyonu kayıt sonrası sürer. | Dört kullanıcı varsa beşinci reddedilir; eski kullanıcı aynı karakter/ekipmanla döner. | A-031,R-005,R-015 |
| SAV-007 | P1 | Son oyuncu ayrılınca session kaydedilir, durur, sunucu kapatılabilir. | İlerleme durur; tekil resume ile yeniden açılır. | A-038,D-01.26,R-010 |
| SAV-008 | P1 | Yenilgi sonrası yalnız aktif kullanıcılar çoğunlukla oy verir. | Eşitlik checkpoint, çevrimdışı oy yoktur. | A-016,R-013 |
| NFR-006 | P0 | Mobilde sürükleme, uzun basma ve hızlı yerleştirme desteklenir. | Touch HUD/twin-stick alanlarıyla çakışmaz. | A-036,R-012 |
| NFR-007 | P0 | İlk sürümde oyuncu yerine takım botu olmayacaktır. | Yapay takım üyesi doğmaz. | A-042 |
| NFR-008 | P0 | Yeni ürün mevcut GitHub reposunun feature branchinde geliştirilecektir. | main doğrudan değiştirilmez; eski demo git geçmişinde korunur; PR açılır. | A-039,R-016 |

## Entegre kabul senaryoları (prototip)

1. **E2E-01**: Godot 4.7.2 ile aç, 4 temel karakterden birini seç, hareket/aim/auto fire/melee/dodge/skill dene; mobil twin-stick ve masaüstü kontrolü ayrı testle.
2. **E2E-02**: Elle kaynak topla, sınırlı envanterde taşı, malzeme fiziksel inşaat sahasına gelmeden inşaatın başlamadığını gör.
3. **E2E-03**: Smart Snap ile duvar/depo/klinik/atölye kur, malzeme teslim et, timed build sırasında saldırı gör, tamir ve sökümde kısmi iade dene.
4. **E2E-04**: Hammadde → ara ürün → mühimmat → savunma silahı zincirini işlet, input yok/output dolu/hasarlı makine senaryolarını test et.
5. **E2E-05**: İlk 10 dalgada manuel taşıma, 11'de örnek conveyor; debi ve aktarım kaydı dene.
6. **E2E-06**: İki ayrı elektrik ağı, kablo kopması ve overload; yalnız ilgili ağ durmalı, yük azaltınca yeniden çalışmalı.
7. **E2E-07**: Duvar ve sabotajcı AI, wave 5 elite+checkpoint, wave 10 boss ve ön uyarıları dene; oyuncu sayısına göre kolaylaştırma yapma.
8. **E2E-08**: Checkpoint'ten restore: dünya/HP/makineler/stok geri, boss ID aynı, retry saldırısı değişken; pause/resume ise aynı RNG.
9. **E2E-09**: Gerçek multiplayer henüz yoksa P1 veri modeli testi: kimlikler A,B,C,D doluysa E reddedilir, ayrılan A geri döner ve eşyaları korunur.
10. **E2E-10**: Gerçek multiplayer henüz yoksa P1 veri modeli testi: takım arkadaşı canlı ve klinik aktif/pasif canlanma sürelerini simüle et, solo ölümü checkpoint'e götür.
11. **E2E-11**: İstatistiklerde kişisel hasar ile kule hasarı ayrımı, deneme süresi, skor/rekor kategorisi.
12. **E2E-12**: F5 ile açılan sahnede oyuncu en az bir uçtan uca toplama → inşa → üretim → savunma döngüsünü görebilmeli. Debug işlemleri UNRANKED olmalıdır.

**Kanıt sınıfları:** STATİK, GODOT HEADLESS, MOTOR RUNTIME, ANDROID CİHAZ, MULTIPLAYER NETWORK. İlki sonraki üçünün yerine geçmez. Her satırı `IMPLEMENTED+VERIFIED / IMPLEMENTED+UNTESTED / PARTIAL / NOT IMPLEMENTED / P1-P2 DEFERRED` statüsüyle raporla.


---

# EK B — Tam Karar Kaydı

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
