import 'package:flutter/material.dart';
import 'package:pay_tag_tab/widget/logo_new_blue.dart';
import 'package:pay_tag_tab/widget/description.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PaytagLogo(),
              SizedBox(height: 32),
              CircularProgressIndicator(),
              SizedBox(height: 32),
              PaytagDescription(
                descriptionText: 'Not connected to server, please connect to server!',
                descriptionWidthPixels: 750,
                descriptionHeightPixels: 60,
                descriptionFontWeight: FontWeight.w500,
                descriptionFontSize: 28,
                descriptionFontLineHeight: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
