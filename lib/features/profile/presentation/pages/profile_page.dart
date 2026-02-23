import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoit/features/auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the profile state (from FirebaseAuth)
    final profile = ref.watch(profileProvider);
    final authNotifier = ref.read(authProvider.notifier);

    // Show loading if user not logged in (should rarely happen)
    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Controllers for name input
    final nameController = TextEditingController(text: profile.name);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Name input
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              onFieldSubmitted: (value) {
                if (value.isNotEmpty) {
                  ref
                      .read(profileProvider.notifier)
                      .updateProfile(profile.copyWith(name: value));
                }
              },
            ),
            const SizedBox(height: 16),

            // Dark mode toggle (local only for now)
            SwitchListTile(
              value: profile.isDarkMode,
              title: const Text('Dark Mode'),
              onChanged: (val) => ref
                  .read(profileProvider.notifier)
                  .updateProfile(profile.copyWith(isDarkMode: val)),
            ),
            const SizedBox(height: 24),

            // Logout button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await authNotifier.logout();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
                child: const Text('Logout'),
              ),
            ),

            const SizedBox(height: 16),

            // Display email
            Text('Email: ${profile.email}'),
          ],
        ),
      ),
    );
  }
}
