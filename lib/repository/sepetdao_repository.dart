import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:food_delivery/entity/sepetler.dart';
import 'package:food_delivery/entity/sepetler_cevap.dart';
import 'package:food_delivery/entity/yemekler.dart';
import 'package:food_delivery/repository/user_repository.dart';

class SepetDaoRepository {
  List<Sepetler> parseSepetlerCevap(String response) {
    return SepetlerCevap.fromJson(json.decode(response)).sepet_yemekler;
  }

  Future<void> addToSepetWithoutCheck(
      Yemekler yemek, String kullanici_adi, int yemek_siparis_adet) async {
    var url = "http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php";

    var body = {
      "yemek_adi": yemek.yemek_adi,
      "yemek_resim_adi": yemek.yemek_resmi_adi,
      "yemek_fiyat": yemek.yemek_fiyat,
      "yemek_siparis_adet": yemek_siparis_adet,
      "kullanici_adi": kullanici_adi
    };

    var response = await Dio().post(url, data: FormData.fromMap(body));
  }

  Future<void> addToSepet(
      Yemekler yemek, String kullanici_adi, int yemek_siparis_adet) async {
    var url = "http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php";

    var kullaniciSepet = await getSepet(kullanici_adi);

    bool flag = false;
    String sepet_yemek_id = "";
    String amount = "";

    print("adding to sepet");

    for (var item in kullaniciSepet) {
      if (item.yemek_adi == yemek.yemek_adi) {
        flag = true;
        sepet_yemek_id = item.sepet_yemek_id;
        amount = item.yemek_siparis_adet;
        break;
      }
    }

    if (!flag) {
      var body = {
        "yemek_adi": yemek.yemek_adi,
        "yemek_resim_adi": yemek.yemek_resmi_adi,
        "yemek_fiyat": yemek.yemek_fiyat,
        "yemek_siparis_adet": yemek_siparis_adet,
        "kullanici_adi": kullanici_adi
      };

      var response = await Dio().post(url, data: FormData.fromMap(body));
    } else {
      await deleteFromSepet(int.parse(sepet_yemek_id), kullanici_adi);

      var body = {
        "yemek_adi": yemek.yemek_adi,
        "yemek_resim_adi": yemek.yemek_resmi_adi,
        "yemek_fiyat": yemek.yemek_fiyat,
        "yemek_siparis_adet": yemek_siparis_adet + int.parse(amount),
        "kullanici_adi": kullanici_adi
      };

      var response = await Dio().post(url, data: FormData.fromMap(body));
    }
  }

  Future<List<Sepetler>> getSepet(String kullanici_adi) async {
    var url = "http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php";

    var body = {"kullanici_adi": kullanici_adi};

    var response = await Dio().post(url, data: FormData.fromMap(body));

    var parseReponse = parseSepetlerCevap(response.data);

    parseReponse.sort(((a, b) => a.yemek_adi.compareTo(b.yemek_adi)));

    return parseReponse;
  }

  Future<void> deleteFromSepet(int sepet_yemek_id, String kullanici_adi) async {
    var url = "http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php";
    var body = {
      "kullanici_adi": kullanici_adi,
      "sepet_yemek_id": sepet_yemek_id
    };

    var response = await Dio().post(url, data: FormData.fromMap(body));
  }

  Future<String> getTotalAmount() async {
    
    var userRepository = UserRepository();
    var userName = await userRepository.getUserName();
    print("before await");
    var url = "http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php";

    var body = {"kullanici_adi": userName};
    var response = await Dio().post(url, data: FormData.fromMap(body));

    List<Sepetler> sepet = parseSepetlerCevap(response.data);
    int counter = 0;
    int totalPrice = 0;

    for (var s in sepet) {
      int fiyat = int.parse(s.yemek_fiyat);
      int adet = int.parse(s.yemek_siparis_adet);
      print(s.yemek_adi);

      totalPrice += fiyat * adet;
    }

    print("getTotalAmount $totalPrice");

    return "$totalPrice";
  }
}
