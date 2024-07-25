import 'dart:async';

import 'package:flutter/material.dart';

import 'package:pay_tag_tab/screens/welcome_screen.dart';
import 'package:pay_tag_tab/services/websocket_service_new.dart';
import 'package:pay_tag_tab/widget/logo_new_blue.dart';
import 'package:pay_tag_tab/widget/description.dart';
import 'package:pay_tag_tab/utils/mixins/connection_status_handler.dart';
import 'package:provider/provider.dart';

class ItemNotFoundScreen extends StatefulWidget {
  final dynamic notFoundTags;

  const ItemNotFoundScreen({
    super.key,
    required this.notFoundTags,
  });

  @override
  State<ItemNotFoundScreen> createState() => _ItemNotFoundScreenState();
}

class _ItemNotFoundScreenState extends State<ItemNotFoundScreen>
    with ConnectionStatusHandler<ItemNotFoundScreen> {
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

    Future.delayed(const Duration(seconds: 4), () {
      _sendMessage();
      _redirect();
    });
  }

  @override
  void dispose() {
    _messageSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SizedBox(
        height: screenHeight,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const PaytagLogo(),
                const SizedBox(height: 32),
                const PaytagDescription(
                  descriptionText: 'Item not found, please approach a staff',
                  descriptionWidthPixels: 824,
                  descriptionHeightPixels: 124,
                  descriptionFontWeight: FontWeight.w400,
                  descriptionFontSize: 44,
                  descriptionFontLineHeight: 61.6,
                  descriptionFontLetter: 1,
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
      ),
    );
  }
}
