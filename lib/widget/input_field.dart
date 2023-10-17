import 'package:flutter/material.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/util/util.dart';

class InputField extends StatelessWidget {
  const InputField({
    required this.title,
    this.enabled = true,
    this.controller,
    this.countingStrategy,
    super.key,
  });

  final TextEditingController? controller;
  final String title;
  final bool enabled;
  final CountingStrategy? countingStrategy;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.theme.textTheme.titleMedium?.copyWith(
            color: context.theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: countingStrategy != null
              ? TextInputType.numberWithOptions(
                  decimal: countingStrategy == CountingStrategy.weight,
                )
              : null,
          enabled: enabled,
          style: context.theme.textTheme.bodyLarge?.copyWith(
            color: context.theme.colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            suffixText: countingStrategy?.name,
            suffixStyle: context.theme.textTheme.bodyLarge?.copyWith(
              color: context.theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
