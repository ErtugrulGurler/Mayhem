# Mayhem Phase 0 – Ludo Asker Animasyon Testi

Bu sürüm orijinal Faz 0 hareket/kamera sistemini bozmadan, **Ludo'dan alınan 4 yönlü koşma ve yumruklama animasyonlarını** test etmek içindir.

Kaynak: `MayhemAsker_Godot.zip` (kullanıcının sağladığı paket). Pakette 4 yön × koşma/yumruk, her animasyonda 9 kare vardır. Ludo ücretsiz dışa aktarımında filigran kalabilir.

## Telefon (Godot Android editor)

- ZIP dosyası Android'in `Download` klasöründe **MayhemAsker_Godot.zip** adıyla durmalı.
- Güncelle: `cd /storage/emulated/0/GodotProjects/Mayhem && git pull --ff-only origin main`
- Godot'ta `prototypes/phase0/project.godot` projesini çalıştır.
- Sol joystick hareket ettirir, sağ joystick yön seçer; **YUMRUK** butonu bir kez animasyonu oynatır.
- Animasyonların yalnızca **4 yönü** var. Çapraz yürüyüşlerde en yakın sağ/sol görüntüsü gösterilir.

`character_visual.gd` çalışırken ZIP'i otomatik okur, PNG'leri bellek içinde yarı çözünürlüğe indirir. **ZIP bulunamazsa önceki 8 yönlü asker grafiklerine döner.** Android dosya erişim izinleri ZIP'i okumayı engellerse ZIP'i `prototypes/phase0/MayhemAsker_Godot.zip` yoluna kopyalayın.

Not: GitHub'da yalnızca yükleyici ve test kodu vardır; **Ludo'nun yaklaşık 30 MB ZIP varlığı repoya eklenmemiştir**. Reponun tamamen bağımsız çalışması için animasyon varlıklarının ayrıca repoya yüklenmesi gerekir.
