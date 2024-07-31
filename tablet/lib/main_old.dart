import 'package:flutter/material.dart';
import 'package:pay_tag_tab/screens/not_connected_screen.dart';
import 'package:pay_tag_tab/screens/welcome_screen.dart';
import 'package:pay_tag_tab/services/websocket_service_new.dart';
import 'package:pay_tag_tab/utils/mixins/connection_status_handler.dart';
import 'package:pay_tag_tab/widget/loader.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WebSocketService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paytag',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      builder: (context, child) {
        return ChangeNotifierProvider(
          create: (context) => WebSocketService(),
          child: child,
        );
      },
      home: const WebSocketConnectionChecker(),
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
