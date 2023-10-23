import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:uboyniy_cex/util/util.dart';

class AnimalInfoText extends StatelessWidget {
  const AnimalInfoText({required this.title, required this.value, super.key});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: context.theme.textTheme.titleMedium?.copyWith(
              color: context.theme.colorScheme.onSurface,
            ),
          ),
          Flexible(
            child: AutoSizeText(
              value,
              style: context.theme.textTheme.bodyLarge?.copyWith(
                color: context.theme.colorScheme.onSurface,
              ),
              maxLines: 2,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      );
}
