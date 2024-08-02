import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pay_tag_tab/screens/process_tags/hold_in_tub_for_three_sec_screen.dart';
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
  final List<dynamic>? responseInputTagIds;

  const NotPaidAndMissingProductsScreen({
    super.key,
    required this.responseProductData,
    required this.missingProducts, 
    this.responseInputTagIds,
  });

  @override
  NotPaidAndMissingProductsScreenState createState() =>
      NotPaidAndMissingProductsScreenState();
}

class NotPaidAndMissingProductsScreenState
    extends State<NotPaidAndMissingProductsScreen>
    with ConnectionStatusHandler<NotPaidAndMissingProductsScreen> {

  late StreamSubscription<String> _messageSubscription;

  @override
  void initState() {
    super.initState();
    final websocketService =
        Provider.of<WebSocketService>(context, listen: false);

    try {
      _messageSubscription = websocketService.messageStream.listen((message) {
        final jsonData = jsonDecode(message) as Map<String, dynamic>;
        if (jsonData['message'] != null &&
            jsonData['message'].contains('NO ITEM IN CART - OTHER SCREEN')) {
          websocketService.sendMessage('COLLECTED THE BAG');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          );
        }
      });
    } catch (e) {
      print('WebSocket connection error: $e');
    }
  }

  @override
  void dispose() {
    _messageSubscription.cancel();
    super.dispose();
  }

  void _sendCancelMessage() {
    final websocketService =
        Provider.of<WebSocketService>(context, listen: false);
    websocketService.sendMessage('CANCEL');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    );
  }

  void _sendRescanMessage() {
    final websocketService =
        Provider.of<WebSocketService>(context, listen: false);
    websocketService.sendMessage('RESCAN');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const HoldInTubForThreeSecondsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height; 

    List<ProductDetails> products = widget.responseProductData;
    List<ProductDetails> missing = widget.missingProducts;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                height: screenHeight * 0.08,
                width: screenWidth * 0.08,
                child: const PaytagLogo()
              ),
            SizedBox(height: screenHeight * 0.03),
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
                            width: screenWidth * 0.8,
                            height: screenWidth * 0.04,
                            alignment: Alignment.center,
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontSize: screenWidth * 0.025,
                                  fontWeight: FontWeight.w400,
                                  height: screenHeight * 0.001,
                                  letterSpacing: 0.01,
                                  color: Colors.black,
                                ),
                                children: [
                                  const TextSpan(text: 'You have '),
                                  TextSpan(
                                    text: '${missing.length} out of ${widget.responseInputTagIds!.length} ',
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
                                style: TextStyle(
                                  fontFamily: 'Open Sans',
                                  fontSize: screenWidth * 0.025,
                                  fontWeight: FontWeight.w400,
                                  height: screenHeight * 0.001,
                                  letterSpacing: 0.01,
                                  color: Colors.black,
                                ),
                                children: [
                                  const TextSpan(text: 'You have '),
                                  TextSpan(
                                    text: '${products.length} out of ${widget.responseInputTagIds!.length} ',
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
            PaytagDescription(
              descriptionText:
                    'Please pay for all products using the Paytag App before proceeding.',
                descriptionWidthPixels: screenWidth * 0.9,
                descriptionHeightPixels: screenHeight * 0.04,
                descriptionFontWeight: FontWeight.w400,
                descriptionFontSize: screenWidth * 0.02,
                descriptionFontLineHeight: screenWidth * 0.02,
                descriptionFontLetter: 1,
            ),
            SizedBox(height: screenHeight * 0.040),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 38.0),
                  child: ElevatedButton(
                    onPressed: _sendRescanMessage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffff0079),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.1,
                        vertical: screenHeight * 0.03,
                      ),
                      textStyle: TextStyle(
                        fontFamily: 'Open Sans',
                        fontSize: screenWidth * 0.026,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: const Text('Rescan'),
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                TextButton(
                  onPressed: _sendCancelMessage,
                  style: TextButton.styleFrom(
                    foregroundColor: const Color.fromRGBO(227, 31, 96, 1),
                    textStyle: TextStyle(
                      fontFamily: 'Open Sans',
                        fontSize: screenWidth * 0.026,
                        fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
