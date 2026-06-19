import 'package:flutter/material.dart';
import 'package:notes_manager/core/app_colors.dart';
import 'package:notes_manager/core/custom_textstyles.dart';

Future<bool?> showConfirmDialog(
  BuildContext context,
  String msg, {
  String title = "Are you sure?",
  String yesText = "Yes",
  String noText = "No",
  IconData icon = Icons.help_outline_rounded,
}) {
  final screenWidth = MediaQuery.sizeOf(context).width;
  final screenHeight = MediaQuery.sizeOf(context).height;

  final dialogWidth = screenWidth < 480
      ? screenWidth * 0.9
      : screenWidth < 900
      ? 420.0
      : 440.0;

  final horizontalPadding = screenWidth < 360 ? 18.0 : 24.0;

  return showDialog<bool>(
    context: context,
    barrierColor: AppColors.blackColor.withOpacity(0.4),
    builder: (_) => Dialog(
      backgroundColor: AppColors.transparentColor,
      insetPadding: EdgeInsets.symmetric(
        horizontal: screenWidth < 480 ? 20 : 0,
        vertical: 24,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: dialogWidth,
          maxHeight: screenHeight * 0.85,
        ),
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              28,
              horizontalPadding,
              20,
            ),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.blackColor.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.dilogIconColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.dilogIconColor, size: 32),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  title,
                  style: CustomTextstyles.b18700,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                Text(
                  msg,
                  style: CustomTextstyles.b14400,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 280;

                    final noButton = OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Color(0xFFD1D5DB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(noText, style: CustomTextstyles.noText),
                    );

                    final yesButton = ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.dilogConfirmColor,
                        foregroundColor: AppColors.whiteColor,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(yesText, style: CustomTextstyles.yesText),
                    );

                    if (isNarrow) {
                      return Column(
                        children: [
                          SizedBox(width: double.infinity, child: yesButton),
                          const SizedBox(height: 10),
                          SizedBox(width: double.infinity, child: noButton),
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(child: noButton),
                        const SizedBox(width: 12),
                        Expanded(child: yesButton),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
