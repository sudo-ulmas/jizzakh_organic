import 'package:flutter/material.dart';
import 'package:uboyniy_cex/presentation/presentation.dart';
import 'package:uboyniy_cex/widget/shared_appbar.dart';

class AddNomenclaturePage extends StatelessWidget {
  const AddNomenclaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SharedAppbar(title: 'Добавление номенклатуры'),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: 1,
        itemBuilder: (context, index) => const NomenclatureCard(),
      ),
    );
  }
}
