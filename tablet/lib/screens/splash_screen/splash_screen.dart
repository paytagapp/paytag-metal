import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pay_tag_tab/helpers/app_colors.dart';
import 'package:pay_tag_tab/screens/not_connected_screen.dart';
import 'package:pay_tag_tab/screens/product_details/find_cart_screen.dart';
import 'package:pay_tag_tab/screens/welcome_screen.dart';
import 'package:pay_tag_tab/services/websocket_service_new.dart';
import 'package:pay_tag_tab/utils/mixins/connection_status_handler.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1500), () async {
     
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WebSocketConnectionChecker()),
      );

    });

    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Center(
        child: SvgPicture.asset(
          "assets/svg/logo_new_white.svg",
          height: 150,
        ),
      ),
    );
  }
}

class WebSocketConnectionChecker extends StatefulWidget {
  const WebSocketConnectionChecker({super.key});

  @override
  State<WebSocketConnectionChecker> createState() =>
      _WebSocketConnectionCheckerState();
}

class _WebSocketConnectionCheckerState extends State<WebSocketConnectionChecker>
    with ConnectionStatusHandler<WebSocketConnectionChecker> {
  @override
  Widget build(BuildContext context) {
    final websocketService = Provider.of<WebSocketService>(context);

    return StreamBuilder<bool>(
      stream: websocketService.connectionStatusStream,
      initialData: websocketService.isConnected,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasData && snapshot.data == true) {
          return const WelcomeScreen();
        } else {
          return const NotConnectedScreen();
        }
      },
    );
  }
}
