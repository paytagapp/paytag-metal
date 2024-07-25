import 'package:flutter/material.dart';
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

  const NotPaidProductsScreen({super.key, required this.responseProductData});

  @override
  NotPaidProductsScreenState createState() => NotPaidProductsScreenState();
}

class NotPaidProductsScreenState extends State<NotPaidProductsScreen>
    with ConnectionStatusHandler<NotPaidProductsScreen> {
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
    List<ProductDetails> products = widget.responseProductData;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const PaytagLogo(),
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
                      text: '${products.length} out of ${products.length} ',
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
              padding: const EdgeInsets.symmetric(vertical: 85),
              child: SizedBox(
                child: ProductSlider(products: products),
              ),
            ),
            const PaytagDescription(
              descriptionText:
                  'Please pay for all products using the Paytag App before proceeding.',
              descriptionWidthPixels: 1097,
              descriptionHeightPixels: 124,
              descriptionFontWeight: FontWeight.w400,
              descriptionFontSize: 44,
              descriptionFontLineHeight: 61.6,
              descriptionFontLetter: 1,
            ),
            const SizedBox(height: 16),
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
              child: const Text('OK'),
            ),
          ],
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
