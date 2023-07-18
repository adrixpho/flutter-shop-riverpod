import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String apiURL = dotenv.env['API_URL'] ?? 'API_URL not found!!';

  static Future<void> initEnvironment() async {
    await dotenv.load(fileName: '.env');
  }
}
