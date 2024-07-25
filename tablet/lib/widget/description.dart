import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaytagDescription extends StatelessWidget {
  final String descriptionText;
  final double descriptionWidthPixels;
  final double descriptionHeightPixels;
  final FontWeight descriptionFontWeight;
  final double descriptionFontSize;
  final double descriptionFontLineHeight;
  final double? descriptionFontLetter;

  // const PaytagDescription({super.key});
  const PaytagDescription({
    super.key,
    required this.descriptionText,
    required this.descriptionWidthPixels,
    required this.descriptionHeightPixels,
    required this.descriptionFontWeight,
    required this.descriptionFontSize,
    required this.descriptionFontLineHeight,
    this.descriptionFontLetter,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double descriptionWidth = screenWidth * 0.9; // Adjust percentage as needed
    if (descriptionWidth > descriptionWidthPixels) {
      descriptionWidth = descriptionWidthPixels;
    }

    return SizedBox(
      width: descriptionWidth,
      height: descriptionHeightPixels,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate font size based on available width
          double fontSize = descriptionFontSize; // Initial font size
          if (constraints.maxWidth < descriptionWidthPixels) {
            // Reduce font size proportionally
            fontSize = descriptionFontSize *
                (constraints.maxWidth / descriptionWidthPixels);
          }

          return Text(
            descriptionText,
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              fontSize: fontSize,
              fontWeight: descriptionFontWeight,
              height: descriptionFontLineHeight / fontSize,
              letterSpacing: descriptionFontLetter ?? 0 / 100,
            ),
          );
        },
      ),
    );
  }
}