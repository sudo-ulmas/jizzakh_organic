import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uboyniy_cex/util/util.dart';

class SharedScaffold extends StatefulWidget {
  const SharedScaffold({
    required this.body,
    super.key,
  });

  final Widget body;

  @override
  State<SharedScaffold> createState() => _SharedScaffoldState();
}

class _SharedScaffoldState extends State<SharedScaffold> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Убойный цех'),
          actions: [
            IconButton(
              icon: const Icon(Icons.sunny),
              onPressed: () => context.read<ThemeCubit>().switchThemes(),
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (value) => setState(() {
            _selectedIndex = value;
            context.go(value == 0 ? PagePath.animals : PagePath.orders);
          }),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.room_outlined),
              selectedIcon: Icon(Icons.room),
              label: 'Животные в загоне',
            ),
            NavigationDestination(
              icon: Icon(Icons.outlined_flag_outlined),
              selectedIcon: Icon(Icons.outlined_flag),
              label: 'Распоряжения',
            ),
          ],
        ),
        body: widget.body,
      );
}
