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

    Future.delayed(const Duration(seconds: 8), () {
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
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 25),
              PaytagDescription(
                descriptionText:
                    'Successfully neutralized stickers on $paidTagCount products. Please collect all items.',
                descriptionWidthPixels: 853,
                descriptionHeightPixels: 124,
                descriptionFontWeight: FontWeight.w400,
                descriptionFontSize: 44,
                descriptionFontLineHeight: 61.6,
              ),
              const SizedBox(height: 90),
              if (_gifData != null)
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.memory(
                    _gifData!.buffer.asUint8List(),
                    fit: BoxFit.contain,
                    gaplessPlayback: true,
                  ),
                ),
              const SizedBox(height: 80),
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
      ),
    );
  }
}
