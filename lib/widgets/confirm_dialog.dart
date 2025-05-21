import 'package:flutter/material.dart';
import '../screens/font_styles.dart';

Future<bool?> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String cancelText = 'Cancel',
  String confirmText = 'Confirm',
  Color confirmColor = Colors.redAccent,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFFECEAFF),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: FontStyles.heading(context, fontSize: 22, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: FontStyles.body(context, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(cancelText, style: FontStyles.body(context, color: Colors.deepPurple)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: confirmColor,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(confirmText, style: FontStyles.body(context, color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
