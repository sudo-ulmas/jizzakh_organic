import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uboyniy_cex/util/util.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(
          'Выйти',
          style: TextStyle(
            color: context.theme.colorScheme.onSurface,
          ),
        ),
        content: Text(
          'Вы уверены что хотите выйти из приложения?',
          style: TextStyle(
            color: context.theme.colorScheme.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            style: ButtonStyle(
              textStyle: MaterialStatePropertyAll<TextStyle>(
                context.theme.textTheme.bodyMedium!.copyWith(color: Colors.red),
              ),
            ),
            onPressed: () => context.go(PagePath.loginRoute),
            child: Text(
              'Выйти',
              style: context.theme.textTheme.bodyMedium!
                  .copyWith(color: Colors.red),
            ),
          ),
        ],
      );
}
