import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:uboyniy_cex/util/util.dart';

class AnimalPartInfoText extends StatelessWidget {
  const AnimalPartInfoText({
    required this.title,
    required this.value,
    super.key,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: AutoSizeText(
                title,
                style: context.theme.textTheme.titleMedium?.copyWith(
                  color: context.theme.colorScheme.onSurface,
                ),
                maxLines: 2,
              ),
            ),
            Text(
              value,
              style: context.theme.textTheme.bodyLarge?.copyWith(
                color: context.theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      );
}
