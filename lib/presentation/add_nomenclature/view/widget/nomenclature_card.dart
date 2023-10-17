import 'package:flutter/material.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/util/util.dart';
import 'package:uboyniy_cex/widget/widget.dart';

class NomenclatureCard extends StatelessWidget {
  const NomenclatureCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Номенклатура',
                style: context.theme.textTheme.titleMedium?.copyWith(
                  color: context.theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.surface,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                  border: Border.all(
                    color: context.theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 8),
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'sdfasdf',
                      style: context.theme.textTheme.bodyLarge?.copyWith(
                        color: context.theme.colorScheme.onSurface,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: context.theme.colorScheme.onSurface,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const InputField(
                title: 'Количество',
                countingStrategy: CountingStrategy.weight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
