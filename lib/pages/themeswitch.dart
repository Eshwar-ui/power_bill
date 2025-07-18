import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:power_bill/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class ThemeSwitcherScreen extends StatelessWidget {
  const ThemeSwitcherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Themes'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0.w),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.all(10.w),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)),
              tileColor: Colors.white10,
              title: const Text('System Theme'),
              trailing: Radio<ThemeMode>(
                fillColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.inversePrimary),
                splashRadius: 20.r,
                value: ThemeMode.system,
                groupValue: themeProvider.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    themeProvider.setThemeMode(value);
                  }
                },
              ),
              onTap: () => themeProvider.setThemeMode(ThemeMode.system),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              contentPadding: EdgeInsets.all(10.w),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)),
              tileColor: Colors.white10,
              title: const Text('Light Theme'),
              trailing: Radio<ThemeMode>(
                fillColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.inversePrimary),
                value: ThemeMode.light,
                groupValue: themeProvider.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    themeProvider.setThemeMode(value);
                  }
                },
              ),
              onTap: () => themeProvider.setThemeMode(ThemeMode.light),
            ),
            SizedBox(
              height: 10.h,
            ),
            ListTile(
              contentPadding: EdgeInsets.all(10.w),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)),
              tileColor: Colors.white10,
              title: const Text('Dark Theme'),
              trailing: Radio<ThemeMode>(
                activeColor: Theme.of(context).colorScheme.inversePrimary,
                fillColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.inversePrimary),
                value: ThemeMode.dark,
                groupValue: themeProvider.themeMode,
                onChanged: (value) {
                  if (value != null) {
                    themeProvider.setThemeMode(value);
                  }
                },
              ),
              onTap: () => themeProvider.setThemeMode(ThemeMode.dark),
            ),
          ],
        ),
      ),
    );
  }
}
