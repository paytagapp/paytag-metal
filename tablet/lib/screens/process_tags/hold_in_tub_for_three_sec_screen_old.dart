import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pay_tag_tab/screens/product_details/Item_not_found.dart';
import 'package:pay_tag_tab/screens/product_details/not_paid_products_screen.dart';
import 'package:pay_tag_tab/screens/product_details/product_details_controller.dart';
import 'package:pay_tag_tab/screens/success_screen.dart';
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
                        responseProductData: responseData),
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
    ByteData data = await rootBundle.load('assets/gif/three_second_wait-check.gif');
    setState(() {
      _gifData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              const PaytagDescription(
                descriptionText:
                    'Please hold the bag in the tub for 3 seconds...',
                descriptionWidthPixels: 991,
                descriptionHeightPixels: 62,
                descriptionFontWeight: FontWeight.w700,
                descriptionFontSize: 44,
                descriptionFontLineHeight: 61.6,
              ),
              const SizedBox(height: 128),
              if (_gifData != null)
                SizedBox(
                  width: 250,
                  height: 250,
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
