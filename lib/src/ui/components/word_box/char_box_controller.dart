import 'package:get/get.dart';

class CharBoxController extends GetxController{

  var char = ''.obs;

  void changeCharacter(String char){
    this.char.value = char;
  }

}