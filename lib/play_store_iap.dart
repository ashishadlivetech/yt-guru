import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:project1/theme_controller.dart';

import 'button_styles.dart';
import 'controllers/mobile_controler.dart' show AuthController;
import 'controllers/user_controller.dart' show UserController;

class PlayStoreIAPPage extends StatefulWidget {
  @override
  State<PlayStoreIAPPage> createState() => _PlayStoreIAPPageState();

}

class _PlayStoreIAPPageState extends State<PlayStoreIAPPage> {
  final InAppPurchase _iap = InAppPurchase.instance;
  final ThemeController themeController = Get.find();
  final UserController userController = Get.find();

  final AuthController authController =
  Get.find();


  bool _isAvailable = false;
  List<ProductDetails> _products = [];
  String _productId = 'coins_100'; // Replace with your Play Console product ID
  int _coins = 0;
  final Map<String, int> skuToCoins = {
    'coins_100': 3000,
    'coins_10k': 10000,
    'coins_50k': 50000,
    'coins_2.5l': 250000,
    'coins_5l': 500000,
    'coins_1c': 1000000,
    'coin_2l': 2000000,
  };



  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    _isAvailable = await _iap.isAvailable();
    if (!_isAvailable) {
      print('IAP NOT AVAILABLE');
      return;
    }
    final Set<String> _kProductIds = skuToCoins.keys.toSet();

    final response = await _iap.queryProductDetails(_kProductIds);
    if (response.notFoundIDs.isNotEmpty) {
      print('Product not found: $_productId');
      return;
    }
    final sortedProducts = response.productDetails.toList()
      ..sort((a, b) => a.rawPrice.compareTo(b.rawPrice));

    setState(() {
      _products = sortedProducts;
    });

    _iap.purchaseStream.listen((purchases) {
      for (final PurchaseDetails purchase in purchases) {
        if (purchase.status == PurchaseStatus.purchased) {
          _deliverProduct(purchase);
          _iap.completePurchase(purchase);
        } else if (purchase.status == PurchaseStatus.error) {
          print('Purchase error: ${purchase.error}');
        }
      }
    });
  }

  void _buyProduct(ProductDetails product) {
    final param = PurchaseParam(productDetails: product);
    _iap.buyConsumable(purchaseParam: param);
  }

  Future<void> _deliverProduct(PurchaseDetails purchase) async {

    try {
      // ✅ Call your backend API after confirming subscription
      final String email = authController.email.value;
      final apiResponse = await http.post(
        Uri.parse('https://indianradio.in/yt-social-api/v1'),

        body: {
          'method': 'credit_coin',
          // 'mobile_number': mobileNumber
          'email': email,
          'point_to_be_credit': skuToCoins[purchase.productID].toString()
        },

      );

      if (apiResponse.statusCode == 200) {

        await userController.fetchUserData(
            forceRefresh: true);
        setState(() {});
        Navigator.pop(context,true);
        print("Backend API success: ${apiResponse.body}");
      } else {
        print("Backend API failed: ${apiResponse.body}");

      }
    } catch (e) {
      print("Error calling backend API: $e");

    }

    setState(() {
      _coins += 100; // Example: add 100 coins
    });
    print('Coins delivered! Total coins: $_coins');
    // ✅ Ideally verify receipt with your server here too.
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text('Buy Points',
            style: TextStyle(
                color:
                themeController.isDarkMode ? Colors.white : Colors.black)),
        centerTitle: true,
        backgroundColor:
        themeController.isDarkMode ? Colors.black : Colors.grey,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: themeController.isDarkMode ? Colors.white : Colors.black,
          ), // White back icon
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Row(
            children: [
              Obx(() => Text(
                userController
                    .userPoints.value, // 🔹 Display dynamic points
                style: TextStyle(
                  color: themeController.isDarkMode
                      ? Colors.white
                      : Colors.black,
                  fontSize: 16,
                ),
              )),
              SizedBox(width: 5),
              Icon(Icons.favorite,
                  color:
                  themeController.isDarkMode ? Colors.white : Colors.black),
              SizedBox(width: 10),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'For your problems and questions, contact info.ytgroup@gmail.com',
              style: TextStyle(
                fontSize: 14,
                color: themeController.isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: themeController.isDarkMode
                          ? Color(0xFF131225)
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: themeController.isDarkMode
                              ? Colors.black.withOpacity(0.5)
                              : Colors.white.withOpacity(0.5),
                          blurRadius: 5,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite,
                            color: themeController.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            size: 40),
                        SizedBox(height: 8),
                        Text(
                          product.description,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: themeController.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                            child: ElevatedButton(
                              onPressed: () => _buyProduct(product),
                              child: Text('Buy for ${product.price}'),
                            ),
                          ),
                      ],
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
