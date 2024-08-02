import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pay_tag_tab/screens/process_tags/hold_in_tub_for_three_sec_screen_old.dart';
// import 'package:pay_tag_tab/screens/process_tags/hold_in_tub_for_three_sec_screen.dart';
import 'package:pay_tag_tab/screens/product_details/product_details_controller.dart';
import 'package:pay_tag_tab/screens/product_details/product_slider.dart';
import 'package:pay_tag_tab/screens/welcome_screen.dart';
import 'package:pay_tag_tab/services/websocket_service_new.dart';
import 'package:pay_tag_tab/utils/mixins/connection_status_handler.dart';
import 'package:pay_tag_tab/widget/description.dart';
import 'package:pay_tag_tab/widget/logo_new_blue.dart';
import 'package:provider/provider.dart';

class NotPaidProductsScreen extends StatefulWidget {
  final List<ProductDetails> responseProductData;
  final List<dynamic>? responseInputTagIds;

  const NotPaidProductsScreen({super.key, required this.responseProductData, this.responseInputTagIds});

  @override
  NotPaidProductsScreenState createState() => NotPaidProductsScreenState();
}

class NotPaidProductsScreenState extends State<NotPaidProductsScreen>
    with ConnectionStatusHandler<NotPaidProductsScreen> {
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
    List<ProductDetails> products = widget.responseProductData;

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  height: screenHeight * 0.08,
                  width: screenWidth * 0.08,
                  child: const PaytagLogo()),
              SizedBox(height: screenHeight * 0.03),
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
                        text: '${products.length} out of ${widget.responseInputTagIds!.length} ',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const TextSpan(text: 'unpaid products in your bag:'),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  height: screenHeight * 0.35, // reduce the size of the slider
                  width: screenWidth * 0.8,
                  child: ProductSlider(products: products),
                ),
              ),
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
              SizedBox(height: screenHeight * 0.03),
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
      ),
    );
  }
}






















































































// import 'package:flutter/material.dart';
// import 'package:pay_tag_tab/screens/product_details/product_slider.dart';
// import 'package:pay_tag_tab/screens/welcome_screen.dart';
// import 'package:pay_tag_tab/services/websocket_service_new.dart';
// import 'package:pay_tag_tab/utils/mixins/connection_status_handler.dart';
// import 'package:pay_tag_tab/widget/description.dart';
// import 'package:pay_tag_tab/widget/logo_new_blue.dart';
// import 'package:provider/provider.dart';

// class NotPaidProductsScreen extends StatefulWidget {
//   final dynamic responseProductData;

//   const NotPaidProductsScreen({super.key, required this.responseProductData});

//   @override
//   NotPaidProductsScreenState createState() => NotPaidProductsScreenState();
// }

// class NotPaidProductsScreenState extends State<NotPaidProductsScreen>
//     with ConnectionStatusHandler<NotPaidProductsScreen> {
//   void _sendMessage() {
//     final websocketService =
//         Provider.of<WebSocketService>(context, listen: false);
//     websocketService.sendMessage('COLLECTED THE BAG');
//     Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => const WelcomeScreen()),
//   );
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Map<String, dynamic>> products =
//         List<Map<String, dynamic>>.from(widget.responseProductData);

//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const PaytagLogo(),
//             Container(
//               width: 1097,
//               height: 62,
//               alignment: Alignment.center,
//               child: RichText(
//                 text: TextSpan(
//                   style: const TextStyle(
//                     fontFamily: 'Open Sans',
//                     fontSize: 44,
//                     fontWeight: FontWeight.w400,
//                     height: 61.6 / 44,
//                     letterSpacing: 0.01,
//                     color: Colors.black,
//                   ),
//                   children: [
//                     const TextSpan(text: 'You have '),
//                     TextSpan(
//                       text: '${products.length} out of ${products.length} ',
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     const TextSpan(text: 'unpaid products in your bag:'),
//                   ],
//                 ),
//               ),
//             ),
//             Expanded(
//               child: ProductSlider(products: products),
//             ),
//             const PaytagDescription(
//               descriptionText:
//                   'Please pay for all products using the Paytag App before proceeding.',
//               descriptionWidthPixels: 1097,
//               descriptionHeightPixels: 124,
//               descriptionFontWeight: FontWeight.w400,
//               descriptionFontSize: 44,
//               descriptionFontLineHeight: 61.6,
//               descriptionFontLetter: 1,
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _sendMessage,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color.fromRGBO(22, 72, 121, 1),
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(7),
//                 ),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 30,
//                   vertical: 22,
//                 ),
//                 textStyle: const TextStyle(
//                   fontFamily: 'Open Sans',
//                   fontSize: 24,
//                 ),
//               ),
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
