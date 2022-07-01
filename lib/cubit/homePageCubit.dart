import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/entity/yemekler.dart';
import 'package:food_delivery/repository/yemeklerdao_repository.dart';

class FoodPageCubit extends Cubit<List<Yemekler>> {
  FoodPageCubit() : super([]);

  var yRepo = YemeklerDaoRepository();

  Future<void> getYemekler() async {
    var yemekler = await yRepo.getYemekler();
    emit(yemekler);
  }

  Future<void> getYemeklerWithKeyword(String keyword) async {
    var yemekler = await yRepo.getYemeklerWithKeyword(keyword);
    emit(yemekler);
  }
}
