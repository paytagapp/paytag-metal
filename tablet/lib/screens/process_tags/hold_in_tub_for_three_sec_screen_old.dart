import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pay_tag_tab/screens/product_details/Item_not_found.dart';
import 'package:pay_tag_tab/screens/product_details/not_paid_products_screen.dart';
import 'package:pay_tag_tab/screens/product_details/product_details_controller.dart';
import 'package:pay_tag_tab/screens/success_screen.dart';
import 'package:pay_tag_tab/screens/welcome_screen.dart';
import 'package:pay_tag_tab/services/websocket_service_new.dart';
import 'package:pay_tag_tab/widget/description.dart';
import 'package:flutter/services.dart';
import 'package:pay_tag_tab/utils/mixins/connection_status_handler.dart';
import 'package:provider/provider.dart';

class HoldInTubForThreeSecondsScreen extends StatefulWidget {
  const HoldInTubForThreeSecondsScreen({super.key});

  @override
  HoldInTubForThreeSecondsScreenState createState() =>
      HoldInTubForThreeSecondsScreenState();
}

class HoldInTubForThreeSecondsScreenState
    extends State<HoldInTubForThreeSecondsScreen>
    with ConnectionStatusHandler<HoldInTubForThreeSecondsScreen> {
  ByteData? _gifData;
  late StreamSubscription<String> _messageSubscription;
  final ProductDetailsController _productDetailsController =
      ProductDetailsController();

  @override
  void initState() {
    super.initState();
    _loadGif();

    final websocketService =
        Provider.of<WebSocketService>(context, listen: false);
    _messageSubscription = websocketService.messageStream.listen((message) {
      final jsonData = jsonDecode(message) as Map<String, dynamic>;
      try {
        if (jsonData['message'] != null) {
          if (jsonData['message'] != null &&
              jsonData['message'].contains('UNPAID TAGS')) {
            final data =
                _productDetailsController.extractDataFromMessage(message);
            _productDetailsController.processMessage(context, data,
                (responseData) {
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotPaidProductsScreen(
                        responseProductData: responseData,
                        responseInputTagIds: data['input_tag_id']
                    ),
                  ),
                );
              }
            });
          } else if (jsonData['message'] != null &&
              jsonData['message'].contains('SUCCESSFULLY NEUTRALIZED')) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SuccessScreen(paidTags: jsonData['paidTags'])),
            );
          } else if (jsonData['message'] != null &&
              jsonData['message'].contains('TAG NOT FOUND')) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ItemNotFoundScreen(
                      notFoundTags: jsonData['tagIdsNotFound'])),
            );
          } else if (jsonData['message'] != null &&
              jsonData['message']
                  .contains('NO ITEM IN CART - SCANNING SCREEN')) {
            final websocketService =
                Provider.of<WebSocketService>(context, listen: false);
            websocketService.sendMessage('COLLECTED THE BAG');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            );
          }
        }
      } catch (e) {
        // Log the error
        print('Error processing message: $e');
      }
    });
  }

  @override
  void dispose() {
    _messageSubscription.cancel();
    super.dispose();
  }

  // Load the GIF from assets
  Future<void> _loadGif() async {
    ByteData data =
        await rootBundle.load('assets/gif/three_second_wait-check.gif');
    setState(() {
      _gifData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.05),
              PaytagDescription(
                descriptionText:
                    'Please hold the bag in the tub for 3 seconds...',
                descriptionWidthPixels: screenWidth * 0.58,
                descriptionHeightPixels: screenHeight * 0.2,
                descriptionFontWeight: FontWeight.w700,
                descriptionFontSize: screenWidth * 0.03,
                descriptionFontLineHeight: screenWidth * 0.04,
              ),
              SizedBox(height: screenHeight * 0.09),
              if (_gifData != null)
                SizedBox(
                  width: screenWidth * 0.35,
                  height: screenHeight * 0.35,
                  child: Image.memory(
                    _gifData!.buffer.asUint8List(),
                    fit: BoxFit.contain,
                    gaplessPlayback: true,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
