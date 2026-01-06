import 'package:absensi/app/global/bindings/app_binding.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔴 INI YANG WAJIB
  await initializeDateFormatting('id_ID', null);
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final brightness = MediaQuery.platformBrightnessOf(context);
        final isDarkMode = brightness == Brightness.dark;

        return FlutterWebFrame(
          maximumSize: const Size(475.0, 812.0),
          enabled: kIsWeb,
          backgroundColor: isDarkMode ? Colors.black : Colors.grey.shade200,
          builder: (context) => GetMaterialApp(
            title: "eHadir",
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            debugShowCheckedModeBanner: false,
            initialBinding: AppBinding(),
            themeMode: ThemeMode.light,
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
          ),
        );
      },
    );
  }
}
