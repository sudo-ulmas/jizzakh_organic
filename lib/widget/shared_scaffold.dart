import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uboyniy_cex/util/util.dart';

class SharedScaffold extends StatelessWidget {
  const SharedScaffold({
    required this.body,
    super.key,
  });

  final Widget body;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          bottomNavigationBar: NavigationBar(
            selectedIndex:
                GoRouterState.of(context).fullPath?.split('/')[1] == 'animals'
                    ? 0
                    : 1,
            onDestinationSelected: (value) =>
                context.go(value == 0 ? PagePath.animals : PagePath.orders),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.cruelty_free_outlined),
                selectedIcon: Icon(Icons.cruelty_free),
                label: 'Животные в загоне',
              ),
              NavigationDestination(
                icon: Icon(Icons.description_outlined),
                selectedIcon: Icon(Icons.description),
                label: 'Распоряжения',
              ),
            ],
          ),
          body: body,
        ),
      );
}
