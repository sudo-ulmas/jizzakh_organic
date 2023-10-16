import 'package:flutter/material.dart';

class SlaughterhousePage extends StatelessWidget {
  const SlaughterhousePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 100,
      itemBuilder: (context, index) => AnimalTile(index: index),
    );
  }
}

class AnimalTile extends StatelessWidget {
  const AnimalTile({required this.index, super.key});
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text('\u2116 ${index + 1}'),
      subtitle: const Text('Бирка: 1B2.0302'),
      title: const Text('Наименование: 08 Коровы'),
    );
  }
}
