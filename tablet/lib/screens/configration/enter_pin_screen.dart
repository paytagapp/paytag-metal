import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pay_tag_tab/screens/configration/ip_config_screen.dart';

class EnterPinScreen extends StatefulWidget {
  const EnterPinScreen({super.key});

  @override
  EnterPinScreenState createState() => EnterPinScreenState();
}

class EnterPinScreenState extends State<EnterPinScreen> {
  final TextEditingController _controller = TextEditingController();


  @override
  void initState() {
    super.initState();
  }

void _onOkayPressed() async {
    String secretPin = _controller.text;
    if (secretPin.isNotEmpty) {
      if (secretPin == '123456') {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const IpConfigScreen()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid Pin')),
          );
        }
      }
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
      appBar: AppBar(
        title: const Text('Login'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
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
                top: screenHeight * 0.055,
                left: screenWidth * 0.4276 - screenWidth * 0.2 / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/paytag_violet.svg',
                      fit: BoxFit.contain,
                      width: screenWidth * 0.08,
                      height: screenHeight * 0.08,
                    ),
                    SizedBox(height: screenHeight * 0.053),
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
                          hintText: 'Enter Pin',
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
            ],
          ),
        ),
      ),
    );
  }
}
