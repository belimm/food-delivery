import 'package:food_delivery/entity/yemekler.dart';

class YemeklerCevap {
  List<Yemekler> yemekler;
  int success;

  YemeklerCevap({ required this.yemekler, required this.success});

  factory YemeklerCevap.fromJson(Map<String, dynamic> json) {
    return YemeklerCevap(
        yemekler: (json["yemekler"] as List<dynamic>)
            .map((e) => Yemekler.fromJson(e as Map<String, dynamic>))
            .toList(),
        success: json["success"] as int
    );
  }
}
