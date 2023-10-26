import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/presentation/add_nomenclature/view/bloc/nomenclatures_cubit.dart';
import 'package:uboyniy_cex/presentation/presentation.dart';

class NomenclatureList extends StatelessWidget {
  const NomenclatureList({super.key});

  @override
  Widget build(BuildContext context) => FractionallySizedBox(
        heightFactor: 0.9,
        child: BlocBuilder<NomenclatureCubit, List<NomenclatureModel>>(
          builder: (context, nomenclatures) => ListView.builder(
            itemCount: nomenclatures.length,
            itemBuilder: (context, index) => NomenclatureTile(
              nomenclature: nomenclatures[index],
            ),
          ),
        ),
      );
}
