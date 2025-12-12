import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';
import '../models/task_model.dart';
import '../utils/theme.dart';
import 'add_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final TaskController _taskController = Get.find<TaskController>();

  TaskDetailScreen({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var t = _taskController.taskList.firstWhere(
        (element) => element.id == task.id,
        orElse: () => task,
      );
      return Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: context.theme.scaffoldBackgroundColor,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Task Details",
            style: headingStyle.copyWith(fontSize: 20),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Get.to(() => AddTaskScreen(task: t));
              },
              icon: Icon(
                Icons.edit,
                color: Get.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.title ?? "", style: headingStyle),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  SizedBox(width: 5),
                  Text("Due: ${t.dueDate}", style: subTitleStyle),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.flag,
                    size: 16,
                    color: _getPriorityColor(t.priority),
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Priority: ${t.priority}",
                    style: subTitleStyle.copyWith(
                      color: _getPriorityColor(t.priority),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.category, size: 16, color: Colors.grey),
                  SizedBox(width: 5),
                  Text("Category: ${t.category}", style: subTitleStyle),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Description",
                style: titleStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(t.description ?? "", style: subTitleStyle),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (t.isCompleted == 0)
                    ElevatedButton.icon(
                      onPressed: () {
                        _taskController.markTaskCompleted(t.id!);
                        Get.back();
                        Get.snackbar("Success", "Task marked as completed");
                      },
                      icon: Icon(Icons.check),
                      label: Text("Complete"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryClr,
                      ),
                    ),
                  ElevatedButton.icon(
                    onPressed: () {
                      _taskController.delete(t);
                      Get.back();
                      Get.snackbar("Deleted", "Task deleted successfully");
                    },
                    icon: Icon(Icons.delete),
                    label: Text("Delete"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Color _getPriorityColor(String? priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
