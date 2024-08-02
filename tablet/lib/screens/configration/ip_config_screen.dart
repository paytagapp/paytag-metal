import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pay_tag_tab/services/websocket_service_new.dart';
import '../../main.dart';

class IpConfigScreen extends StatefulWidget {
  const IpConfigScreen({super.key});

  @override
  IpConfigScreenState createState() => IpConfigScreenState();
}

class IpConfigScreenState extends State<IpConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCurrentIp();
    });
  }

  void _loadCurrentIp() {
    final websocketService = Provider.of<WebSocketService>(context, listen: false);
    // Extract only the IP part from the full URL
    final urlParts = websocketService.url.split(':');
    if (urlParts.length >= 2) {
      _ipController.text = urlParts[1].replaceAll('//', '');
    }
  }

  Future<void> _updateIp() async {
    if (_formKey.currentState!.validate()) {
      final websocketService = Provider.of<WebSocketService>(context, listen: false);
      // Construct the full WebSocket URL with the new IP and fixed port
      final newUrl = 'ws://${_ipController.text}:8000';
      await websocketService.updateIp(newUrl);
      if (mounted) {
        runApp(const MyApp());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configure IP')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _ipController,
              decoration: const InputDecoration(labelText: 'WebSocket IP (without port)'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the WebSocket IP';
                }
                // You can add more sophisticated IP address validation here if needed
                return null;
              },
            ),
            ElevatedButton(
              onPressed: _updateIp,
              child: const Text('Update IP'),
            ),
          ],
        ),
      ),
    );
  }
}