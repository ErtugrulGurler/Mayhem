> 21 Kasım ayrı ana menü/pause akışı: [güncel rapor](menu/REPORT.md). Önceki aşağıdaki teslim kayıtları tarihçedir.

> 20 Kasım mobil UX revizyonu ve güncel 349 kontrol: [UX raporu](ux/REPORT.md). Aşağıdaki bölüm 19 Kasım P0 temel tesliminin kapsam kaydıdır.

# Gereksinim izlenebilirliği — P0 dikey kesit

Kaynak: REQUIREMENTS_V0_2.md — **104 satır: 76 P0 + 27 P1 + 1 P2**. Öncelikler değiştirilmedi.
VERIFIED yalnız belirtilen yerel Godot headless kabulü; Android veya gerçek multiplayer kanıtı değildir.
IMPLEMENTED UNTESTED ilgili manuel/görsel kabul yapılmadı demektir. P1/P2 model testi olsa da DEFERRED kalır.
Yollar prototype/ köküne göredir. systems/loop/scene = tests/p0/*_test.gd; session_rules = tests/session_rules_smoke.gd.
Ham sonuçlar docs/evidence/<test>.txt. İlk taslaklar artık gerçekten 4.7.2 ile testlidir. Legacy testleri yeni oyun kanıtı sayılmaz.
JSON ham karar kaynakları repo/ekte yoktu; uydurulmadı. Tam Markdown devir metni ve 120 karar sürümlü korundu.

| ID | Priority | Implementation path | Automated test | Status | Observed evidence | Remaining issue |
|---|---|---|---|---|---|---|
| SYS-001 | P0 | core/session_state.gd; session_rules.gd | systems; scene; session_rules | PARTIAL | Takip/zoom headless testi ve yatay ayar mevcut. | Android ekran/dokunma doğrulanmadı. |
| SYS-002 | P0 | core/session_state.gd; session_rules.gd | systems; scene; session_rules | VERIFIED | Boş yapı/envanter/silah; yeni oturum dalga 1. | Yalnız yerel oturum. |
| SYS-003 | P1 | core/session_state.gd; session_rules.gd | Offline model varsa systems/session_rules; network NOT RUN | DEFERRED | Gerçek ağ/cihaz/servis kabulü yok. | P1/P2 ayrı uygulama ve kabul. |
| SYS-004 | P0 | core/session_state.gd; session_rules.gd | systems; scene; session_rules | VERIFIED | Merkez HP=0 → lost; gelir/craft yok. | — |
| SYS-005 | P1 | core/session_state.gd; session_rules.gd | Offline model varsa systems/session_rules; network NOT RUN | DEFERRED | Roster/rejoin/klinik süre offline modeli testli; gerçek ağ testi değil. | P1/P2 ayrı uygulama ve kabul. |
| SYS-006 | P1 | core/session_state.gd; session_rules.gd | Offline model varsa systems/session_rules; network NOT RUN | DEFERRED | Gerçek ağ/cihaz/servis kabulü yok. | P1/P2 ayrı uygulama ve kabul. |
| MAP-001 | P1 | core/terrain.gd; presentation/minimap.gd | Offline model varsa systems/session_rules; network NOT RUN | DEFERRED | Gerçek ağ/cihaz/servis kabulü yok. | P1/P2 ayrı uygulama ve kabul. |
| MAP-002 | P0 | core/terrain.gd; presentation/minimap.gd | systems; scene | VERIFIED | 2 merkez × 2 varyasyonda bütün kaynaklar için yol bulundu. | P0 küçük tek orman. |
| MAP-003 | P0 | core/terrain.gd; presentation/minimap.gd | systems; scene | VERIFIED | Menü doğu/batı merkez seçimi, snapshot konumu koruyor. | Ağ lideri P1. |
| MAP-004 | P0 | core/terrain.gd; presentation/minimap.gd | systems; scene | VERIFIED | Nehre inşa reddi ve köprü üzerinden yol testi. | Küçük test arazisi; menzil bonusu yok. |
| MAP-005 | P1 | core/terrain.gd; presentation/minimap.gd | Offline model varsa systems/session_rules; network NOT RUN | DEFERRED | Gerçek ağ/cihaz/servis kabulü yok. | P1/P2 ayrı uygulama ve kabul. |
| MAP-006 | P0 | core/terrain.gd; presentation/minimap.gd | systems; scene | PARTIAL | Minimap kodu, kamera/zoom ve sahne açılışı mevcut. | Minimap görsel kabulü ve ön alarm yönü eksik. |
| BLD-001 | P0 | systems/building_system.gd | systems; loop | VERIFIED | Serbest konum ve yakın yapı hizalama testi. | 13 birim snap; zorunlu grid yok. |
| BLD-002 | P0 | systems/building_system.gd | systems; loop | VERIFIED | Serbest konum ve yakın yapı hizalama testi. | 13 birim snap; zorunlu grid yok. |
| BLD-003 | P0 | systems/building_system.gd | systems; loop | VERIFIED | Uzak teslim reddi; fiziksel teslim; uzaklaşınca süreli tamamlanma. | — |
| BLD-004 | P0 | systems/building_system.gd | systems; loop | VERIFIED | Uzak teslim reddi; fiziksel teslim; uzaklaşınca süreli tamamlanma. | — |
| BLD-005 | P0 | systems/building_system.gd | systems; loop | VERIFIED | Tamamlanmamış şantiye hasarla silindi. | — |
| BLD-006 | P0 | systems/building_system.gd | systems; loop | VERIFIED | Sökümde maliyetin yarısı fiziksel loot. | Aşağı yuvarlama; açık stok ayrıca dökülür. |
| BLD-007 | P0 | systems/building_system.gd | systems; loop | VERIFIED | Yerel odun, HP artışı ve tamir cooldown testi. | 30 HP parça bazlı prototip maliyeti. |
| BLD-008 | P0 | systems/building_system.gd | systems; loop | PARTIAL | Merkez odunla manuel tamir edilir. | Otomatik tamir/robot yok; merkez tamir özel testi yok. |
| BLD-009 | P0 | systems/building_system.gd | systems; loop | VERIFIED | Oyuncu/düşman işgalinde yerleşim reddi. | Ağ doğrulaması P1. |
| BLD-010 | P0 | systems/building_system.gd | systems; loop | PARTIAL | Depo/üretim/klinik/savunma ayrı tesisler; başlangıç boş. | Bütün tesislerle cihaz kabulü yapılmadı. |
| RES-001 | P0 | core/inventory.gd; systems/player_system.gd | systems; loop | VERIFIED | Yerel stok transferi, global altın yok. | Ağ ortak kaynak yetkisi P1. |
| RES-002 | P0 | core/inventory.gd; systems/player_system.gd | systems; loop | VERIFIED | Cooldown/yenilenebilirlik; dört karakter aletsiz toplama. | Debi balans varsayımı. |
| RES-003 | P1 | core/inventory.gd; systems/player_system.gd | Offline model varsa systems/session_rules; network NOT RUN | DEFERRED | Yerel son nadir birim testi var; tam ürün sürdürülebilirliği henüz kabul edilmedi. | P1/P2 ayrı uygulama ve kabul. |
| RES-004 | P0 | core/inventory.gd; systems/player_system.gd | systems; loop | VERIFIED | Cooldown/yenilenebilirlik; dört karakter aletsiz toplama. | Debi balans varsayımı. |
| RES-005 | P0 | core/inventory.gd; systems/player_system.gd | systems; loop | VERIFIED | Mesafeli yerel transfer; uzaktan şantiye harcama engeli. | Multiplayer atomik yetki P1. |
| RES-006 | P0 | core/inventory.gd; systems/player_system.gd | systems; loop | VERIFIED | 30 küçük çanta; ağır kütük ayrı, yavaşlatır, fiziksel bırakılır. | Taşıma aracı yok; P0 elde örneği. |
| RES-007 | P0 | core/inventory.gd; systems/player_system.gd | systems; loop | VERIFIED | 60 kapasiteli depo; yıkımda yarı fiziksel loot. | Kapasite/kayıp balans varsayımı. |
| RES-008 | P0 | core/inventory.gd; systems/player_system.gd | systems; loop | VERIFIED | 60 kapasiteli depo; yıkımda yarı fiziksel loot. | Kapasite/kayıp balans varsayımı. |
| RES-009 | P1 | core/inventory.gd; systems/player_system.gd | Offline model varsa systems/session_rules; network NOT RUN | DEFERRED | Gerçek ağ/cihaz/servis kabulü yok. | P1/P2 ayrı uygulama ve kabul. |
| PRD-001 | P0 | systems/production_system.gd; systems/logistics_system.gd | systems; loop | VERIFIED | Toplanan cevher → metal → mühimmat → kule geçti. | Temsilî iki aşama; tam çağ içerikleri yok. |
| PRD-002 | P0 | systems/production_system.gd; systems/logistics_system.gd | systems; loop | VERIFIED | Sabit reçete; açlık/dolu çıktı durması; HP ile verim. | İzabe/mühimmat/elektrikli örnekler testli. |
| PRD-003 | P0 | systems/production_system.gd; systems/logistics_system.gd | systems; loop | VERIFIED | Sabit reçete; açlık/dolu çıktı durması; HP ile verim. | İzabe/mühimmat/elektrikli örnekler testli. |
| PRD-004 | P0 | systems/production_system.gd; systems/logistics_system.gd | systems; loop | VERIFIED | Sabit reçete; açlık/dolu çıktı durması; HP ile verim. | İzabe/mühimmat/elektrikli örnekler testli. |
| PRD-005 | P0 | systems/production_system.gd; systems/logistics_system.gd | systems; loop | VERIFIED | Paralel izabe ve fiziksel upgrade. | 3 seviye. |
| PRD-006 | P0 | systems/production_system.gd; systems/logistics_system.gd | systems; loop | VERIFIED | 10 ve öncesi akış yok; 11 fiziksel paket/varış testi. | Tek kaynak/alıcı örneği; Android UI testi yok. |
| PRD-007 | P1 | systems/production_system.gd; systems/logistics_system.gd | Offline model varsa systems/session_rules; network NOT RUN | DEFERRED | Gerçek ağ/cihaz/servis kabulü yok. | P1/P2 ayrı uygulama ve kabul. |
| PRD-008 | P1 | systems/production_system.gd; systems/logistics_system.gd | Offline model varsa systems/session_rules; network NOT RUN | DEFERRED | Gerçek ağ/cihaz/servis kabulü yok. | P1/P2 ayrı uygulama ve kabul. |
| PRD-009 | P0 | systems/production_system.gd; systems/logistics_system.gd | systems; loop | PARTIAL | Yakın yapı bilgisi/komutları; global yönetim paneli yok. | Bütün uzak HUD komut yolları özel testli değil. |
| PRD-010 | P0 | systems/production_system.gd; systems/logistics_system.gd | systems; loop | NOT IMPLEMENTED | Uzak kritik tesis yön alarmı uygulanmadı. | Eşik/süre/yön sistemi eklenmeli. |
| PWR-001 | P0 | systems/power_graph.gd | systems | VERIFIED | Yakıtlı izabe; iki ağ, kesinti, overload ve yük azaltarak dönüş. | Ağ uçları fixture; Android Bağla kabulü yok. |
| PWR-002 | P0 | systems/power_graph.gd | systems | VERIFIED | Yakıtlı izabe; iki ağ, kesinti, overload ve yük azaltarak dönüş. | Ağ uçları fixture; Android Bağla kabulü yok. |
| PWR-003 | P0 | systems/power_graph.gd | systems | VERIFIED | Yakıtlı izabe; iki ağ, kesinti, overload ve yük azaltarak dönüş. | Ağ uçları fixture; Android Bağla kabulü yok. |
| PWR-004 | P0 | systems/power_graph.gd | systems | VERIFIED | Yakıtlı izabe; iki ağ, kesinti, overload ve yük azaltarak dönüş. | Ağ uçları fixture; Android Bağla kabulü yok. |
| CBT-001 | P0 | systems/player_system.gd; systems/combat_system.gd | systems; scene | PARTIAL | Sentetik iki touch ID ve tam yönde mermi testli. | Fiziksel iki parmak/aim kabulü yapılmadı. |
| CBT-002 | P0 | systems/player_system.gd; systems/combat_system.gd | systems; scene | PARTIAL | Dört ayrı melee/skill; Ada skill cooldown testli. | Diğer üç skill davranışı için ek test gerekli. |
| CBT-003 | P1 | systems/player_system.gd; systems/combat_system.gd | Offline model varsa systems/session_rules; network NOT RUN | DEFERRED | Gerçek ağ/cihaz/servis kabulü yok. | P1/P2 ayrı uygulama ve kabul. |
| CBT-004 | P0 | systems/player_system.gd; systems/combat_system.gd | systems; scene | PARTIAL | Dört karakter topluyor; ortak savaş/inşa/tamir kullanır. | Her profille her eylemin ayrı testi yok. |
| CBT-005 | P0 | systems/player_system.gd; systems/combat_system.gd | systems; scene | VERIFIED | Yay/saçmalı iki slota takılır; şarjör/yedek/reload testi. | Silah içeriği sınırlı. |
| CBT-006 | P0 | systems/player_system.gd; systems/combat_system.gd | systems; scene | VERIFIED | Yay/saçmalı iki slota takılır; şarjör/yedek/reload testi. | Silah içeriği sınırlı. |
| CBT-007 | P0 | systems/player_system.gd; systems/combat_system.gd | systems; scene | PARTIAL | Parça reçetesi; yalnız çalışan yakın atölyede modifiye testi. | Ayrı namlu/optik yok; tek ortak hasar seviyesi. |
| CBT-008 | P0 | systems/player_system.gd; systems/combat_system.gd | systems; scene | VERIFIED | Atışta dayanıklılık veya bakım sistemi yok. | Ammo tüketimi sürer. |
| CBT-009 | P0 | systems/player_system.gd; systems/combat_system.gd | systems; scene | PARTIAL | Ayrı dodge/skill; melee slot; bağımsız sentetik analog bırakma. | Gerçek Android çoklu dokunma testi yok. |
| CBT-010 | P0 | systems/player_system.gd; systems/combat_system.gd | systems; scene | PARTIAL | Can otomatik/malzeme manuel testli; silah kuşanma ayrı. | Çağa uygun silah loot tablosu yok. |
| CBT-011 | P0 | systems/player_system.gd; systems/combat_system.gd | systems; scene | PARTIAL | Düşük heal/speed/ore loot; hız süre yeniler, birikmez. | Çağ loot havuzları ve olasılık testi yok. |
| CBT-012 | P0 | systems/player_system.gd; systems/combat_system.gd | systems; scene | VERIFIED | Sürünme/kan kaybı; etkili kısa melee ve mermili ranged. | Erken takım kurtarması gerçek co-op P1. |
| CBT-013 | P1 | systems/player_system.gd; systems/combat_system.gd | Offline model varsa systems/session_rules; network NOT RUN | DEFERRED | Roster/rejoin/klinik süre offline modeli testli; gerçek ağ testi değil. | P1/P2 ayrı uygulama ve kabul. |
| CBT-014 | P0 | systems/player_system.gd; systems/combat_system.gd | systems; scene | VERIFIED | Çalışan klinik/medkit ayrı; hasarlı klinik reddi. | Yerel klinik odun tüketir. |
| ENM-001 | P0 | systems/enemy_system.gd; systems/wave_system.gd | systems; loop | PARTIAL | Normal/runner/siege/sabotaj/boss; siege ve sabotaj testli. | Boss yalnız yüksek HP/hasar; yardımcı faz yok. |
| ENM-002 | P0 | systems/enemy_system.gd; systems/wave_system.gd | systems; loop | VERIFIED | Duvar kırma; uzaktakini bilmeyen, yakın üretime giden sabotajcı. | Basit grid AI; büyük yük/perf testi yok. |
| ENM-003 | P0 | systems/enemy_system.gd; systems/wave_system.gd | systems; loop | VERIFIED | Duvar kırma; uzaktakini bilmeyen, yakın üretime giden sabotajcı. | Basit grid AI; büyük yük/perf testi yok. |
| ENM-004 | P0 | systems/enemy_system.gd; systems/wave_system.gd | systems; loop | VERIFIED | 5. bölüm siege, 10. bölüm boss gerçek spawn testi. | Boss tam faz içeriği eksik. |
| ENM-005 | P0 | systems/enemy_system.gd; systems/wave_system.gd | systems; loop | PARTIAL | Aynı boss ID, farklı retry alt-seed testi. | boss_phase saklanır ama davranış değiştirmez. |
| ENM-006 | P0 | systems/enemy_system.gd; systems/wave_system.gd | systems; loop | VERIFIED | İlk ana saldırı temizlenince bölüm 2; ayrı küçük baskın sayacı. | Beş doğal dalga oynama kanıtı yok. |
| ENM-007 | P1 | systems/enemy_system.gd; systems/wave_system.gd | Offline model varsa systems/session_rules; network NOT RUN | DEFERRED | Gerçek ağ/cihaz/servis kabulü yok. | P1/P2 ayrı uygulama ve kabul. |
| SAV-001 | P0 | systems/save_system.gd; session.gd | systems; loop; scene | VERIFIED | 5. saldırı geçişi checkpoint sinyali; tam dosya roundtrip. | 5. saldırı temizliği fixture; savaş dengesi kabulü değil. |
| SAV-002 | P0 | systems/save_system.gd; session.gd | systems; loop; scene | VERIFIED | Tam Variant/RNG eşitliği; retry yeni seed; ayrı suspend/checkpoint. | Yerel hash/rename; P1 server rollback değil. |
| SAV-003 | P0 | systems/save_system.gd; session.gd | systems; loop; scene | VERIFIED | Solo ölüm, retry/yeni oturum; yenilgide suspend geçersiz. | Takım oylaması P1. |
| SAV-004 | P1 | systems/save_system.gd; session.gd | Offline model varsa systems/session_rules; network NOT RUN | DEFERRED | Gerçek ağ/cihaz/servis kabulü yok. | P1/P2 ayrı uygulama ve kabul. |
| SAV-005 | P1 | systems/save_system.gd; session.gd | Offline model varsa systems/session_rules; network NOT RUN | DEFERRED | Gerçek ağ/cihaz/servis kabulü yok. | P1/P2 ayrı uygulama ve kabul. |
| SAV-006 | P1 | systems/save_system.gd; session.gd | Offline model varsa systems/session_rules; network NOT RUN | DEFERRED | Gerçek ağ/cihaz/servis kabulü yok. | P1/P2 ayrı uygulama ve kabul. |
| NET-001 | P1 | core/roster_model.gd | Offline model varsa systems/session_rules; network NOT RUN | DEFERRED | Gerçek ağ/cihaz/servis kabulü yok. | P1/P2 ayrı uygulama ve kabul. |
| NET-002 | P1 | core/roster_model.gd | Offline model varsa systems/session_rules; network NOT RUN | DEFERRED | Roster/rejoin/klinik süre offline modeli testli; gerçek ağ testi değil. | P1/P2 ayrı uygulama ve kabul. |
| NET-003 | P1 | core/roster_model.gd | Offline model varsa systems/session_rules; network NOT RUN | DEFERRED | Roster/rejoin/klinik süre offline modeli testli; gerçek ağ testi değil. | P1/P2 ayrı uygulama ve kabul. |
| NET-004 | P1 | core/roster_model.gd | Offline model varsa systems/session_rules; network NOT RUN | DEFERRED | Gerçek ağ/cihaz/servis kabulü yok. | P1/P2 ayrı uygulama ve kabul. |
| NET-005 | P1 | core/roster_model.gd | Offline model varsa systems/session_rules; network NOT RUN | DEFERRED | Gerçek ağ/cihaz/servis kabulü yok. | P1/P2 ayrı uygulama ve kabul. |
| STA-001 | P0 | core/statistics.gd | systems; scene | PARTIAL | Yerel hasar/kill/toplama/tamir; takım üretimi raporda. | Oyuncu başına üretim atfı eksik. |
| STA-002 | P0 | core/statistics.gd | systems; scene | VERIFIED | Kule hasarı ayrı; aktif süre/peak/deneme geçmişi retry’de korunur. | Doğrulanmış online rekor yok. |
| STA-003 | P0 | core/statistics.gd | systems; scene | VERIFIED | Kule hasarı ayrı; aktif süre/peak/deneme geçmişi retry’de korunur. | Doğrulanmış online rekor yok. |
| STA-004 | P1 | core/statistics.gd | Offline model varsa systems/session_rules; network NOT RUN | DEFERRED | Gerçek ağ/cihaz/servis kabulü yok. | P1/P2 ayrı uygulama ve kabul. |
| STA-005 | P2 | core/statistics.gd | Offline model varsa systems/session_rules; network NOT RUN | DEFERRED | Gerçek ağ/cihaz/servis kabulü yok. | P1/P2 ayrı uygulama ve kabul. |
| NFR-001 | P0 | session.gd; ../project.godot; ../tools/verify.py | import; startup; scene; loop | PARTIAL | Yeni sahnede gather/build/produce/defend; dört profil ve kayıt. | Bütün P0 tamamlandı iddiası yok. |
| NFR-002 | P0 | session.gd; ../project.godot; ../tools/verify.py | import; startup; scene; loop | VERIFIED | 4.7.2 import/startup/testler geçti; Compatibility ayarlı. | Android render/perf/APK testi yok. |
| NFR-003 | P0 | session.gd; ../project.godot; ../tools/verify.py | import; startup; scene; loop | PARTIAL | 151 yeni + 22 legacy kontrolü geçti. | Eksik P0 ve cihaz/ağ kapsamı tamamlanmadı. |
| NFR-004 | P1 | session.gd; ../project.godot; ../tools/verify.py | Offline model varsa systems/session_rules; network NOT RUN | DEFERRED | Gerçek ağ/cihaz/servis kabulü yok. | P1/P2 ayrı uygulama ve kabul. |
| NFR-005 | P0 | session.gd; ../project.godot; ../tools/verify.py | import; startup; scene; loop | VERIFIED | Mevcut feature branch; eski scenes/scripts aynı; main hedefli PR. | Ek A eski ayrı-repo kriteri son talimatla geçersiz. |
| SYS-007 | P0 | core/session_state.gd; session_rules.gd | systems; scene; session_rules | VERIFIED | Yeni state sıfır; fiziksel envanter; para/mana/meta yok. | Yerel prototip. |
| SYS-008 | P1 | core/session_state.gd; session_rules.gd | Offline model varsa systems/session_rules; network NOT RUN | DEFERRED | Gerçek ağ/cihaz/servis kabulü yok. | P1/P2 ayrı uygulama ve kabul. |
| SYS-009 | P0 | core/session_state.gd; session_rules.gd | systems; scene; session_rules | VERIFIED | 12 çağ sınırı ve 121+ üst çağ testi. | Altı çağın tam içerikleri P1. |
| SYS-010 | P0 | core/session_state.gd; session_rules.gd | systems; scene; session_rules | VERIFIED | Dört farklı profil, menü seçimi. | Detaylı çizim kapsam dışı. |
| BLD-011 | P0 | systems/building_system.gd | systems; loop | IMPLEMENTED UNTESTED | Çizimler açık tesis; import/startup geçti. | Çatı/görsel GPU kabulü yapılmadı. |
| BLD-012 | P0 | systems/building_system.gd | systems; loop | PARTIAL | İlk bölümde farklı maliyetli seçenekler açık. | Tüm tariflerin oynanış dengesi eksik. |
| CBT-015 | P0 | systems/player_system.gd; systems/combat_system.gd | systems; scene | VERIFIED | Sürünme/kan kaybı; etkili kısa melee ve mermili ranged. | Erken takım kurtarması gerçek co-op P1. |
| CBT-016 | P0 | systems/player_system.gd; systems/combat_system.gd | systems; scene | PARTIAL | Ayrı dodge/skill; melee slot; bağımsız sentetik analog bırakma. | Gerçek Android çoklu dokunma testi yok. |
| ENM-008 | P0 | systems/enemy_system.gd; systems/wave_system.gd | systems; loop | PARTIAL | Ana/boss 5 sn uyarı testi. | Önceden giriş yönü gösterimi eksik. |
| ENM-009 | P1 | systems/enemy_system.gd; systems/wave_system.gd | Offline model varsa systems/session_rules; network NOT RUN | DEFERRED | Gerçek ağ/cihaz/servis kabulü yok. | P1/P2 ayrı uygulama ve kabul. |
| PRD-011 | P0 | systems/production_system.gd; systems/logistics_system.gd | systems; loop | PARTIAL | Mermisiz kule susar, dolunca ateş testi; tüketimsiz tuzak kodu. | Tuzak için ayrı runtime kabulü yok. |
| NET-006 | P1 | core/roster_model.gd | Offline model varsa systems/session_rules; network NOT RUN | DEFERRED | Roster/rejoin/klinik süre offline modeli testli; gerçek ağ testi değil. | P1/P2 ayrı uygulama ve kabul. |
| SAV-007 | P1 | systems/save_system.gd; session.gd | Offline model varsa systems/session_rules; network NOT RUN | DEFERRED | Gerçek ağ/cihaz/servis kabulü yok. | P1/P2 ayrı uygulama ve kabul. |
| SAV-008 | P1 | systems/save_system.gd; session.gd | Offline model varsa systems/session_rules; network NOT RUN | DEFERRED | Gerçek ağ/cihaz/servis kabulü yok. | P1/P2 ayrı uygulama ve kabul. |
| NFR-006 | P0 | session.gd; ../project.godot; ../tools/verify.py | import; startup; scene; loop | PARTIAL | Sürükle/bırak/hızlı tekrar; ayrı world/touch bölgeleri. | Uzun basmaya özel davranış ve fiziksel Android testi yok. |
| NFR-007 | P0 | session.gd; ../project.godot; ../tools/verify.py | import; startup; scene; loop | VERIFIED | Tek oyuncu; takım botu doğmaz. | Düşman AI takım botu değildir. |
| NFR-008 | P0 | session.gd; ../project.godot; ../tools/verify.py | import; startup; scene; loop | VERIFIED | Mevcut feature branch; eski scenes/scripts aynı; main hedefli PR. | Ek A eski ayrı-repo kriteri son talimatla geçersiz. |

## Durum özeti

{'PARTIAL': 22, 'VERIFIED': 52, 'DEFERRED': 28, 'NOT IMPLEMENTED': 1, 'IMPLEMENTED UNTESTED': 1}

## Entegre senaryolar

| Senaryo | Kanıt / durum |
|---|---|
| E2E-01 | Scene/systems: menü/kamera, sentetik analog, melee/ammo/dodge; Android PARTIAL |
| E2E-02 | Loop: bütün yapı malzemeleri toplandı/taşındı/teslim edildi; uzak teslim negatif testi systems |
| E2E-03 | Systems: snap/inşa hasarı/tamir/söküm; tüm tesislerle UI kabulü PARTIAL |
| E2E-04 | Loop + systems: cevher → metal → ammo → kule; tampon/HP verimi |
| E2E-05 | Systems: 11 kilidi/hareket eden paket; Android Bağla kabulü yok |
| E2E-06 | Systems: iki ağ/kesinti/overload/geri dönüş |
| E2E-07 | Systems + loop: duvar/sabotaj, 5 elite, 10 boss; gerçek ağ DEFERRED |
| E2E-08 | Systems/scene: tam resume/RNG/retry seed; boss yardımcı faz PARTIAL |
| E2E-09 | Systems: dört kimlik kilidi/rejoin/equipment offline model; network DEFERRED |
| E2E-10 | Systems/session_rules: klinik süre modeli/solo bleedout; revive ağı DEFERRED |
| E2E-11 | Systems: ayrı hasar ve denemeler; üretim atfı/online rekor PARTIAL |
| E2E-12 | Loop: gerçek ilk dalga, ardından UNRANKED 5. bölüm checkpoint fixture. Beş doğal dalga kanıtı yok |
