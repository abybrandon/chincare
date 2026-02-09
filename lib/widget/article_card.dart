import 'package:chincare/data/article.dart';
import 'package:flutter/material.dart';
import '../model/article_model.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;

  const ArticleCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
        decoration: const BoxDecoration(
         color:Color(0xffF5F1E9),
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFE0E0E0),
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// IMAGE (LEFT)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                article.image,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 16),

            /// TITLE + SUBTITLE
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E2E2E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    article.subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6F6F6F),
                    ),
                  ),
                ],
              ),
            ),

            /// ARROW ICON (RIGHT)
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF9E9E9E),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
