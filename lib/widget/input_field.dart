import 'package:flutter/material.dart';
import 'package:uboyniy_cex/util/util.dart';

class InputField extends StatelessWidget {
  const InputField({
    required this.title,
    this.enabled = true,
    this.controller,
    super.key,
  });

  final TextEditingController? controller;
  final String title;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.theme.textTheme.titleLarge?.copyWith(
            color: context.theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          enabled: enabled,
          style: context.theme.textTheme.bodyLarge?.copyWith(
            color: context.theme.colorScheme.onSurface,
          ),
          decoration: const InputDecoration(
            suffixText: 'Kg',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
