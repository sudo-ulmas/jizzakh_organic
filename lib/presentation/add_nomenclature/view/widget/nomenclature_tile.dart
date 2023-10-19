import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NomenclatureTile extends StatelessWidget {
  const NomenclatureTile({super.key});

  @override
  Widget build(BuildContext context) => ListTile(
        onTap: () => context.pop(),
        title: const Text('Туша говядина'),
        trailing: const Text('кг'),
      );
}
