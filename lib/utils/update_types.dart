import '../db/db_helper.dart';

/// دالة تُشغّل مرة واحدة لتحديث/إضافة أنواع المهام إلى الإنجليزية.
Future<void> updateTaskTypesToEnglish() async {
  final db = await DBHelper.instance.mydb;

  // إضافة الأنواع الإنجليزية
  await DBHelper.instance.insertType('General');
  await DBHelper.instance.insertType('Work');
  await DBHelper.instance.insertType('Study');
  await DBHelper.instance.insertType('Personal');
  await DBHelper.instance.insertType('Shopping');
  await DBHelper.instance.insertType('Health');

  // استبدال الأسماء العربية بالإنجليزية
  try {
    await db.rawUpdate("UPDATE task_types SET name = ? WHERE name = ?", ['General', 'عام']);
    await db.rawUpdate("UPDATE task_types SET name = ? WHERE name = ?", ['Work', 'عمل']);
    await db.rawUpdate("UPDATE task_types SET name = ? WHERE name = ?", ['Study', 'دراسة']);
    await db.rawUpdate("UPDATE task_types SET name = ? WHERE name = ?", ['Personal', 'شخصي']);
    await db.rawUpdate("UPDATE task_types SET name = ? WHERE name = ?", ['Shopping', 'تسوق']);
    await db.rawUpdate("UPDATE task_types SET name = ? WHERE name = ?", ['Health', 'صحة']);
  } catch (e) {
    print("Update types error: $e");
  }

  // طباعة النتيجة في الكونسول
  final rows = await DBHelper.instance.getAllTypes();
  print('--- task_types after update ---');
  for (var r in rows) {
    print(r);
  }
}
