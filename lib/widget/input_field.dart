import 'package:flutter/material.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/util/util.dart';

class InputField extends StatefulWidget {
  const InputField({
    required this.title,
    this.enabled = true,
    this.controller,
    this.countingStrategy,
    this.onChanged,
    this.isPassoword = false,
    super.key,
  });

  final TextEditingController? controller;
  final String title;
  final bool enabled;
  final CountingStrategy? countingStrategy;
  final void Function(String text)? onChanged;
  final bool isPassoword;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: context.theme.textTheme.titleMedium?.copyWith(
            color: context.theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          obscureText: obscureText && widget.isPassoword,
          keyboardType: widget.countingStrategy != null
              ? TextInputType.numberWithOptions(
                  decimal: widget.countingStrategy == CountingStrategy.weight,
                )
              : null,
          enabled: widget.enabled,
          style: context.theme.textTheme.bodyLarge?.copyWith(
            color: context.theme.colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            suffixText: widget.countingStrategy?.name,
            suffixStyle: context.theme.textTheme.bodyLarge?.copyWith(
              color: context.theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            suffixIcon: widget.isPassoword
                ? IconButton(
                    onPressed: () => setState(() {
                      obscureText = !obscureText;
                    }),
                    icon: Icon(
                      !obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                  )
                : null,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
