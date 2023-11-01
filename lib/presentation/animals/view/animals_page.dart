import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/presentation/animals/bloc/animals_bloc.dart';
import 'package:uboyniy_cex/repository/repository.dart';
import 'package:uboyniy_cex/util/util.dart';
import 'package:uboyniy_cex/widget/widget.dart';

class AnimalsPage extends StatelessWidget {
  const AnimalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SharedAppbar(
        title: 'Животные в загоне',
        includeLogoutButton: true,
      ),
      body: BlocProvider(
        create: (context) =>
            AnimalsBloc(animalRepository: context.read<AnimalRepository>())
              ..add(const AnimalsEvent.loadAnimals()),
        child: BlocBuilder<AnimalsBloc, AnimalsState>(
          builder: (context, state) {
            return switch (state) {
              AnimalsSuccess(:final animals) => ListView.separated(
                  itemCount: animals.length,
                  itemBuilder: (context, index) => AnimalTile(
                    animal: animals[index],
                    index: index,
                  ),
                  separatorBuilder: (context, index) => const Divider(
                    indent: 32,
                    endIndent: 32,
                  ),
                ),
              AnimalsError(:final exception) => Center(
                  child: Text(
                    exception.message(),
                    style: context.theme.textTheme.bodyMedium
                        ?.copyWith(color: context.theme.colorScheme.onSurface),
                  ),
                ),
              _ => const Center(
                  child: CircularProgressIndicator(),
                ),
            };
          },
        ),
      ),
    );
  }
}

class AnimalTile extends StatelessWidget {
  const AnimalTile({required this.animal, required this.index, super.key});
  final AnimalModel animal;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.go(
        '${PagePath.animals}/${PagePath.animalDetails}',
        extra: animal,
      ),
      leading: Text('\u2116 ${index + 1}'),
      subtitle: Text('Бирка: ${animal.tag}'),
      title: Text(animal.title),
    );
  }
}
