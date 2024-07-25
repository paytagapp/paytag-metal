class ServerData {
  List<String> cart = [];
  bool hasCart = false;
  Map<String, dynamic> tagDict = {};
  dynamic lastServerResult;

  ServerData.fromJson(Map<String, dynamic> json) {
    cart = (json['cart'] as List<dynamic>).cast<String>();
    hasCart = json['has_cart'];
    tagDict = (json['tag_dict'] as Map<String, dynamic>);
    lastServerResult = json['last_server_result'];
  }
}