import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String color;
  final String size;
  final double price;
  final String imageUrl;

  const ProductCard({
    super.key,
    required this.title,
    required this.color,
    required this.size,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 222, // Fixed width
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        elevation: 3, // Shadow effect
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ?? 1)
                                    : null,
                              ),
                            );
                          }
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image);
                        },
                      )
                    : const Icon(Icons.broken_image),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          height: 20.4 / 17,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: 'Color ',
                                  style: const TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    height: 17.6 / 16,
                                    color: Color.fromRGBO(73, 83, 92, 1),
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: color,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Color.fromRGBO(73, 83, 92, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.left,
                              ),
                              const SizedBox(height: 4),
                              RichText(
                                text: TextSpan(
                                  text: 'Size ',
                                  style: const TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    height: 17.6 / 16,
                                    color: Color.fromRGBO(73, 83, 92, 1),
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: size,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Color.fromRGBO(73, 83, 92, 1),
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          Text(
                            '${price.toStringAsFixed(2)} €',
                            style: const TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              height: 17.1 / 20,
                              color: Color(0xFF051B30),
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}