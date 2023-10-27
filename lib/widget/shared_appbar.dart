import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uboyniy_cex/util/util.dart';

class SharedAppbar extends StatelessWidget implements PreferredSizeWidget {
  const SharedAppbar({required this.title, this.actions = const [], super.key});
  final String title;
  final List<Widget> actions;

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
        ],
      );

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
