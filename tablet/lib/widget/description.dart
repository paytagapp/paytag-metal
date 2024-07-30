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

    return SizedBox(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Text(
            descriptionText,
            textAlign: TextAlign.center,
            style: GoogleFonts.openSans(
              fontSize: descriptionFontSize,
              fontWeight: descriptionFontWeight,
              height: descriptionFontLineHeight / descriptionFontSize,
              letterSpacing: descriptionFontLetter ?? 0 / 100,
            ),
          );
        },
      ),
    );
  }
}