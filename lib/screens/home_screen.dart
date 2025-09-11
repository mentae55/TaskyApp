import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/custom_task.dart';
import '../constants/task.dart';
import '../controllers/provider/theme_manger_provider.dart';
import '../core/achieved_tasks_card.dart';
import '../core/high_priority_tasks.dart';
import '../service/task_sql_service.dart';
import '../service/username_shared_preferences_service.dart';
import 'add_task_screen.dart';

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
  final TaskSqlService _dbService = TaskSqlService();

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
        toolbarHeight: 72,
        title: Row(
          children: [
            CircleAvatar(child: Image.asset('assets/images/me.png')),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Good Evening, $username",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontFamily: "Poppins",
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    bio,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: "Poppins",
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(50),
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
                      fontSize: 32,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "almost done ! ",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 32,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      SvgPicture.asset(
                        'assets/images/wave.svg',
                        width: 32,
                        height: 32,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AchievedTasksCard(
                    doneTasks: task.where((t) => t.isDone).length,
                    totalTasks: task.length,
                  ),
                  const SizedBox(height: 8),
                  HighPriorityTasksCard(
                    tasks: task,
                    onToggle: (t) => isSelected(t),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 16),
                    child: Text(
                      "My Tasks ",
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontSize: 20,
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
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
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
            fontSize: 14,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
