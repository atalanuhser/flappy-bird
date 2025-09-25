# Flappy Bird Web App

Bu proje, klasik Flappy Bird oyununu ASP.NET Web Forms (.NET Framework 4.7.2) üzerinde web tabanlı olarak sunar. Kullanıcılar tarayıcıda oyunu oynayabilir, skorlarını kaydedebilir ve en iyi skorları görebilirler.

## Özellikler

- **Modern Web Arayüzü:** Responsive ve mobil uyumlu tasarım, dinamik arka plan ve animasyonlar.
- **Oyun Mekanikleri:** Mouse tıklaması veya klavye (boşluk/ok tuşları) ile kuşu zıplatma, borulardan geçme, skor takibi.
- **Skor Yönetimi:** Oyuncu adı ile skor kaydı, en iyi skorların listelenmesi, skorların temizlenmesi.
- **Sunucu Tarafı:** Skorlar oturum bazlı saklanır, GridView ile en iyi 20 skor gösterilir.
- **Güvenlik:** Oyuncu adı için temel karakter ve uzunluk doğrulaması, injection koruması.
- **Kullanıcı Deneyimi:** Oyun bittiğinde skor paneli, tekrar oynama butonu, anlık skor güncellemesi.

## Dosya Yapısı

- `Default.aspx`: Oyun arayüzü ve JavaScript tabanlı oyun motoru.
- `Default.aspx.cs`: Skor yönetimi, doğrulama, sunucu tarafı işlemler.
- `App_Data/`: (Varsa) Ek veri dosyaları.
- `README.md`: Proje açıklaması ve kullanım talimatları.

## Kurulum ve Çalıştırma

1. **Gereksinimler:**  
   - Visual Studio 2022  
   - .NET Framework 4.7.2

2. **Projeyi Açın:**  
   Visual Studio ile projeyi açın.

3. **Çalıştırın:**  
   `Default.aspx` dosyasını tarayıcıda açarak oyunu oynayabilirsiniz.

## Oyun Nasıl Oynanır?

- **Başlat:** "Oyunu Başlat" butonuna tıklayın.
- **Kontroller:** Mouse ile tıklayın veya boşluk/ok tuşlarına basarak kuşu zıplatın.
- **Amaç:** Kuşu boruların arasından geçirin ve en yüksek skoru elde edin.
- **Skor Kaydı:** Oyun bitince adınızı girip skorunuzu kaydedebilirsiniz.
- **Skor Tablosu:** En iyi 20 skor listelenir. Tüm skorları temizleyebilirsiniz.

## Teknik Detaylar

- **JavaScript ile Oyun Motoru:**  
  Oyun mantığı, animasyon ve skor takibi tamamen istemci tarafında JavaScript ile yapılır.
- **ASP.NET Web Forms:**  
  Skor kaydı ve listeleme sunucu tarafında yönetilir. Oturum bazlı skor saklama kullanılır.
- **GridView:**  
  Skorlar tablo halinde gösterilir.
- **Güvenlik:**  
  Oyuncu adı için geçersiz karakter ve uzunluk kontrolü yapılır.


---

**Hazırlayan:**  
GitHub Copilot
