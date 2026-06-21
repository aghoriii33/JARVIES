import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import 'image_result_grid.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isAi;
  final String time;
  final List<String>? imageUrls;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isAi,
    required this.time,
    this.imageUrls,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the text contains code snippets block to style it separately
    final containsCode = text.contains('```');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isAi ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isAi) ...[
            Container(
              margin: const EdgeInsets.only(right: 10, bottom: 4),
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.purple,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome, size: 12, color: Colors.white),
            ),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isAi ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: isAi ? null : AppColors.primaryGradient,
                    color: isAi ? AppColors.surface : null,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: isAi ? Radius.zero : const Radius.circular(18),
                      bottomRight: isAi ? const Radius.circular(18) : Radius.zero,
                    ),
                    border: isAi
                        ? Border.all(color: AppColors.border)
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (containsCode)
                        _buildCodeFormattedText(text)
                      else
                        Text(
                          text,
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      if (imageUrls != null && imageUrls!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        ImageResultGrid(imageUrls: imageUrls!),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: GoogleFonts.inter(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          if (!isAi) ...[
            Container(
              margin: const EdgeInsets.only(left: 10, bottom: 4),
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AppColors.surface2,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_rounded,
                  size: 16, color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 250.ms).scale(
          begin: const Offset(0.96, 0.96),
          alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
        );
  }

  Widget _buildCodeFormattedText(String content) {
    final List<Widget> widgets = [];
    final RegExp codeRegex = RegExp(r'```([a-zA-Z]*)\n([\s\S]*?)```');
    
    int start = 0;
    for (final Match match in codeRegex.allMatches(content)) {
      // Add text before code block
      if (match.start > start) {
        final textPart = content.substring(start, match.start).trim();
        if (textPart.isNotEmpty) {
          widgets.add(Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              textPart,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 14, height: 1.5),
            ),
          ));
        }
      }

      // Add code block
      final lang = match.group(1) ?? 'code';
      final code = match.group(2) ?? '';

      widgets.add(Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Code header tab
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: const BoxDecoration(
                color: AppColors.surface3,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lang.toUpperCase(),
                    style: GoogleFonts.firaCode(
                      color: AppColors.cyan,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Copy code logic could go here
                    },
                    child: const Icon(
                      Icons.copy_rounded,
                      size: 14,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            // Code block content
            Padding(
              padding: const EdgeInsets.all(12),
              child: SelectableText(
                code.trim(),
                style: GoogleFonts.firaCode(
                  color: const Color(0xFFE2E8F0),
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ));

      start = match.end;
    }

    // Add trailing text
    if (start < content.length) {
      final trailingText = content.substring(start).trim();
      if (trailingText.isNotEmpty) {
        widgets.add(Text(
          trailingText,
          style: GoogleFonts.inter(color: Colors.white, fontSize: 14, height: 1.5),
        ));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}
