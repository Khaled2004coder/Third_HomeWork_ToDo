// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'db/db_helper.dart';
import 'utils/theme.dart';
import 'views/home_screen.dart';
import 'package:get/get.dart';


// استيراد الدالة التي أنشأناها
import 'utils/update_types.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // التأكد من إنشاء/تهيئة DB
  await DBHelper.instance;

  // ====== شغل التحديث مرة واحدة ======
  // بعد التأكد من نجاح التحديث احذف أو علق السطر التالي
  await updateTaskTypesToEnglish();
  // ===================================

  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Task Manager',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeService().theme,
      home: const HomeScreen(),
    );
  }
}
