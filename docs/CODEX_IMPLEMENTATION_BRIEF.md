# Codex görevi — Mayhem: yeni 2D aksiyon + üs savunma prototipi

## Kaynak belgeler ve öncelik
**Çalışacağın mevcut repo:** `ErtugrulGurler/Mayhem` (main). Başka repo oluşturma.
Önce repo içindeki `docs/DESIGN_V0_4.md` ve `docs/REQUIREMENTS_V0_1.md` dosyalarını **tamamen oku**. Bu belgeler tasarım ve acceptance criteria kaynağıdır.
Karar çelişirse son kullanıcı kararı üstündür. İlk mevcut kod Kingdom Rush tarzı eski sabit yol prototipidir; **yeni oyun farklıdır**. `GAME_REQUIREMENTS.md` eski prototipi anlatır ve yeni belgelerin önüne geçemez.
Dışarıdan hazırlanmış ZIP'i veya asistanın önceki doğrulanmamış Godot kodunu temel alma; projeyi kendin geliştir ve test et.

## Git akışı
- `main` üzerinde doğrudan çalışma; yeni bir `feature/mayhem-functional-prototype` branch'i aç.
- Mevcut çalışan prototipin geçmişini koru; yeni sahne/sistemler oluştur, gereksiz yıkıcı değişiklik yapma.
- Görevi tamamlayınca commit/push yap, **main hedefli PR** aç. PR'ı kullanıcı onayı olmadan merge etme.
- PR linki, çalıştırma talimatları ve test sonuçlarını Türkçe ver.
- Projeyi kullanıcının Android Godot editörüne pull/ZIP indirerek açabileceği şekilde hazırla.

## Birincil hedef: Android'de oynanabilir ve test edilebilir P0 dikey kesit
Önce **çalışan** bir oyun üret; yüzlerce satırlık tek script'e bütün mantığı koyma. Godot 4.7.2 / GDScript / Compatibility / yatay mobil. Grafikler şimdilik sade okunaklı renkli placeholder; detaylı karakter çizimi, animasyon, müzik yok.
1. Serbest dolaşan bir karakter, sol analog hareket, sağ analogla manuel 360° nişan + otomatik ateş, aim assist yok; kamera zoom. Dört benzersiz karakter için basit farklı veri/skill, cooldown; bu PR'da gerçek online 4 oyuncu şart değil.
2. Savunulan HP'li merkez hedef; başlangıçta duvar/fabrika/klinik verilmez. Fiziksel kaynak topla, sınırlı envanterde taşı, inşaat alanına teslim et; kaynak yoksa inşaat başlamaz. Serbest inşa/Smart Snap, süreli inşa, hasar, sökme, onarım.
3. Kaynak depoları, kapasite, en az bir sınırsız temel kaynak ve bir kısıtlı kaynak; makine giriş/çıkış tamponları; en az iki aşamalı üretim, iki paralel hat ve makine upgrade.
4. Mühimmat üreten üretim zinciri -> mühimmat tüketen otomatik savunma. Çağla elektrik üreten sistem, fiziksel bağlantı, enerjisiz kalınca ilgili sistemin durması; birbirinden bağımsız enerji ağları karışmasın. En az bir fiziksel otomatik lojistik örneği; ilk 10 bölüm manuel taşıma, 11+ otomasyona erişim.
5. Uygun arazide serbest savunma/üretim yerleşimi; düşmanlar merkeze yönelsin, belirli türler duvar ve üretim hattına saldırabilsin; basit navigasyon, engellerde sonsuz sıkışma olmasın.
6. Ana düşman temizlenince sonraki bölüm; arada düşük tehdit; her beşinci bölüm güçlü saldırı/checkpoint, her onuncu bölüm boss. 20 bölümde çağ atlama, dalga/teknoloji test kısayolları (DEBUG/UNRANKED). Tek oyuncu zorluğunu otomatik düşürme.
7. Yere düşme/sürünme/kurtulma denemesi; solo tam ölüm checkpoint. Multiplayer için veri modeli: en çok dört **benzersiz** kimlik, giren slotunu bırakmaz, çıkıp aynı kimlikle dönebilir. Canlı takım arkadaşı varsa tam ölenin süre sonunda canlanması, aktif klinik varsa daha kısa süre (online multiplayer için mekanik hazırlığı; gerçek networking P1).
8. Checkpoint'e dönüşte yapı/stok/ekipman korunur, aynı boss ile farklı saldırı alt-seed'i; ara verme kaydında tam aynı oyun durumuna dönüş. Yenilgi ekranından checkpoint/sıfırdan yeni session.
9. Oyun sonu ve oturum istatistikleri: süre, en yüksek bölüm, kaç düşman öldü, toplanan kaynak, verilen hasar; kule hasarı oyuncu hasarından ayrı.
10. Doğrudan test etme için kolay HUD: kaynakları gör, kur, taşı, üret, silah değiştir, heal, onar, savunma hasarını gör, dalga/çağ ilerletme testini çalıştır.

## Mimari
- Gameplay, Player/Input, Inventory/Resource, Build, Production/Logistics, Power, Enemy/Wave, Save, Stats bileşenlerini ayrıştır; data-driven veri ve signal/event kullan. Modüler, genişletilebilir Godot scene/script yapısı.
- P0 için görsel kalite ve içerik sayısını düşük tut; mekaniklerin **birbirine bağlanmış çalışması** önemli.
- Bir gereksinimi basitleştiriyorsan bu durumu açıkça `PROTOTYPE_LIMITATIONS.md` içinde belirt; tamamlanmamışı PASS sayma.
- P1 gerçek authoritative dedicated server, 1-4 oyuncu multiplayer sync/roster/rejoin; P2 leaderboard vb. **Bu PR'da hazırmış gibi gösterme.**

## Otomatik doğrulama (zorunlu)
- Godot 4.7.2 stable edinilebiliyorsa gerçek binary ile `--headless --editor --import --quit`, `--headless --quit-after 180` ve ayrı smoke/logic test script'leri çalıştır. Çıktıları PR'a ekle.
- Envanter kapasitesi, fiziksel malzeme teslimatı, crafting tarifleri, enerji ağlarının izolasyonu, elektrik kesintisi, üretim tamponu, dönem açılışları, düşman hasarı/öldürülmesi, checkpoint snapshot ve resume, solo ölüm, istatistik hesapları için otomatik testler ekle.
- Android cihazda test edilmemişse bunu açıkça belirt. Godot import/syntax hatası varsa PR'ı tamamlanmış olarak teslim etme.
- Gereksinim bazlı sonuç tablosu hazırla: ID / IMPLEMENTED / TESTED / PARTIAL / NOT IMPLEMENTED / kanıt.
- Kullanıcıya sonunda yalnız kısa sonuç, PR URL, nasıl pull edeceği, neleri denemesi gerektiği ilet.

## Başarı kriteri
Kullanıcı PR'ı merge edip telefonundaki Godot'a main'i pull ettiğinde en azından kaynak toplama -> fiziksel taşıma -> yapı kurma -> üretme -> savunma -> bölüm/checkpoint -> istatistik döngüsünü oynayabilsin.
