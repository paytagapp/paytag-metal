import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PaytagLogo extends StatelessWidget {
  const PaytagLogo({super.key});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      child: SvgPicture.asset(
        'assets/svg/paytag_violet.svg',
        fit: BoxFit.contain,
      ),
    );
  }
}
