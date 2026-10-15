import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../routes/app_pages.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/input_bottom_sheet.dart';
export 'formatters.dart';

class AppHelpers {
  AppHelpers._();

  static void showSnackbar({
    required String title,
    required String message,
    bool isError = false,
  }) {
    final messenger = rootScaffoldMessengerKey.currentState;
    if (messenger == null) return;

    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: isError ? AppColors.error : AppColors.primaryDark,
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void showLoadingDialog([String message = 'Memuat...']) {
    final context = rootNavigatorKey.currentContext;
    if (context == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
                const SizedBox(width: 16),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void hideLoadingDialog() {
    final context = rootNavigatorKey.currentContext;
    if (context != null && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  static Future<bool?> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Konfirmasi',
    String cancelText = 'Batal',
    IconData icon = Icons.help_outline_rounded,
    Color? iconColor,
    Color? iconBackgroundColor,
    bool isDestructive = false,
  }) {
    return AppConfirmationDialog.show(
      context: context,
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      icon: icon,
      iconColor: iconColor,
      iconBackgroundColor: iconBackgroundColor,
      isDestructive: isDestructive,
    );
  }

  static Future<bool?> showLogoutConfirmationDialog({
    required BuildContext context,
  }) {
    return AppConfirmationDialog.showLogout(context: context);
  }

  static Future<void> showInputBottomSheet({
    required BuildContext context,
    required String title,
    String? subtitle,
    required TextEditingController controller,
    required String hintText,
    int maxLines = 5,
    String submitLabel = 'Submit',
    required ValueChanged<String> onSubmit,
  }) {
    return AppInputBottomSheet.show(
      context: context,
      title: title,
      subtitle: subtitle,
      controller: controller,
      hintText: hintText,
      maxLines: maxLines,
      submitLabel: submitLabel,
      onSubmit: onSubmit,
    );
  }
}
