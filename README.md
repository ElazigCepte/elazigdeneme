# In-App Purchase (Google Play) Entegrasyon Notları

Bu proje `in_app_purchase` paketi ile Google Play üzerinden uygulama içi satın alma (IAP) desteği içerir.

## Yapılandırma Adımları

1. Google Play Console:
   - Uygulamanızı oluşturun/yükleyin.
   - Ürünler > Uygulama içi ürünler bölümünde ürünü tanımlayın.
   - Ürün kimliğini `lib/hesabim.dart` dosyasındaki `_kProductIds` içine ekleyin.

2. Android İzinleri:
   - Android yerel klasörleri bu repo örneğinde yer almıyor. Tam Flutter projesinde `android/app/src/main/AndroidManifest.xml` içine şu izni ekleyin:
     ```xml
     <uses-permission android:name="com.android.vending.BILLING" />
     ```

3. Flutter Başlatma:
   - `main.dart` içinde `InAppPurchase.instance.enablePendingPurchases();` çağrısı yapılır.

4. Ürün Sorgulama ve Satın Alma:
   - `lib/hesabim.dart` dosyasında ürünler sorgulanır ve satın alma akışı başlatılır.

5. Test:
   - Internal testing/closed testing ile test kullanıcıları ekleyerek gerçek mağaza akışı ile test edin.

> Not: iOS için ayrı yapılandırmalar (StoreKit, capabilities) gereklidir.
