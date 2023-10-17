import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uboyniy_cex/util/util.dart';

class SharedAppbar extends StatelessWidget implements PreferredSizeWidget {
  const SharedAppbar({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) => AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.sunny),
            onPressed: () => context.read<ThemeCubit>().switchThemes(),
          ),
        ],
      );

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}
