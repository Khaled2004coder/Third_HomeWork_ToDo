import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../controllers/task_controller.dart';
import '../models/task_model.dart';
import '../utils/theme.dart';
import '../widgets/task_tile.dart';
import 'add_task_screen.dart';
import 'task_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _taskController = Get.put(TaskController());
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          _addTaskBar(),
          _searchBar(),
          _filterBar(),
          SizedBox(height: 20),
          _showTasks(),
        ],
      ),
    );
  }

  _searchBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          _taskController.searchTasks(value);
        },
        decoration: InputDecoration(
          hintText: "Search tasks...",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  _filterBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => DropdownButton<String>(
              value: _taskController.selectedCategory.value,
              items: <String>['All', 'Work', 'Personal', 'Shopping', 'Health']
                  .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  })
                  .toList(),
              onChanged: (newValue) {
                _taskController.updateCategory(newValue!);
              },
            ),
          ),
          Obx(
            () => DropdownButton<String>(
              value: _taskController.selectedPriority.value,
              items: <String>['All', 'Low', 'Medium', 'High'].map((
                String value,
              ) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                _taskController.updatePriority(newValue!);
              },
            ),
          ),
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        if (_taskController.taskList.isEmpty) {
          return _noTaskMsg();
        } else {
          var tasks =
              _taskController.isSearching.value ||
                  _taskController.selectedCategory.value != 'All' ||
                  _taskController.selectedPriority.value != 'All'
              ? _taskController.filteredTaskList
              : _taskController.taskList;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (_, index) {
              Task task = tasks[index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => TaskDetailScreen(task: task));
                },
                child: TaskTile(
                  task,
                  onEdit: () async {
                    await Get.to(() => AddTaskScreen(task: task));
                    _taskController.getTasks();
                  },
                  onDelete: () {
                    _deleteTask(task);
                  },
                ),
              );
            },
          );
        }
      }),
    );
  }

  _noTaskMsg() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task, size: 80, color: Colors.grey),
          Text("No tasks found!", style: subTitleStyle),
        ],
      ),
    );
  }

  _deleteTask(Task task) {
    Get.defaultDialog(
      title: "Delete Task",
      middleText: "Are you sure you want to delete this task?",
      textCancel: "Cancel",
      textConfirm: "Delete",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        await _taskController.delete(task);
        Get.back(); // close dialog
      },
      onCancel: () {},
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text("Today", style: headingStyle),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              await Get.to(() => AddTaskScreen());
              _taskController.getTasks();
            },
            child: Container(
              width: 120,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: primaryClr,
              ),
              alignment: Alignment.center,
              child: Text("+ Add Task", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        CircleAvatar(
          child: Icon(Icons.person),
          backgroundColor: Colors.grey[200],
        ),
        SizedBox(width: 20),
      ],
    );
  }
}

class ThemeService {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);
  bool _loadThemeFromBox() => _box.read(_key) ?? false;
  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
  }
}
