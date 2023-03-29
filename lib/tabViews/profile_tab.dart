import 'package:flutter/material.dart';
import 'package:safe_line/auth/auth_service.dart';
import 'package:safe_line/constants.dart';

class ProfileTabBar extends StatefulWidget {
  const ProfileTabBar({super.key});

  @override
  State<ProfileTabBar> createState() => _ProfileTabBarState();
}

class _ProfileTabBarState extends State<ProfileTabBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          SizedBox(
            width: 200,
            height: 200,
            child: Image.asset('asset/icons/profile.png'),
          ),
          const SizedBox(height: 15),
          profileOverviewWidget(context),
          topReportsWidget(context),
          Expanded(child: profileSettingWidget(context)),
        ],
      ),
    );
  }
}

Widget topReportsWidget(BuildContext context) {
  return SizedBox(
    width: 400,
    height: 200,
    child: Container(
      margin: const EdgeInsets.fromLTRB(5, 25, 5, 15),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Top Reports",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    ),
  );
}

Widget profileSettingWidget(BuildContext context) {
  return Container(
    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30.0),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () {
            // change password
          },
          child: const Text(
            "Change Password",
            style: TextStyle(
              decorationStyle: TextDecorationStyle.dashed,
              color: accentColor,
              fontFamily: 'Inter',
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            await AuthService.firebase().logout(context);
            /*
            if (context.mounted) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login/', (route) => false);
            }
            */
          },
          child: const Text(
            "Log Out",
            style: TextStyle(
              color: accentColor,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            // delete account
          },
          child: const Text(
            "Delete Account",
            style: TextStyle(
              color: accentColor,
              fontFamily: 'Inter',
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            // Show information about safeLine
          },
          child: const Text(
            "About SafeLine",
            style: TextStyle(
              color: accentColor,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    ),
  );
}

Widget profileOverviewWidget(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      SizedBox(
        width: 35,
        child: Image.asset('asset/badges/verified.png'),
      ),
      SizedBox(
        width: 125,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Karma Level",
              style: const TextStyle(
                  color: accentColor, fontFamily: 'Inter', fontSize: 12),
            ),
            Text(
              "Rookie",
              style: const TextStyle(
                color: accentColor,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            Text(
              "1500 left to go to Helping Hand",
              style: const TextStyle(
                color: accentColor,
                fontFamily: 'Inter',
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 50,
              child: Image.asset('asset/badges/karma_points.png'),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "5000",
                  style: const TextStyle(
                    color: accentColor,
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Text(
                  "Karma Points",
                  style: const TextStyle(
                    color: accentColor,
                    fontFamily: 'Inter',
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
