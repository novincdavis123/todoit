import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoit/features/auth/presentation/pages/register_page.dart';
import 'package:todoit/features/auth/presentation/providers/auth_provider.dart';
import 'package:todoit/features/auth/presentation/providers/auth_state.dart';
import 'package:todoit/features/auth/presentation/providers/controller_providers.dart';
import 'package:todoit/features/tasks/presentation/pages/tasks_page.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  Future<void> _login(BuildContext context, WidgetRef ref) async {
    final emailController = ref.read(emailControllerProvider);
    final passwordController = ref.read(passwordControllerProvider);

    // Simple validation
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter email & password')));
      return;
    }

    // Call login method
    final authNotifier = ref.read(authProvider.notifier);
    await authNotifier.login(
      emailController.text.trim(),
      passwordController.text.trim(),
    );

    final state = ref.read(authProvider);

    if (state.status == AuthStatus.authenticated) {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const TasksPage()),
        );
      }
    } else if (state.status == AuthStatus.error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.error ?? 'Login failed')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    final emailController = ref.watch(emailControllerProvider);
    final passwordController = ref.watch(passwordControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Email
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Password
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),

                // Login button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: authState.status == AuthStatus.loading
                        ? null
                        : () => _login(context, ref),
                    child: authState.status == AuthStatus.loading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Login'),
                  ),
                ),

                const SizedBox(height: 16),

                // Navigate to Register
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    );
                  },
                  child: const Text('Don’t have an account? Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
