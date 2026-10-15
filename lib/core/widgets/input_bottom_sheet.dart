import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import 'text_input.dart';

class AppInputBottomSheet extends StatelessWidget {
  final String title;
  final String? subtitle;
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final String submitLabel;
  final ValueChanged<String> onSubmit;

  const AppInputBottomSheet({
    super.key,
    required this.title,
    this.subtitle,
    required this.controller,
    required this.hintText,
    this.maxLines = 5,
    this.submitLabel = 'Submit',
    required this.onSubmit,
  });

  static Future<void> show({
    required BuildContext context,
    required String title,
    String? subtitle,
    required TextEditingController controller,
    required String hintText,
    int maxLines = 5,
    String submitLabel = 'Submit',
    required ValueChanged<String> onSubmit,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AppInputBottomSheet(
        title: title,
        subtitle: subtitle,
        controller: controller,
        hintText: hintText,
        maxLines: maxLines,
        submitLabel: submitLabel,
        onSubmit: onSubmit,
      ),
    );
  }

  void _handleSubmit(BuildContext context) {
    onSubmit(controller.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final bottomSafeArea = MediaQuery.paddingOf(context).bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        12,
        24,
        keyboardInset + bottomSafeArea + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SheetDragHandle(),
          const Gap(18),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          if (subtitle != null) ...[
            const Gap(4),
            Text(
              subtitle!,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const Gap(16),
          AppTextInput(
            controller: controller,
            hintText: hintText,
            maxLines: maxLines,
          ),
          const Gap(20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () => _handleSubmit(context),
              child: Text(
                submitLabel,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetDragHandle extends StatelessWidget {
  const _SheetDragHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
