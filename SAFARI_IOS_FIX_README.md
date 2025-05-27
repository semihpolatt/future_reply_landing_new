# Safari iOS Viewport Fix

Bu proje, Safari'nin iOS'ta tarayıcı çubuğunun alta taşınması ve viewport yüksekliği değişiklikleri ile ilgili sorunları çözmek için çeşitli teknikler kullanır.

## Sorun

Safari'nin iOS 15+ sürümlerinde:
- Tarayıcı çubuğu varsayılan olarak altta konumlanır
- Scroll sırasında viewport yüksekliği dinamik olarak değişir
- `100vh` CSS birimi tarayıcı çubuğunu hesaba katmaz
- Bu durum layout'ta istenmeyen boşluklar ve örtüşmeler yaratır

## Uygulanan Çözümler

### 1. CSS Viewport Units Çözümü

**Dosya:** `web/index.html` ve `web/safari-ios-fix.css`

```css
/* Yeni viewport birimlerini kullan */
@supports (height: 100svh) {
  :root {
    --viewport-height: 100svh; /* Small viewport height */
  }
}

@supports (height: 100dvh) {
  :root {
    --viewport-height: 100dvh; /* Dynamic viewport height */
  }
}
```

**Açıklama:**
- `100svh`: Tarayıcı çubukları görünür olduğunu varsayar
- `100dvh`: Tarayıcı çubuklarının durumuna göre dinamik olarak adapte olur
- `@supports` ile progressive enhancement sağlanır

### 2. JavaScript Fallback

**Dosya:** `web/index.html`

```javascript
function setViewportHeight() {
  const vh = window.innerHeight * 0.01;
  document.documentElement.style.setProperty('--vh', `${vh}px`);
  
  if (window.innerHeight !== window.outerHeight) {
    document.documentElement.style.setProperty('--viewport-height', `${window.innerHeight}px`);
  }
}
```

**Açıklama:**
- Eski tarayıcılar için fallback
- `window.innerHeight` kullanarak gerçek viewport yüksekliğini hesaplar
- Resize ve orientation change eventlerini dinler

### 3. Flutter Widget Düzeyinde Çözümler

**Dosyalar:** `lib/home.dart` ve `lib/widgets/chat_input_area.dart`

```dart
// Mobile Safari tespiti
bool _isMobileSafari() {
  try {
    final userAgent = html.window.navigator.userAgent;
    return userAgent.contains('Safari') && 
           userAgent.contains('Mobile') && 
           !userAgent.contains('Chrome');
  } catch (e) {
    return false;
  }
}

// Özel padding hesaplaması
double bottomPadding = isMobileSafari ? 80.0 : 50.0;
```

**Açıklama:**
- User agent ile mobile Safari tespiti
- Safari için özel padding ve margin değerleri
- `SafeArea` widget'ı ile güvenli alan yönetimi
- `ConstrainedBox` ile minimum yükseklik garantisi

### 4. Meta Tag Optimizasyonları

**Dosya:** `web/index.html`

```html
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
```

**Açıklama:**
- `viewport-fit=cover`: Safe area insets kullanımını etkinleştirir
- `user-scalable=no`: Zoom'u devre dışı bırakır
- `black-translucent`: Status bar'ı şeffaf yapar

## Cihaz Spesifik Çözümler

### iPhone Modelleri için Özel CSS

```css
/* iPhone X, XS */
@media screen and (device-width: 375px) and (device-height: 812px) {
  :root {
    --safe-bottom-padding: 34px;
  }
}

/* iPhone 12, 12 Pro */
@media screen and (device-width: 390px) and (device-height: 844px) {
  :root {
    --safe-bottom-padding: 34px;
  }
}
```

## Safe Area Insets

```css
:root {
  --safe-area-inset-top: env(safe-area-inset-top, 0px);
  --safe-area-inset-bottom: env(safe-area-inset-bottom, 0px);
  --safe-area-inset-left: env(safe-area-inset-left, 0px);
  --safe-area-inset-right: env(safe-area-inset-right, 0px);
}
```

## Test Etme

1. **iOS Safari'de test edin:**
   - Tarayıcı çubuğunu alta taşıyın (Safari ayarları)
   - Scroll yaparak çubuğun gizlenip gösterilmesini test edin
   - Text field'lara focus olduğunda keyboard'un çıkmasını test edin

2. **Farklı iPhone modellerinde test edin:**
   - Notch'lu modeller (iPhone X+)
   - Notch'suz modeller (iPhone 8-)
   - Farklı ekran boyutları

3. **Orientation değişikliklerini test edin:**
   - Portrait ↔ Landscape geçişleri
   - Layout'un doğru adapte olmasını kontrol edin

## Tarayıcı Desteği

- **iOS Safari 15+**: Tam destek (dvh/svh units)
- **iOS Safari 13-14**: JavaScript fallback ile destek
- **Chrome Mobile**: Otomatik olarak çalışır
- **Firefox Mobile**: Otomatik olarak çalışır

## Performans Notları

- CSS çözümleri JavaScript'ten daha performanslı
- `@supports` ile progressive enhancement kullanılır
- Event listener'lar throttle edilmiş
- Sadece gerekli durumlarda JavaScript devreye girer

## Gelecek Güncellemeler

- CSS `@container` queries desteği eklenebilir
- Yeni viewport units (`lvh`, `svh`, `dvh`) için daha geniş destek
- PWA mode için ek optimizasyonlar

## Kaynaklar

- [CSS Viewport Units](https://developer.mozilla.org/en-US/docs/Web/CSS/length#viewport-percentage_lengths)
- [Safe Area Insets](https://developer.mozilla.org/en-US/docs/Web/CSS/env)
- [iOS Safari Viewport Bug](https://bugs.webkit.org/show_bug.cgi?id=141832)
- [Flutter Web iOS Issues](https://github.com/flutter/flutter/issues/95010) 