import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pay_tag_tab/screens/configration/login_screen.dart';
import 'package:pay_tag_tab/utils/mixins/connection_status_handler.dart';
import 'package:pay_tag_tab/widget/description.dart';
import 'package:pay_tag_tab/widget/logo_new_blue.dart';

class NotConnectedScreen extends StatefulWidget {
  const NotConnectedScreen({super.key});

  @override
  State<NotConnectedScreen> createState() => _NotConnectedScreenState();
}

class _NotConnectedScreenState extends State<NotConnectedScreen> with ConnectionStatusHandler<NotConnectedScreen> {
  int _tapCount = 0;
  Timer? _tapTimer;
  static const int _tapTimeLimit = 10; // Time limit in seconds
  static const int _requiredTaps = 5;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset the state each time this screen is pushed onto the navigation stack
    _resetState();
  }

  void _resetState() {
    _tapCount = 0;
    _tapTimer?.cancel();
  }
  
  @override
  void dispose() {
    _tapTimer?.cancel();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _tapCount++;
      
      if (_tapCount == 1) {
        // Start the timer on the first tap
        _tapTimer = Timer(const Duration(seconds: _tapTimeLimit), _resetTapCount);
      }

      if (_tapCount == _requiredTaps) {
        _tapTimer?.cancel();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  void _resetTapCount() {
    setState(() {
      _tapCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: _handleTap,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.25),
                const PaytagLogo(),
                SizedBox(height: screenHeight * 0.085),
                Expanded(
                  child: PaytagDescription(
                    descriptionText: 'Server connection lost, please connect to the server!',
                    descriptionWidthPixels: screenWidth * 0.9,  
                    descriptionHeightPixels: screenHeight * 0.8,
                    descriptionFontWeight: FontWeight.w500,
                    descriptionFontSize: screenWidth * 0.025,
                    descriptionFontLineHeight: screenWidth * 0.06,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
