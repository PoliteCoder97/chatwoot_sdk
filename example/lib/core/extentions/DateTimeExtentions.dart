import 'package:intl/intl.dart';


extension DateTimeExtentions on DateTime {
  String formatDate() =>
      DateFormat.yMEd("fa").format(this);
  int differenceWithDayCount(DateTime date){
    return difference(date).inDays;
  }
}
