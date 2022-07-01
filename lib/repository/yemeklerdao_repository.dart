import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:food_delivery/entity/yemekler.dart';
import 'package:food_delivery/entity/yemekler_cevap.dart';

class YemeklerDaoRepository {
  List<Yemekler> parseYemeklerCevap(String response) {
    return YemeklerCevap.fromJson(json.decode(response)).yemekler;
  }

  Future<List<Yemekler>> getYemekler() async {
    var url = "http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php";
    var response = await Dio().get(url);

    var yemek = parseYemeklerCevap(response.data);

    return parseYemeklerCevap(response.data);
  }

  Future<List<Yemekler>> getYemeklerWithKeyword(String keyword) async {
    var url = "http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php";
    var response = await Dio().get(url);

    var yemek = parseYemeklerCevap(response.data);

    var parsedYemekler = parseYemeklerCevap(response.data);

    return parsedYemekler.where((element) => element.yemek_adi.toLowerCase().contains(keyword.toLowerCase())).toList();

  }
}
