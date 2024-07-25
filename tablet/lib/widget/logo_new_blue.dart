import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PaytagLogo extends StatelessWidget {
  const PaytagLogo({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double logoWidth = screenWidth * 0.8; // Adjust width to be 80% of screen width, or maximum 292px
    double logoHeight = logoWidth * (162 / 292); // Maintain aspect ratio

    if (logoWidth > 292) {
      logoWidth = 292;
      logoHeight = 162;
    }

    return SizedBox(
      width: logoWidth,
      height: logoHeight,
      child: SvgPicture.asset(
        'assets/svg/logo_new_blue.svg',
        fit: BoxFit.contain,
      ),
    );
  }
}
