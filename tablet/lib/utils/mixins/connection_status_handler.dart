import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pay_tag_tab/screens/not_connected_screen.dart';
import 'package:pay_tag_tab/screens/welcome_screen.dart';
import 'package:pay_tag_tab/services/websocket_service_new.dart';
import 'package:provider/provider.dart';

mixin ConnectionStatusHandler<T extends StatefulWidget> on State<T> {
  late StreamSubscription<bool> _connectionSubscription;

  @override
  void initState() {
    super.initState();
    final websocketService =
        Provider.of<WebSocketService>(context, listen: false);

    _connectionSubscription =
        websocketService.connectionStatusStream.listen((isConnected) {
      if (!isConnected) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const NotConnectedScreen()),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          (route) => false,
        );
      }
    });
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    super.dispose();
  }

  void initialize() {}
}
