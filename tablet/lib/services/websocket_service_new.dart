import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService extends ChangeNotifier {
  late String url;

  // final String url = "ws://192.168.122.1:8000"; // LAN IP
  // final String url = "ws://192.168.179.171:8000"; // LAN IP
  // final String url = "ws://192.168.1.76:8000"; // LAN IP
  // final String url = "ws://10.0.0.7:8000"; // LAN IP
  // final String url = "ws://172.0.0.1:8000"; // LAN IP
  WebSocketChannel? _channel;

  final _connectionStatusController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;

  final _messageController = StreamController<String>.broadcast();
  Stream<String> get messageStream => _messageController.stream;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Timer? _reconnectionTimer;

  WebSocketService() {
    _loadIpFromStorage();
    // _connect();
  }

  Future<void> _loadIpFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    url = prefs.getString('websocket_ip') ?? "ws://192.168.179.171:8000";
    _connect();
  }

  void _connect() {
    _channel = WebSocketChannel.connect(Uri.parse(url));

    _channel!.ready.then((_) {
      _isConnected = true;
      _connectionStatusController.add(true);
      notifyListeners();
    }).catchError((error) {
      _handleConnectionLoss();
      _startReconnectionTimer();
    });

    _channel!.stream.listen(
      (message) {
        _messageController.sink.add(message);
      },
      onDone: () {
        _handleConnectionLoss();
      },
      onError: (error) {
        _handleConnectionLoss();
      },
    );
  }

  void _handleConnectionLoss() {
    if (_isConnected) {
      _isConnected = false;
      _connectionStatusController.add(false);
      notifyListeners();
    }
    _startReconnectionTimer();
  }

  void _startReconnectionTimer() {
    if (_reconnectionTimer == null || !_reconnectionTimer!.isActive) {
      _reconnectionTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (!_isConnected) {
          _connect();
        } else {
          timer.cancel();
        }
      });
    }
  }

  void sendMessage(String message) {
    if (_isConnected && _channel != null) {
      _channel!.sink.add(message);
    }
  }

  @override
  void dispose() {
    _reconnectionTimer?.cancel();
    _connectionStatusController.add(false);
    _connectionStatusController.close();
    _messageController.close();
    _channel?.sink.close();
    super.dispose();
  }

  Future<void> updateIp(String newIp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('websocket_ip', newIp);
    url = newIp;
  }
}
