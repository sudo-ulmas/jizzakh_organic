import 'package:flutter/material.dart';
import 'package:uboyniy_cex/presentation/presentation.dart';

class NomenclatureList extends StatelessWidget {
  const NomenclatureList({super.key});

  @override
  Widget build(BuildContext context) => FractionallySizedBox(
        heightFactor: 0.9,
        child: ListView.builder(
          itemCount: 400,
          itemBuilder: (context, index) => const NomenclatureTile(),
        ),
      );
}
