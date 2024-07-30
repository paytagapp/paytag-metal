import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:pay_tag_tab/screens/process_tags/hold_in_tub_for_five_sec_screen.dart';
import 'package:pay_tag_tab/screens/process_tags/hold_in_tub_for_three_sec_screen_old.dart';
// import 'package:pay_tag_tab/screens/process_tags/hold_in_tub_for_three_sec_screen.dart';
import 'package:pay_tag_tab/services/websocket_service_new.dart';
import 'package:pay_tag_tab/widget/logo_new_blue.dart';
import 'package:pay_tag_tab/widget/description.dart';
import 'package:pay_tag_tab/widget/icon_and_description.dart';
import 'package:provider/provider.dart';
import 'package:pay_tag_tab/utils/mixins/connection_status_handler.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with ConnectionStatusHandler<WelcomeScreen> {
  late StreamSubscription<String> _messageSubscription;

  @override
  void initState() {
    super.initState();
    final websocketService =
        Provider.of<WebSocketService>(context, listen: false);

    try {
      _messageSubscription = websocketService.messageStream.listen((message) {
        if (message == 'HOLD IN TUB') {
          Navigator.pushReplacement(
            context,
            // MaterialPageRoute(builder: (context) => const HoldInTubForFiveSecondsScreen()),
            MaterialPageRoute(
                builder: (context) => const HoldInTubForThreeSecondsScreen()),
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

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SizedBox(
        height: screenHeight,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const PaytagLogo(),
                SizedBox(height: screenHeight * 0.08),
                PaytagDescription(
                   descriptionText: 'Welcome, please put the bags in the tub to neutralize the stickers',
                    descriptionWidthPixels: screenWidth * 0.58,
                    descriptionHeightPixels: screenHeight * 0.2,
                    descriptionFontWeight: FontWeight.w400,
                    descriptionFontSize: screenWidth * 0.03, 
                    descriptionFontLineHeight: screenWidth * 0.04,
                    descriptionFontLetter: 1,
                ),
                SizedBox(height: screenHeight * 0.03),
                const IconAndDescriptionSection(
                  icon: 'assets/svg/QR_code.svg',
                  description: 'Download the Paytag App here',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
