import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uboyniy_cex/model/model.dart';

class NomenclatureTile extends StatelessWidget {
  const NomenclatureTile({required this.nomenclature, super.key});
  final NomenclatureModel nomenclature;

  @override
  Widget build(BuildContext context) => ListTile(
        onTap: () => context.pop(nomenclature),
        title: Text(nomenclature.title),
        trailing: Text(nomenclature.countingStrategy.name),
      );
}
