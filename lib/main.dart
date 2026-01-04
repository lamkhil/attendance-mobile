import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
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
            themeMode: ThemeMode.system,
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
          ),
        );
      },
    );
  }
}
