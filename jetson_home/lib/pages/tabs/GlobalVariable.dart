import 'package:flutter/cupertino.dart';

class GlobalVariable extends ChangeNotifier {
  String temperature = '-';
  String humidity = '-';
  bool fanSwitchValue = false;
  bool humidifierSwitchValue = false;
  bool heaterSwitchValue = false;

  void updateData({required String temperature, required String humidity,
    required bool fanSwitchValue, required bool humidifierSwitchValue, required bool heaterSwitchValue}) {
    this.temperature = temperature;
    this.humidity = humidity;
    this.fanSwitchValue = fanSwitchValue;
    this.humidifierSwitchValue = humidifierSwitchValue;
    this.heaterSwitchValue = heaterSwitchValue;
    notifyListeners();
  }
}
