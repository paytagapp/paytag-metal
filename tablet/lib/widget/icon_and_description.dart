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
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width:  screenWidth * 0.8,
      height: screenHeight * 0.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: screenWidth * 0.6,
            height: screenWidth * 0.03,
            child: description != null ? Text(
              description!,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                fontSize: screenWidth * 0.017,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ) : null,
          ),

          SizedBox(height: screenHeight * 0.02),         
          SizedBox(
            width: screenWidth * 0.075,
            height: screenWidth * 0.075,
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
