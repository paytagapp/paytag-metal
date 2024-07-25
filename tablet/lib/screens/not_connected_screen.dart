import 'package:flutter/material.dart';
import 'package:pay_tag_tab/utils/mixins/connection_status_handler.dart';
import 'package:pay_tag_tab/widget/description.dart';
import 'package:pay_tag_tab/widget/logo_new_blue.dart';

class NotConnectedScreen extends StatefulWidget {
  const NotConnectedScreen({super.key});

  @override
  State<NotConnectedScreen> createState() => _NotConnectedScreenState();
}

class _NotConnectedScreenState extends State<NotConnectedScreen> with ConnectionStatusHandler<NotConnectedScreen> {
  
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PaytagLogo(),
              SizedBox(height: 32),
              PaytagDescription(
                descriptionText: 'Server connection lost, please connect to the server!',
                descriptionWidthPixels: 991,
                descriptionHeightPixels: 62,
                descriptionFontWeight: FontWeight.w500,
                descriptionFontSize: 30 ,
                descriptionFontLineHeight: 61.6,
              ),
              SizedBox(height: 128),
            ],
          ),
        ),
      ),
    );
  }
}