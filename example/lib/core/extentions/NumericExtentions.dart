
import 'package:example/core/extentions/StringExtentions.dart';

import '../classes/Strings.dart';

RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
String Function(Match match) mathFunc = (Match match) => '${match[1]},';

extension seaprateDoubleNumbers on double {
  String seprateNumber() {
    String modifiedNumber = this.toString();
    modifiedNumber = modifiedNumber.replaceAllMapped(reg, mathFunc);
    return modifiedNumber;
  }
  String inMegabytes() => "$this مگابایت ";
}

extension seaprateIntNumbers on int {
  String seprateNumber() {
    String modifiedNumber = this.toString();
    modifiedNumber = modifiedNumber.replaceAllMapped(reg, mathFunc);
    return modifiedNumber;
  }
  String twoDigits() => this >= 10 ? "$this" : "0$this";
  String inDays() => "$this ${Strings.txtDays.translate()}";
}
