import 'package:flutter/material.dart';
import 'package:safe_line/auth/auth_service.dart';

class ProfileTabBar extends StatefulWidget {
  const ProfileTabBar({super.key});

  @override
  State<ProfileTabBar> createState() => _ProfileTabBarState();
}

class _ProfileTabBarState extends State<ProfileTabBar> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await AuthService.firebase().logout();
        if (context.mounted) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/login/', (route) => false);
        }
      },
      child: const Text("Logout"),
    );
  }
}
