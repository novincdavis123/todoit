import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoit/features/auth/presentation/providers/auth_provider.dart';
import 'package:todoit/features/profile/presentation/pages/profile_page.dart';
import 'package:todoit/features/tasks/domain/entities/task.dart';
import 'package:todoit/features/tasks/presentation/providers/task_provider.dart';

class TasksPage extends ConsumerStatefulWidget {
  const TasksPage({super.key});

  @override
  ConsumerState<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends ConsumerState<TasksPage> {
  final ScrollController _scrollController = ScrollController();
  String searchQuery = '';
  String filter = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = ref.read(authProvider).user?.uid;
      if (userId != null) {
        ref.read(taskProvider.notifier).loadTasks(userId);
      }
    });
  }

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final categoryController = TextEditingController();
    final priorityController = TextEditingController(text: '3');
    DateTime? dueDate;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: priorityController,
                decoration: const InputDecoration(labelText: 'Priority (1-5)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Due Date: '),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) dueDate = picked;
                      setState(() {});
                    },
                    child: Text(
                      dueDate == null
                          ? 'Select'
                          : '${dueDate!.toLocal()}'.split(' ')[0],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final userId = ref.read(authProvider).user?.uid;
              final priority = int.tryParse(priorityController.text) ?? 3;

              if (userId != null &&
                  titleController.text.isNotEmpty &&
                  categoryController.text.isNotEmpty &&
                  dueDate != null) {
                final task = Task(
                  id: '',
                  title: titleController.text.trim(),
                  category: categoryController.text.trim(),
                  priority: priority,
                  dueDate: dueDate!,
                  isCompleted: false,
                );

                await ref.read(taskProvider.notifier).addTask(task, userId);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskProvider);
    final tasks = taskState.tasks
        .where((task) {
          if (filter == 'Completed') return task.isCompleted;
          if (filter == 'Pending') return !task.isCompleted;
          return true;
        })
        .where(
          (task) =>
              task.title.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final userId = ref.read(authProvider).user?.uid;
          if (userId != null) {
            await ref.read(taskProvider.notifier).loadTasks(userId);
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Search by title',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => setState(() => searchQuery = v),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['All', 'Completed', 'Pending'].map((f) {
                  return ChoiceChip(
                    label: Text(f),
                    selected: filter == f,
                    onSelected: (_) => setState(() => filter = f),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: taskState.status == TaskStatus.loading
                  ? const Center(child: CircularProgressIndicator())
                  : tasks.isEmpty
                  ? const Center(child: Text('No tasks found'))
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return ListTile(
                          title: Text(task.title),
                          subtitle: Text(
                            'Category: ${task.category} | Due: ${task.dueDate.toLocal().toString().split(' ')[0]} | Priority: ${task.priority}',
                          ),
                          trailing: Checkbox(
                            value: task.isCompleted,
                            onChanged: (val) async {
                              final userId = ref.read(authProvider).user?.uid;
                              if (userId != null) {
                                await ref
                                    .read(taskProvider.notifier)
                                    .updateTask(
                                      task.copyWith(isCompleted: val ?? false),
                                      userId,
                                    );
                              }
                            },
                          ),
                          onTap: () {},
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
