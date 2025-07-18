import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ServiceButton extends StatelessWidget {
  final String title;
  final String logoPath;
  final VoidCallback onPressed;

  const ServiceButton({
    super.key,
    required this.title,
    required this.logoPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor:
            WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(10.0.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              fit: BoxFit.cover,
              logoPath,
              width: 50.w,
              height: 50.h,
            ),
            SizedBox(width: 15.0.w),
            Text(
              overflow: TextOverflow.ellipsis,
              title,
              softWrap: true,
              style: TextStyle(
                  fontSize: 16.0.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
          ],
        ),
      ),
    );
  }
}
