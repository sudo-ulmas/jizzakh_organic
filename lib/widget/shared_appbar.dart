import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uboyniy_cex/util/util.dart';
import 'package:uboyniy_cex/widget/widget.dart';

class SharedAppbar extends StatelessWidget implements PreferredSizeWidget {
  const SharedAppbar({
    required this.title,
    this.actions = const [],
    this.includeLogoutButton = false,
    super.key,
  });
  final String title;
  final List<Widget> actions;
  final bool includeLogoutButton;

  @override
  Widget build(BuildContext context) => AppBar(
        title: AutoSizeText(
          title,
          maxLines: 1,
        ),
        actions: [
          ...actions,
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) {
              return IconButton.filledTonal(
                tooltip: 'Сменить тему',
                icon: Icon(
                  mode == ThemeMode.dark
                      ? Icons.wb_sunny_outlined
                      : Icons.dark_mode_outlined,
                ),
                onPressed: () => context.read<ThemeCubit>().switchThemes(),
              );
            },
          ),
          if (includeLogoutButton)
            IconButton.filledTonal(
              onPressed: () => showDialog<bool>(
                context: context,
                builder: (context) => const LogoutDialog(),
              ),
              icon: const Icon(
                Icons.logout,
              ),
            ),
        ],
      );

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
