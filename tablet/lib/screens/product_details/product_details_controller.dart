import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductDetails {
  final String barcode;
  final String article;
  final String name;
  final String color;
  final String imageUrl;
  final String size;
  final double price;
  final double realPrice;
  final double? discountPrice;
  final String itemCode;
  final String itemDescription;
  final String sizeCode;
  final String colorCode;
  final String storeId;
  final String branchId;
  final List<String> tagId;

  ProductDetails({
    required this.barcode,
    required this.article,
    required this.name,
    required this.color,
    required this.imageUrl,
    required this.size,
    required this.price,
    required this.realPrice,
    this.discountPrice,
    required this.itemCode,
    required this.itemDescription,
    required this.sizeCode,
    required this.colorCode,
    required this.storeId,
    required this.branchId,
    required this.tagId,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      barcode: json['barcode'],
      article: json['article'],
      name: json['name'],
      color: json['color'],
      imageUrl: json['image_url'],
      size: json['size'],
      price: json['price'].toDouble(),
      realPrice: json['real_price'].toDouble(),
      discountPrice: json['discount_price']?.toDouble(),
      itemCode: json['item_code'],
      itemDescription: json['item_description'],
      sizeCode: json['size_code'],
      colorCode: json['color_code'],
      storeId: json['store_id'],
      branchId: json['branch_id'],
      tagId: List<String>.from(json['tag_id']),
    );
  }
}

class ProductDetailsController {
  final String baseUrl =
      'https://dev01api.paytagapp.com'; // Replace with your server IP or domain
      // 'http://127.0.0.1:1337'; // Replace with your server IP or domain

  Future<void> processMessage(BuildContext context, Map<String, dynamic> data,
      Function(List<ProductDetails>) onProcessed) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/get_product_details_by_tag_id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'tag_id': data['tag_id']}),
      );

      if (response.statusCode == 200) {
        try {
          final List<dynamic> responseData = jsonDecode(response.body);
          final List<ProductDetails> products = responseData
              .map((product) => ProductDetails.fromJson(product))
              .toList();
          onProcessed(products);
        } catch (e) {
          print('Error decoding JSON: $e');
        }
      } else {
        print(
            'Error response status not 200: ${response.statusCode} ${response.reasonPhrase}');
      }
    } on http.ClientException catch (e) {
      print('HTTP Client Exception: $e');
    } catch (e) {
      print('Exception occurred: $e');
    }
  }

  Map<String, dynamic> extractDataFromMessage(String message) {
    try {
      final decodedData = jsonDecode(message);

      if (decodedData is Map<String, dynamic> &&
          decodedData.containsKey('unpaidTags')) {
        final unpaidTags = decodedData['unpaidTags'] as List<dynamic>;
        return {'tag_id': unpaidTags};
      } else {
        print('Error: Invalid JSON format or missing "unpaidTags" key');
        return {}; // Return an empty map
      }
    } catch (e) {
      print('Error decoding message: $e');
      return {}; // Return an empty map
    }
  }
}








































// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

// class ProductDetailsController {
//   Future<void> processMessage(BuildContext context, Map<String, dynamic> data,
//       Function(dynamic) onProcessed) async {
//     final response = await ParseCloudFunction("get_product_details_by_tag_id")
//         .execute(parameters: {
//       "tag_id": data["tag_id"],
//     });

//     if (response.success) {
//       final responseData = response.result;
//       onProcessed(responseData);
//     } else {
//       // Handle error
//       print("Error: ${response.error?.message}");
//     }
//   }

//   Map<String, dynamic> extractDataFromMessage(String message) {
//     final decodedData = jsonDecode(message);

//     if (decodedData is Map<String, dynamic>) {
//       final unpaidTags = decodedData["unpaidTags"] as List<dynamic>;
//       return {"tag_id": unpaidTags};
//     } else {
//       print("Error: Invalid JSON format");
//       return {}; // Return an empty map
//     }
//   }
// }
