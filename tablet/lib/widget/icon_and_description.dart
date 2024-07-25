import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class IconAndDescriptionSection extends StatelessWidget {

  final String icon;
  final String? description;

  const IconAndDescriptionSection({
    super.key,
    required this.icon,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Container dimensions
    double containerWidth = screenWidth * 0.8; // Adjust width to be 80% of screen width, or maximum 217.32px
    // if (containerWidth > 217.32) {
    //   containerWidth = 217.32;
    // }
    double containerHeight = 413; // Fixed height as per the design

    // Text dimensions
    double textWidth = 411; // Fixed width as per the design
    double textHeight = 39; // Fixed height as per the design

    // QR Code dimensions
    double qrCodeSize = 124.32; // Fixed size as per the design

    return SizedBox(
      width: containerWidth,
      height: containerHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: textWidth,
            height: textHeight,
            child: description != null ? Text(
              description!,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: 28,
                fontWeight: FontWeight.w400,
                height: 39.2 / 28, // Line height divided by font size
              ),
            ) : null,
          ),

          const SizedBox(height: 22), // Gap between text and QR code
          
          SizedBox(
            width: qrCodeSize,
            height: qrCodeSize,
            child: SvgPicture.asset(
              icon,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
