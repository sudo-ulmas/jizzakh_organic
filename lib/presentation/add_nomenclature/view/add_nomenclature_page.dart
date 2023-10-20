import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/presentation/add_nomenclature/view/cubit/add_nomenclature_cubit.dart';
import 'package:uboyniy_cex/presentation/presentation.dart';
import 'package:uboyniy_cex/util/util.dart';
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
                            animalPart: state[index],
                            removeNomenclature: () {
                              _listKey.currentState?.removeItem(
                                index,
                                (_, animation) => NomenclatureCard(
                                  animation: animation,
                                  animalPart:
                                      index == 0 ? state[0] : state[index - 1],
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
                      Container(
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
                              onPressed: () {
                                final isValid = context
                                    .read<AddNomenclatureCubit>()
                                    .validate();
                                if (isValid) {
                                  context.push(
                                    '${PagePath.animals}/${PagePath.checkNomenclature}',
                                    extra: (state, widget.animal),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Column(
                                        children: [
                                          Text(
                                            '''Ввуденные данные неправильны! Пожалйста заполните все поля и убедитесь что введенные количества дейсвителены.''',
                                            style: context
                                                .theme.textTheme.bodyLarge
                                                ?.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
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
