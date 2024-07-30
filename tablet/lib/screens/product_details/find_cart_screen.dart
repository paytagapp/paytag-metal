import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pay_tag_tab/screens/product_details/Item_not_found.dart';
import 'package:pay_tag_tab/screens/product_details/not_paid_products_screen.dart';
import 'package:pay_tag_tab/screens/product_details/not_paid_and_missing_products_screen.dart';
import 'package:pay_tag_tab/screens/product_details/product_details_controller.dart';
import 'package:pay_tag_tab/screens/success_screen.dart';
import 'package:pay_tag_tab/utils/mixins/connection_status_handler.dart';

class FindCartScreen extends StatefulWidget {
  final List<dynamic> inputTagData;

  const FindCartScreen({super.key, required this.inputTagData});

  @override
  FindCartScreenState createState() => FindCartScreenState();
}

class FindCartScreenState extends State<FindCartScreen>
    with ConnectionStatusHandler<FindCartScreen> {
  final TextEditingController _controller = TextEditingController();
  final ProductDetailsController _productDetailsController =
      ProductDetailsController();
  bool _isLoading = false;

  void _onOkayPressed() async {
    String invoiceNumber = _controller.text;
    if (invoiceNumber.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoadingScreen()),
      );

      await _productDetailsController
          .findCart(context, invoiceNumber, widget.inputTagData,
              (Map<String, dynamic>? responseFindCartData) async {
        if (responseFindCartData != null) {
          try {
            final Map<String, dynamic> findCartResult = responseFindCartData;
            if (!findCartResult['status']) {
              if (findCartResult.containsKey('tagIdsNotPaid') 
              // && findCartResult.containsKey('tagIdsMissing')
              ) {
                final List<String> tagIdsNotPaid =
                    findCartResult['tagIdsNotPaid'].cast<String>();

                _productDetailsController
                    .processMessage(context, {'tag_id': tagIdsNotPaid},
                        (responseProductDetails) {
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotPaidAndMissingProductsScreen(
                            responseProductData: responseProductDetails, 
                            missingProducts: responseProductDetails
                        ),
                      ),
                    );
                  }
                  setState(() {
                    _isLoading = false;
                  });
                });
              } else if (findCartResult.containsKey('tagIdsNotPaid')) {
                final List<String> tagIdsNotPaid =
                    findCartResult['tagIdsNotPaid'].cast<String>();

                _productDetailsController
                    .processMessage(context, {'tag_id': tagIdsNotPaid},
                        (responseProductDetails) {
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotPaidProductsScreen(
                            responseProductData: responseProductDetails),
                      ),
                    );
                  }
                  setState(() {
                    _isLoading = false;
                  });
                });
              } else if (findCartResult.containsKey('tagIdsMissing')) {
                final List<String> tagIdsMissing =
                    findCartResult['tagIdsMissing'].cast<String>();

                _productDetailsController
                    .processMessage(context, {'tag_id': tagIdsMissing},
                        (responseProductDetails) {
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotPaidProductsScreen(
                            responseProductData: responseProductDetails),
                      ),
                    );
                  }
                  setState(() {
                    _isLoading = false;
                  });
                });
              } else {
                Navigator.pop(context); // Remove loading screen
                setState(() {
                  _isLoading = false;
                });
              }
            } else if (findCartResult['status']) {
              final List<String> tagIdsPaid =
                    findCartResult['tagIdsNotPaid'].cast<String>();
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SuccessScreen(paidTags: tagIdsPaid)),
              );
            }  else if (findCartResult['tagIdsNotFound']) {
              final List<String> tagIdsNotFound =
                    findCartResult['tagIdsNotFound'].cast<String>();
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ItemNotFoundScreen(notFoundTags: tagIdsNotFound)),
              );
            } else {
              // Handle null case 
              Navigator.pop(context); // Remove loading screen
              setState(() {
                _isLoading = false;
              });
            }
          } catch (e) {
            print('Error processing response: $e');
            Navigator.pop(context); // Remove loading screen
            setState(() {
              _isLoading = false;
            });
          }
        } else {
          // Handle null case
          Navigator.pop(context); // Remove loading screen
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  Border getBorder(int index) {
    const borderSide = BorderSide(color: Color(0xffece6f0), width: 3.5);
    switch (index) {
      case 1:
        return const Border(left: borderSide, right: borderSide);
      case 3:
        return const Border(top: borderSide, bottom: borderSide);
      case 4:
        return Border.all(color: const Color(0xffece6f0), width: 3.5);
      case 5:
        return const Border(top: borderSide, bottom: borderSide);
      case 7:
        return const Border(
            right: borderSide, bottom: borderSide, left: borderSide);
      default:
        return const Border();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          color: Colors.white,
          child: Stack(
            children: [
              Positioned(
                top: -82,
                right: -screenWidth * 0.1,
                child: Transform.rotate(
                  angle: 15.5 * 3.1415926535897932 / 180,
                  child: Container(
                    width: screenWidth * 0.58,
                    height: screenHeight * 1.5,
                    color: const Color(0xff164879),
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * 0.195,
                left: screenWidth * 0.073,
                width: screenWidth * 0.6,
                height: screenHeight * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/paytag_violet.svg',
                      fit: BoxFit.contain,
                      width: screenWidth * 0.08,
                      height: screenHeight * 0.08,
                    ),
                    SizedBox(height: screenHeight * 0.103),
                    SizedBox(
                      width: screenWidth * 0.45,
                      height: screenHeight * 0.38,
                      child: Text(
                        'We were unable to locate your order, please enter the Paytag ID number to deactivate the stickers',
                        style: GoogleFonts.openSans(
                          // fontSize: 40,
                          fontSize: screenWidth * 0.0326,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 44 / 100,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: screenHeight * 0.195,
                left: screenWidth * 0.6576 - screenWidth * 0.2 / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.348,
                      height: screenHeight * 0.19,
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            color: Colors.black,
                            fontSize: screenWidth * 0.0315),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.005),
                            borderSide: BorderSide(
                              color: const Color(0xff1d1b20),
                              width: screenHeight * 0.9,
                            ),
                          ),
                          hintText: 'Enter Paytag ID',
                          filled: true,
                          fillColor: const Color(0xFFFFFFFF),
                          contentPadding: const EdgeInsets.all(19.0),
                          hintStyle: TextStyle(
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            fontSize: screenWidth * 0.0315,
                            // fontWeight: FontWeight.w500,
                            letterSpacing: 4.4,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: screenWidth * 0.348,
                      height: screenHeight * 0.7,
                      child: GridView.count(
                        crossAxisCount: 3,
                        childAspectRatio: 1.7,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 0,
                        children: List.generate(12, (index) {
                          final isBordered = [1, 3, 4, 5, 7].contains(index);
                          if (index < 9) {
                            return Container(
                              decoration: BoxDecoration(
                                border: isBordered ? getBorder(index) : null,
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  _controller.text += (index + 1).toString();
                                  setState(() {});
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF7F2FA),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: index == 0
                                          ? const Radius.circular(12.5)
                                          : const Radius.circular(0),
                                      topRight: index == 2
                                          ? const Radius.circular(12.5)
                                          : const Radius.circular(0),
                                      bottomLeft: index == 6
                                          ? const Radius.circular(12.5)
                                          : const Radius.circular(0),
                                      bottomRight: index == 8
                                          ? const Radius.circular(12.5)
                                          : const Radius.circular(0),
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    (index + 1).toString(),
                                    style: TextStyle(
                                        fontFamily:
                                            GoogleFonts.roboto().fontFamily,
                                        color: Colors.black,
                                        fontSize: screenWidth * 0.0315),
                                  ),
                                ),
                              ),
                            );
                          } else if (index == 9) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(top: 16.3, right: 16.3),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_controller.text.isNotEmpty) {
                                    _controller.text = _controller.text
                                        .substring(
                                            0, _controller.text.length - 1);
                                    setState(() {});
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pink,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.5),
                                  ),
                                ),
                                child: Icon(
                                  Icons.keyboard_return_sharp,
                                  color: Colors.white,
                                  size: screenWidth * 0.0332,
                                ),
                              ),
                            );
                          } else if (index == 10) {
                            return ElevatedButton(
                              onPressed: () {
                                _controller.text += '0';
                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF7F2FA),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12.5),
                                    bottomRight: Radius.circular(12.5),
                                  ),
                                ),
                              ),
                              child: Text(
                                '0',
                                style: TextStyle(
                                    fontFamily: GoogleFonts.roboto().fontFamily,
                                    color: Colors.black,
                                    fontSize: screenWidth * 0.0315),
                              ),
                            );
                          } else {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(top: 16.3, left: 16.3),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_controller.text.isNotEmpty) {
                                    _onOkayPressed();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pink,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.5),
                                  ),
                                ),
                                child: Text(
                                  'Okay',
                                  style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.roboto().fontFamily,
                                      color: Colors.white,
                                      fontSize: screenWidth * 0.0288),
                                ),
                              ),
                            );
                          }
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}