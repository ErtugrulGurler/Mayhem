# Mayhem

**Godot 4.7.2 · Compatibility · Android yatay ekran.**
Kaynakları fiziksel olarak taşıdığın, üretim hattı kurup merkezi savunduğun yerel aksiyon prototipi.
Oyun içindeki rehber, ilk üretim ve savunma zincirini adım adım öğretir.

## Aç ve oyna

PR birleştirildikten sonra main dalını güncelle veya GitHub'dan ZIP indir.
Klasörü tamamen aç, kökteki project.godot dosyasını **Godot 4.7.2** ile içe aktar.
**F5 / Projeyi Çalıştır → karakter ve merkez seç → Oyuna başla.**
Rehberi görmek için yeni oturum başlat; önceki dünya kaydını korumak istiyorsan **Kayıttan devam** seç.

- Sol analog: hareket. Sağ analog: tuttuğun yöne saldırı; aim assist yok.
- Üstte: HP, merkez HP, bölüm/hazırlık süresi ve çantandaki temel kaynaklar.
- Görev kartı ve açık renk ok: sıradaki hedef. Nesne ekran dışındaysa ok o yönü gösterir.
- Alt ortadaki büyük düğme yakındaki nesneye göre **Topla**, **Teslim et** veya **Tesisi aç** olur.
- **İnşa**: tarif seç → dünyada boş alana dokun/sürükle → yeşil önizlemede **Yerleştir**.
  Şantiyeye malzeme götürmeden inşa başlamaz. Kırmızı önizleme engel/canlı/teknoloji kısıtıdır.
- **Tesisi aç**: gereken girdi, çıkan ürün, durum ve stok; yükleme, ürün alma, tamir,
  geliştirme, bağlantı ve sökme işlemleri burada. Listeleri dikey kaydırabilirsin.
- **Çanta**: silah slotu, üretilen silahı kuşanma, reload, medkit ve yük bırakma.
  Menzilli silah seçiliyken ayrıca sağ analogun üstünde hızlı **Doldur** bulunur.
- **Kaç** ve **Yetenek** ayrı düğmelerdir. Yapılar, oyuncu, düşmanlar ve kaynaklar farklı silüet kullanır.
- **Menü**: saldırıyı başlat, kaydet/ara ver, sürdür, zoom ve rehberi tekrar göster.
  Rehberde **Atla** oyunu kilitlemez; ilerleme ve tercih kayıtta korunur.
- **Menü → Geliştirici araçları**: DEBUG bölüm atlamaları. Bu oturumu UNRANKED yapar;
  normal oyuncu HUD'sinde DEBUG düğmesi yoktur.

Tarifler ve eksik malzeme bilgisi oyunun içindedir; oynamak için belge okuman gerekmez.
Kayıtlı eski P0 dünyaları açılırken yalnız eksik rehber verisi tamamlanır; dünya sıfırlanmaz.
İlk saldırı ve küçük baskınlar önceki prototipteki zamanlamalarını korur; rehber dünyayı duraklatmaz.

## Masaüstü

WASD hareket; sağ fare nişan/otomatik saldırı. E bağlamsal etkileşim,
F girdi yükle, G ürün al, T tamir, X sök, Q slot, R reload,
Space dodge, C skill, H medkit. Esc paneli kapatır veya menüyü açar.
Sol fareyle seçili nesneyi vurgulayabilir ve inşa önizlemesini konumlandırabilirsin;
**Yerleştir** ayrıca onay ister.

## Doğrulama

Linux'ta Godot 4.7.2 binary ile:

    python3 tools/verify.py --godot /path/to/Godot_v4.7.2-stable_linux.x86_64

Import, açılış, eski regresyonlar, tutorial, HUD geometri ve GUI giriş testleri çalışır.
Sonuçlar: **349 kontrol, 0 hata**. Android fiziksel cihaz testi değildir.
Kayıt dosyaları test sırasında izole XDG dizinlerinde tutulur.

- [Mobil UX revizyonu, kabul sonuçları ve görüntüler](docs/ux/REPORT.md)
- [Test komutları / çıkış kodları](docs/evidence/commands.json)
- [Genel P0 eksikleri](docs/PROTOTYPE_LIMITATIONS.md)
- [104 ürün gereksiniminin tarihsel tablosu](docs/REQUIREMENTS_TRACEABILITY.md)
- [19 Kasım mekanik referansı](docs/P0_GAMEPLAY_REFERENCE.md)

Gerçek online co-op, kapsamlı boss/çağ içerikleri ve online rekor bu prototipte yoktur.
Eski sabit yol demosu korunur ve başlangıç menüsünden açılır.
APK üretimi için 4.7.2 Android export templates, JDK ve Android SDK ayrıca gerekir.

## Kod

- core: durum, envanter, istatistik, arazi, offline roster.
- systems: savaş, üretim, inşa, fiziksel lojistik, enerji, AI, dalga ve kayıt.
- presentation: bağlamsal işlemler, tutorial gözlemcisi, mobil HUD, analoglar, özgün vektör çizimleri.
- session.gd: sahne ve komut yönlendirme. Tutorial yalnız durum gözler; kaynak vermez veya dalga kilitlemez.
