import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uboyniy_cex/util/util.dart';

class TrashButton extends StatelessWidget {
  const TrashButton({required this.removeNomenclature, super.key});
  final VoidCallback removeNomenclature;
  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: () => showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Удалить',
              style: TextStyle(
                color: context.theme.colorScheme.onSurface,
              ),
            ),
            content: Text(
              'Вы уверены что хотите удалить номенклатуру?',
              style: TextStyle(
                color: context.theme.colorScheme.onSurface,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(false),
                child: const Text('Отмена'),
              ),
              TextButton(
                style: ButtonStyle(
                  textStyle: MaterialStatePropertyAll<TextStyle>(
                    context.theme.textTheme.bodyMedium!
                        .copyWith(color: Colors.red),
                  ),
                ),
                onPressed: () => context.pop(true),
                child: Text(
                  'Удалить',
                  style: context.theme.textTheme.bodyMedium!
                      .copyWith(color: Colors.red),
                ),
              ),
            ],
          ),
        ).then((value) => value != null && value ? removeNomenclature() : null),
        icon: const Icon(
          Icons.delete_sweep_outlined,
          color: Colors.red,
        ),
      );
}
