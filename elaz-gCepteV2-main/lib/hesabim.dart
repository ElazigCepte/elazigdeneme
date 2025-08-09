import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class HesabimPage extends StatefulWidget {
  const HesabimPage({super.key});

  @override
  State<HesabimPage> createState() => _HesabimPageState();
}

class _HesabimPageState extends State<HesabimPage> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  bool _storeAvailable = false;
  bool _loading = true;
  List<ProductDetails> _products = <ProductDetails>[];
  String? _error;

  static const Set<String> _kProductIds = {
    'premium_account', // Google Play Console'da oluşturduğunuz ürün kimliğiyle eşleştirin
  };

  @override
  void initState() {
    super.initState();
    _initialize();
    _subscription = _inAppPurchase.purchaseStream.listen(
      _onPurchaseUpdated,
      onError: (Object error) {
        setState(() {
          _error = 'Satın alma akışında hata: $error';
        });
      },
      onDone: () {
        _subscription?.cancel();
      },
    );
  }

  Future<void> _initialize() async {
    try {
      final bool available = await _inAppPurchase.isAvailable();
      if (!mounted) return;
      if (!available) {
        setState(() {
          _storeAvailable = false;
          _loading = false;
          _error = 'Mağaza kullanılamıyor.';
        });
        return;
      }

      final ProductDetailsResponse response =
          await _inAppPurchase.queryProductDetails(_kProductIds);

      if (!mounted) return;
      if (response.error != null) {
        setState(() {
          _error = 'Ürün sorgulama hatası: ${response.error}';
          _loading = false;
        });
        return;
      }

      setState(() {
        _storeAvailable = true;
        _products = response.productDetails;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Başlatma hatası: $e';
        _loading = false;
      });
    }
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Satın alma beklemede...')),
            );
          }
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Satın alma başarılı!')),
            );
          }
          break;
        case PurchaseStatus.error:
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Satın alma hatası: ${purchaseDetails.error}')),
            );
          }
          break;
        case PurchaseStatus.canceled:
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Satın alma iptal edildi')),
            );
          }
          break;
        default:
          break;
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  Future<void> _buy(ProductDetails product) async {
    final PurchaseParam param = PurchaseParam(productDetails: product);
    await _inAppPurchase.buyNonConsumable(purchaseParam: param);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hesabım')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : !_storeAvailable
              ? Center(child: Text(_error ?? 'Mağaza kullanılamıyor.'))
              : _products.isEmpty
                  ? Center(
                      child: Text(
                        _error ?? 'Satın alınabilir ürün bulunamadı. Lütfen ürün kimliğini Play Console ile eşleştirin.',
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.person_add),
                            label: const Text('Hesap Ekle ve Satın Al'),
                            onPressed: () async {
                              final ProductDetails first = _products.first;
                              await _buy(first);
                            },
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.separated(
                              itemCount: _products.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 12),
                              itemBuilder: (BuildContext context, int index) {
                                final ProductDetails p = _products[index];
                                return Card(
                                  child: ListTile(
                                    title: Text(p.title),
                                    subtitle: Text(p.description),
                                    trailing: ElevatedButton(
                                      onPressed: () => _buy(p),
                                      child: Text(p.price),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
