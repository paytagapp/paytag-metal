import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pay_tag_tab/screens/welcome_screen.dart';
import 'package:pay_tag_tab/services/websocket_service_new.dart';
import 'package:pay_tag_tab/widget/description.dart';
import 'package:flutter/services.dart';
import 'package:pay_tag_tab/utils/mixins/connection_status_handler.dart';
import 'package:provider/provider.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({
    super.key,
    required this.paidTags,
  });

  final dynamic paidTags;

  @override
  SuccessScreenState createState() => SuccessScreenState();
}

class SuccessScreenState extends State<SuccessScreen>
    with ConnectionStatusHandler<SuccessScreen> {
  ByteData? _gifData;
  late StreamSubscription<String> _messageSubscription;

  void _redirect() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const WelcomeScreen()),
    );
  }

  void _sendMessage() {
    final websocketService =
        Provider.of<WebSocketService>(context, listen: false);
    websocketService.sendMessage('COLLECTED THE BAG');
    _redirect();
  }

  @override
  void initState() {
    super.initState();
    _loadGif(); // Load the GIF when the screen initializes

    Future.delayed(const Duration(seconds: 6), () {
      _sendMessage(); // Send message after 4 seconds
      _redirect();
    });
  }

  @override
  void dispose() {
    _messageSubscription.cancel();
    super.dispose();
  }

  // Load the GIF from assets
  Future<void> _loadGif() async {
    ByteData data = await rootBundle.load('assets/gif/successful.gif');
    setState(() {
      _gifData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    final paidTags = widget.paidTags;
    final paidTagCount = paidTags.length;

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical : screenWidth * 0.09, horizontal: screenWidth * 0.18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            SizedBox(height: screenHeight * 0.05),
              PaytagDescription(
                descriptionText:
                    'Successfully neutralized stickers on $paidTagCount products. Please collect all items.',
                 descriptionWidthPixels: screenWidth * 0.2,
                descriptionHeightPixels: screenHeight * 0.04,
                descriptionFontWeight: FontWeight.w400,
                descriptionFontSize: screenWidth * 0.03,
                descriptionFontLineHeight: screenWidth * 0.04,
                descriptionFontLetter: 1,
              ),
              SizedBox(height: screenHeight * 0.08),
              if (_gifData != null)
                SizedBox(
                  width:  screenHeight * 0.2,
                  height:  screenHeight * 0.2,
                  child: Image.memory(
                    _gifData!.buffer.asUint8List(),
                    fit: BoxFit.contain,
                    gaplessPlayback: true,
                  ),
                ),
              // SizedBox(height:  screenHeight * 0.8),
              // ElevatedButton(
              //   onPressed: _sendMessage,
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: const Color.fromRGBO(22, 72, 121, 1),
              //     foregroundColor: Colors.white,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(7),
              //     ),
              //     padding: const EdgeInsets.symmetric(
              //       horizontal: 30,
              //       vertical: 22,
              //     ),
              //     textStyle: const TextStyle(
              //       fontFamily: 'Open Sans',
              //       fontSize: 24,
              //     ),
              //   ),
              //   child: const Text('OK'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
