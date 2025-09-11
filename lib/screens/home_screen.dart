import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tasky/service/task_hive_service.dart';
import '../core/controllers/provider/theme_manger_provider.dart';
import '../core/task_class/task_for_hive.dart';
import '../core/widgets/achieved_tasks_card.dart';
import '../core/widgets/custom_task.dart';
import '../core/widgets/high_priority_tasks.dart';
import '../service/username_shared_preferences_service.dart';
import 'add_task_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = "";
  List<Task> task = [];
  String bio = "";
  bool isLoading = false;
  final TaskHiveService _dbService = TaskHiveService();

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _loadUsername();
    _loadBio();
  }

  Future<void> _loadBio() async {
    final savedBio = await UserPreferences.getBio();
    setState(() {
      bio = savedBio ?? "No bio added yet";
    });
  }

  Future<void> _loadUsername() async {
    final savedUsername = await UserPreferences.getUsername();
    setState(() {
      username = savedUsername ?? "User";
    });
  }

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon";
    } else if (hour >= 17 && hour < 21) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

  Future<void> _loadTasks() async {
    setState(() => isLoading = true);
    try {
      final tasks = await _dbService.getTasks();
      setState(() {
        task = tasks;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (kDebugMode) {
        print('Error loading tasks: $e');
      }
    }
  }

  isSelected(Task task) async {
    final updatedTask = task.copyWith(isDone: !task.isDone);
    await _dbService.updateTask(updatedTask);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72.h,
        title: Row(
          children: [
            CircleAvatar(child: Image.asset('assets/images/me.png')),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${getGreeting()}, $username",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontFamily: "Poppins",
                      fontSize: 16.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    bio,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: "Poppins",
                      fontSize: 14.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              width: 34.w,
              height: 34.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: SvgPicture.asset(
                  Provider.of<ThemeManager>(context).isDarkMode
                      ? 'assets/images/sun.svg'
                      : 'assets/images/moon.svg',
                ),
                onPressed: () {
                  Provider.of<ThemeManager>(
                    context,
                    listen: false,
                  ).toggleTheme();
                },
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Yuhuu ,Your work Is ",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 32.sp,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "almost done ! ",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 32.sp,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/images/wave.svg',
                        width: 32.w,
                        height: 32.h,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  AchievedTasksCard(
                    doneTasks: task.where((t) => t.isDone).length,
                    totalTasks: task.length,
                  ),
                  SizedBox(height: 8.h),
                  HighPriorityTasksCard(
                    tasks: task,
                    onToggle: (t) => isSelected(t),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 24.h, bottom: 16.h),
                    child: Text(
                      "My Tasks ",
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontSize: 20.sp,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: task.length,
                    itemBuilder: (context, index) {
                      return CustomTask(
                        task: task[index],
                        onToggle: (_) => isSelected(task[index]),
                        onDelete: (deletedTask) {
                          setState(() {
                            task.removeWhere((t) => t.id == deletedTask.id);
                          });
                        },
                      );
                    },
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 12.h),
                  ),
                ],
              ),
            ),
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
          if (result == true) {
            _loadTasks();
          }
        },
        child: Text(
          "+ Add new Task",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontFamily: "Poppins",
            fontSize: 14.sp,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
