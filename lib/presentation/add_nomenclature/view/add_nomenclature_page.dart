import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/presentation/add_nomenclature/view/cubit/add_nomenclature_cubit.dart';
import 'package:uboyniy_cex/presentation/presentation.dart';
import 'package:uboyniy_cex/widget/widget.dart';

class AddNomenclaturePage extends StatefulWidget {
  const AddNomenclaturePage({required this.animal, super.key});
  final AnimalModel animal;

  @override
  State<AddNomenclaturePage> createState() => _AddNomenclaturePageState();
}

class _AddNomenclaturePageState extends State<AddNomenclaturePage> {
  final _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: BlocProvider(
          create: (context) => AddNomenclatureCubit(),
          child: Scaffold(
            appBar: const SharedAppbar(title: 'Добавление номенклатуры'),
            body: LayoutBuilder(
              builder: (context, constraints) =>
                  BlocBuilder<AddNomenclatureCubit, List<AnimalPartModel>>(
                builder: (context, state) => ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AnimatedList(
                          key: _listKey,
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(24),
                          initialItemCount: 1,
                          itemBuilder: (context, index, animation) =>
                              NomenclatureCard(
                            animation: animation,
                            removable: state.length > 1,
                            removeNomenclature: () {
                              _listKey.currentState?.removeItem(
                                index,
                                (_, animation) => NomenclatureCard(
                                  animation: animation,
                                  removeNomenclature: () {},
                                ),
                              );
                              context
                                  .read<AddNomenclatureCubit>()
                                  .removeAnimalPart(index);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(48, 20, 48, 28),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FilledButton.icon(
                              onPressed: () {
                                _listKey.currentState?.insertItem(state.length);
                                context
                                    .read<AddNomenclatureCubit>()
                                    .addAnimalPart();
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Добавить'),
                            ),
                            FilledButton(
                              onPressed: () {},
                              child: const Text('Далее'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
