import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/entity/sepetler.dart';
import 'package:food_delivery/entity/yemekler.dart';
import 'package:food_delivery/repository/sepetdao_repository.dart';

class BasketPageCubit extends Cubit<List<Sepetler>> {
  BasketPageCubit() : super([]);

  var yRepo = SepetDaoRepository();

  Future<void> addToSepet(
      Yemekler yemek, String kullanici_adi, int yemek_siparis_adet) async {
    await yRepo.addToSepet(yemek, kullanici_adi, yemek_siparis_adet);
  }

  Future<void> addToSepetWithoutCheck(
      Yemekler yemek, String kullanici_adi, int yemek_siparis_adet) async {
    await yRepo.addToSepetWithoutCheck(yemek, kullanici_adi, yemek_siparis_adet);
  }


  Future<void> getSepet(String kullanici_adi) async {
    var sepetler = await yRepo.getSepet(kullanici_adi);
    emit(sepetler);
  }

  Future<void> deleteFromSepet(int sepet_yemek_id, String kullanici_adi) async {
    await yRepo.deleteFromSepet(sepet_yemek_id, kullanici_adi);
  }
}

class BasketTotalCubit extends Cubit<String> {
  BasketTotalCubit() : super("");

  var yRepo = SepetDaoRepository();

  Future<void> getTotalAmount(String kullanici_adi) async {
    emit(await yRepo.getTotalAmount());
  }
}

