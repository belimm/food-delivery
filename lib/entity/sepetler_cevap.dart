import 'package:food_delivery/entity/sepetler.dart';

class SepetlerCevap {
  List<Sepetler> sepet_yemekler ;
  int success;

  SepetlerCevap({
    required this.sepet_yemekler,
    required this.success,
  });

 factory SepetlerCevap.fromJson(Map<String, dynamic> json) => SepetlerCevap(
        sepet_yemekler: List<Sepetler>.from(json["sepet_yemekler"].map((x) => Sepetler.fromJson(x))),
        success: json["success"],
    );
}

