import 'package:flutter/material.dart';
import 'package:pay_tag_tab/screens/product_details/product_details_controller.dart';
import 'package:pay_tag_tab/screens/product_details/product_slider.dart';
import 'package:pay_tag_tab/screens/welcome_screen.dart';
import 'package:pay_tag_tab/services/websocket_service_new.dart';
import 'package:pay_tag_tab/utils/mixins/connection_status_handler.dart';
import 'package:pay_tag_tab/widget/description.dart';
import 'package:pay_tag_tab/widget/logo_new_blue.dart';
import 'package:provider/provider.dart';

class NotPaidAndMissingProductsScreen extends StatefulWidget {
  final List<ProductDetails> responseProductData;
  final List<ProductDetails> missingProducts;

  const NotPaidAndMissingProductsScreen({
    super.key,
    required this.responseProductData,
    required this.missingProducts,
  });

  @override
  NotPaidAndMissingProductsScreenState createState() =>
      NotPaidAndMissingProductsScreenState();
}

class NotPaidAndMissingProductsScreenState
    extends State<NotPaidAndMissingProductsScreen>
    with ConnectionStatusHandler<NotPaidAndMissingProductsScreen> {
  void _sendMessage() {
    final websocketService =
        Provider.of<WebSocketService>(context, listen: false);
    websocketService.sendMessage('COLLECTED THE BAG');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height; 
    final safeAreaInsets = mediaQuery.viewInsets;
    final safeAreaWidth = screenWidth - safeAreaInsets.left - safeAreaInsets.right;
    final safeAreaHeight = screenHeight - safeAreaInsets.top - safeAreaInsets.bottom;

    List<ProductDetails> products = widget.responseProductData;
    List<ProductDetails> missing = widget.missingProducts;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const PaytagLogo(),
            SizedBox(height: screenHeight * 0.0092),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                // height: 400, // Fixed height for the Row
                height: screenHeight * 0.420, // Fixed height for the Row
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Left Section: Missing Products
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 1097,
                            height: 62,
                            alignment: Alignment.center,
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontSize: 44,
                                  fontWeight: FontWeight.w400,
                                  height: 61.6 / 44,
                                  letterSpacing: 0.01,
                                  color: Colors.black,
                                ),
                                children: [
                                  const TextSpan(text: 'You have '),
                                  TextSpan(
                                    text: '${missing.length} ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const TextSpan(text: 'missing products:'),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.0620),
                          Expanded(
                            child: ProductSlider(
                              products: missing,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Separator
                    Container(
                      height: 380,
                      width: 2,
                      color: Colors.grey.shade400,
                    ),

                    // Right Section: Unpaid Products
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 1097,
                            height: 62,
                            alignment: Alignment.center,
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontSize: 44,
                                  fontWeight: FontWeight.w400,
                                  height: 61.6 / 44,
                                  letterSpacing: 0.01,
                                  color: Colors.black,
                                ),
                                children: [
                                  const TextSpan(text: 'You have '),
                                  TextSpan(
                                    text: '${products.length} ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const TextSpan(
                                      text: 'unpaid products in your bag:'),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.0620),
                          Expanded(
                            child: ProductSlider(products: products),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.040),
            const PaytagDescription(
              descriptionText:
                  'Please pay for all products using the Paytag App and add missing products before proceeding.',
              descriptionWidthPixels: 1097,
              descriptionHeightPixels: 124,
              descriptionFontWeight: FontWeight.w400,
              descriptionFontSize: 44,
              descriptionFontLineHeight: 61.6,
              descriptionFontLetter: 1,
            ),
            SizedBox(height: screenHeight * 0.040),
            ElevatedButton(
              onPressed: _sendMessage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(22, 72, 121, 1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 22,
                ),
                textStyle: const TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 24,
                ),
              ),
              child: const Text('Re-scan'),
            ),
          ],
        ),
      ),
    );
  }
}
