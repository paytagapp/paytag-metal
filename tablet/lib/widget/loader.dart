import 'package:flutter/material.dart';
import 'package:pay_tag_tab/widget/logo_new_blue.dart';
import 'package:pay_tag_tab/widget/description.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
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
                child: const PaytagLogo()
              ),
              SizedBox(height: screenHeight * 0.112),
              const CircularProgressIndicator(),
              SizedBox(height: screenHeight * 0.112),
              SizedBox(
                width: screenWidth * 1.9,
                height: screenHeight * 0.09,
                child: PaytagDescription(
                  descriptionText: 'Not connected to server, please connect to server!',
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
    );
  }
}
