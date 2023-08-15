import 'package:intl/intl.dart';

class Session {
  late DateTime datetime;
  late String isGasDetect;

  Session({required this.datetime, required this.isGasDetect});

  String getFullDatetime() {
    return DateFormat('HH:mm EEEE, d MMM yyyy').format(datetime);
  }

  void updateStatus(status) {
    isGasDetect = status;
  }
}
