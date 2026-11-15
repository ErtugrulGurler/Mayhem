# Mayhem — oyun gereksinimleri

## Ürün ve çalışma kuralları
- Tasarımı ve gereksinimleri kullanıcı belirler; kod ve proje dosyaları geliştirici tarafından doğrudan GitHub reposunda hazırlanır.
- Türkçe iletişim, kodda İngilizce isimlendirme.
- Hedef Godot **4.7.2**, GDScript, Compatibility renderer.
- Öncelik Android telefon, yatay ekran, farklı çözünürlükler ve dokunmatik; masaüstünde fare desteği.
- Kingdom Rush benzeri, renkli ve sevimli çizgi film estetiğinde kule savunması; pixel art değil.
- Önce tek haritalı oynanabilir prototip; modüler, sürdürülebilir ve genişletilebilir mimari.
- Ücretli servis ve dışarıdan indirilen asset kullanılmaz; mevcut çalışan özellikler korunur.
- Teknik kararlar gereksiz onay istemeden alınır. Test edilmemiş özellikler test edilmiş gibi sunulmaz.
- Ayrı Git branch, commit ve main hedefli Pull Request; kısa Türkçe sonuç raporu.

## İlk sürüm
1. Yeşil zemin, kıvrımlı düşman yolu, ağaçlar, taşlar ve küçük çevre detayları.
2. Yol başında doğup sona ilerleyen normal, hızlı/düşük canlı, yavaş/yüksek canlı üç düşman.
3. Belirlenmiş noktalara dokunarak farklı maliyet ve özelliklerde okçu, büyücü ve topçu kuleleri kurma. Menzilde otomatik saldırı.
4. Görünür mermiler, hasar, ölüm ve basit tatmin edici vuruş animasyonu/efekti.
5. Öldürmelerden altın; altınla inşa ve kule başına toplam üç seviye.
6. Gittikçe zorlaşan dalgalar; kaçan düşmanın oyuncu canını azaltması; sıfır canda oyun sonu ve yeniden başlatma.
7. Altın, can, dalga ve yükseltme seçeneklerini gösteren, telefon kullanımına uygun arayüz.
8. Geometrik ama çizgi film görünümünde grafikler; daha sonra sprite ve karakter animasyonlarıyla değiştirilebilir görseller.
9. Ana sahne, Android yatay ekran ve çözünürlük ölçeklendirmesi; mümkün olduğunca ayrı görsel ve oyun mantığı.
10. Godot CLI varsa headless kontrol; araç/sürüm eksikleri açıkça raporlanır.

## Gelecek hedefleri — bu sürümde geliştirilmez
- Kontrol edilebilir kahramanlar ve karakter değiştirme.
- Özel yetenekler ve uçma mekanikleri.
- Boss savaşları; yaratıcı ve komik saldırılar.
- 2–4 kişilik online multiplayer.
- Karakter gelişimi ve kalıcı ilerleme.

## Prototip kararları
- Bir harita, dokuz inşa noktası, 240 başlangıç altını, 20 can.
- Her dalga oyuncunun düğmesiyle başlar; arada sınırsız hazırlık zamanı.
- Sonsuz dalga modu: sayı, can ve hız yükselir; hızlı düşman ikinci, tank üçüncü dalgada katılır.
- Seviye 1–3; yükseltmeler hasar, menzil ve atış hızını iyileştirir.
- Büyücü güçlü tek hedef; topçu alan hasarı; okçu sık atış.
- Başka kaynak gerektirmeyen vektörel çizimler.
- 960×540 referans görünümü, oranı koruyan ölçekleme; geniş telefonlarda kenar boşluğu.
- Ses, kayıt, kahraman, multiplayer, boss ve sprite animasyonu bu prototipin kapsamı dışındadır.
