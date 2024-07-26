import 'package:flutter/material.dart';
import 'package:pay_tag_tab/services/websocket_service_new.dart';
import 'package:provider/provider.dart';
import 'package:pay_tag_tab/utils/mixins/connection_status_handler.dart';

class NewScreen extends StatefulWidget {
  const NewScreen({super.key});

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> with ConnectionStatusHandler<NewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Screen')),
      body: const Center(child: Text('Content goes here')),
    );
  }
}
