import 'package:flutter/material.dart';
import 'package:pay_tag_tab/screens/process_tags/hold_in_tub_for_three_sec_screen.dart';
import 'package:pay_tag_tab/widget/description.dart';
import 'package:pay_tag_tab/utils/mixins/connection_status_handler.dart';

class HoldInTubForFiveSecondsScreen extends StatefulWidget {

  const HoldInTubForFiveSecondsScreen({super.key});

  @override
  HoldInTubForFiveSecondsScreenState createState() => HoldInTubForFiveSecondsScreenState();
}

class HoldInTubForFiveSecondsScreenState extends State<HoldInTubForFiveSecondsScreen>
    with SingleTickerProviderStateMixin, ConnectionStatusHandler<HoldInTubForFiveSecondsScreen> {
  late AnimationController _controller;
  late Animation<double> _animation;
  final double maxWidth = 471;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward(); // Start the animation

    // Listen for the animation completion
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Navigate to the next screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HoldInTubForThreeSecondsScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              const PaytagDescription(
                descriptionText: 'Please hold the bag in the tub for 5 seconds...',
                descriptionWidthPixels: 991,
                descriptionHeightPixels: 62,
                descriptionFontWeight: FontWeight.w700,
                descriptionFontSize: 44,
                descriptionFontLineHeight: 61.6,
              ),
              const SizedBox(height: 128),
              LayoutBuilder(
                builder: (context, constraints) {
                  // Determine the width to use
                  double calculatedWidth = constraints.maxWidth; // Start with available width
                  if (calculatedWidth > maxWidth) {
                    calculatedWidth = maxWidth; // If too wide, use max width
                  }
                  return SizedBox(
                    width: calculatedWidth, // Use the calculated width
                    height: 15,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return LinearProgressIndicator(
                            value: _animation.value,
                            backgroundColor: Colors.grey[300],
                            valueColor:
                                const AlwaysStoppedAnimation<Color>(Colors.pink),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}