import 'package:flutter/material.dart';
import 'package:pay_tag_tab/screens/product_details/product_card.dart';
import 'package:pay_tag_tab/screens/product_details/product_details_controller.dart'; // Import the ProductDetails model

class ProductSlider extends StatelessWidget {
  final List<ProductDetails> products;

  const ProductSlider({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 300, // Adjust height as needed
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: products.map((product) {
              return Padding(
                padding: const EdgeInsets.all(8.0), // Add padding between product cards
                child: ProductCard(
                  title: product.name,
                  color: product.color,
                  size: product.size,
                  price: product.price,
                  imageUrl: product.imageUrl,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}










// import 'package:flutter/material.dart';
// import 'package:pay_tag_tab/screens/product_details/product_card.dart';
// import 'package:pay_tag_tab/screens/product_details/product_details_controller.dart'; // Import the ProductDetails model

// class ProductSlider extends StatefulWidget {
//   final List<ProductDetails> products;

//   const ProductSlider({super.key, required this.products});

//   @override
//   State<ProductSlider> createState() => ProductSliderState();
// }

// class ProductSliderState extends State<ProductSlider> {
//   final PageController _pageController = PageController(viewportFraction: 0.8);
//   int _currentPage = 0;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 300, // Adjust height as needed
//       child: PageView.builder(
//         controller: _pageController,
//         itemCount: widget.products.length,
//         itemBuilder: (context, index) {
//           final product = widget.products[index];
//           return AnimatedBuilder(
//             animation: _pageController,
//             builder: (context, child) {
//               double value = 1.0;
//               if (_pageController.position.haveDimensions) {
//                 value = _pageController.page! - index;
//                 value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
//               }
//               return Center(
//                 child: SizedBox(
//                   height: Curves.easeInOut.transform(value) * 300,
//                   width: Curves.easeInOut.transform(value) * 250,
//                   child: child,
//                 ),
//               );
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(0.0), // Remove padding from the ProductCard
//               child: ProductCard(
//                 title: product.name, 
//                 color: product.color, 
//                 size: product.size, 
//                 price: product.price, 
//                 imageUrl: product.imageUrl,
//               ),
//             ),
//           );
//         },
//         onPageChanged: (index) {
//           setState(() {
//             _currentPage = index;
//           });
//         },
//       ),
//     );
//   }
// }