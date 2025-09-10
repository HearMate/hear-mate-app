import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppIdManager {
  static Future<String> getAppInstanceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('app_instance_id');
    if (id == null) {
      id = Uuid().v4();
      await prefs.setString('app_instance_id', id);
    }
    return id;
  }
}
