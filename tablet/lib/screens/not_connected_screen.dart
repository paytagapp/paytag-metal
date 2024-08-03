import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pay_tag_tab/screens/configration/enter_pin_screen.dart';
import 'package:pay_tag_tab/screens/configration/login_screen.dart';
import 'package:pay_tag_tab/utils/mixins/connection_status_handler.dart';
import 'package:pay_tag_tab/widget/description.dart';
import 'package:pay_tag_tab/widget/logo_new_blue.dart';

class NotConnectedScreen extends StatefulWidget {
  const NotConnectedScreen({super.key});

  @override
  State<NotConnectedScreen> createState() => _NotConnectedScreenState();
}

class _NotConnectedScreenState extends State<NotConnectedScreen> with WidgetsBindingObserver {
  int _tapCount = 0;
  Timer? _tapTimer;
  static const int _tapTimeLimit = 10; // Time limit in seconds
  static const int _requiredTaps = 5;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _tapTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resetTapCount();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _resetTapCount();
    }
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
          MaterialPageRoute(builder: (context) => const EnterPinScreen()),
          // MaterialPageRoute(builder: (context) => const LoginScreen()),
        ).then((_) => _resetTapCount());
      }
    });
  }

  void _resetTapCount() {
    setState(() {
      _tapCount = 0;
      _tapTimer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: _handleTap,
      child: Focus(
        focusNode: _focusNode,
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.046),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.0712),
                  SizedBox(
                    width: screenWidth * 0.52,
                    height: screenHeight * 0.082,
                    child: const PaytagLogo(),
                  ),
                  SizedBox(height: screenHeight * 0.112),
                  SizedBox(
                    width: screenWidth * 1.9,
                    height: screenHeight * 0.09,
                    child: PaytagDescription(
                      descriptionText: 'Server connection lost, please connect to the server!',
                      descriptionWidthPixels: screenWidth * 0.198,
                      descriptionHeightPixels: screenHeight * 0.0828,
                      descriptionFontWeight: FontWeight.w500,
                      descriptionFontSize: screenWidth * 0.027,
                      descriptionFontLineHeight: screenWidth * 0.045,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}