
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
