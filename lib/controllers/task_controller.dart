import 'package:get/get.dart';
import '../db/db_helper.dart';
import '../models/task_model.dart';

class TaskController extends GetxController {

  @override
  void onReady() {
    super.onReady();
    getTasks();
  }

  var taskList = <Task>[].obs;
  var filteredTaskList = <Task>[].obs;
  var isSearching = false.obs;
  var selectedCategory = 'All'.obs;
  var selectedPriority = 'All'.obs;

  Future<int> addTask({Task? task}) async {
    return await DBHelper.instance.insert(task!);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.instance.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
    filterTasks();
  }

  Future<void> delete(Task task) async {
    await DBHelper.instance.delete(task);
    getTasks();
  }

  Future<void> markTaskCompleted(int id) async {
    await DBHelper.instance.updateCompleted(id);
    getTasks();
  }

  Future<void> updateTaskInfo(Task task) async {
    await DBHelper.instance.updateTask(task);
    getTasks();
  }

  void filterTasks() {
    List<Task> tempTasks = taskList;

    if (selectedCategory.value != 'All') {
      tempTasks = tempTasks
          .where((task) => task.category == selectedCategory.value)
          .toList();
    }

    if (selectedPriority.value != 'All') {
      tempTasks = tempTasks
          .where((task) => task.priority == selectedPriority.value)
          .toList();
    }

    filteredTaskList.assignAll(tempTasks);
  }

  void searchTasks(String query) {
    if (query.isEmpty) {
      isSearching.value = false;
      filterTasks();
    } else {
      isSearching.value = true;
      List<Task> tempTasks = taskList.where((task) {
        return task.title!.toLowerCase().contains(query.toLowerCase()) ||
            task.description!.toLowerCase().contains(query.toLowerCase());
      }).toList();
      filteredTaskList.assignAll(tempTasks);
    }
  }

  void updateCategory(String category) {
    selectedCategory.value = category;
    filterTasks();
  }

  void updatePriority(String priority) {
    selectedPriority.value = priority;
    filterTasks();
  }
}
