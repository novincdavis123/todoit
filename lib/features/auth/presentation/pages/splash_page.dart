import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoit/features/auth/presentation/pages/login_page.dart';
import 'package:todoit/features/auth/presentation/providers/auth_provider.dart';
import 'package:todoit/features/auth/presentation/providers/auth_state.dart';
import 'package:todoit/features/tasks/presentation/pages/tasks_page.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    // Call loadCurrentUser from AuthNotifier
    await ref.read(authProvider.notifier).loadCurrentUser();

    final authState = ref.read(authProvider);

    // Navigate based on auth status
    if (authState.status == AuthStatus.authenticated) {
      _navigateToDashboard();
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const TasksPage()),
    );
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading...', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
