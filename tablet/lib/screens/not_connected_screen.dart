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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
    );
  }
}
