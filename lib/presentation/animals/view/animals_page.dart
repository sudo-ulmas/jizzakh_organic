import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/presentation/animals/bloc/animals_bloc.dart';
import 'package:uboyniy_cex/repository/repository.dart';
import 'package:uboyniy_cex/util/route/router.dart';

class AnimalsPage extends StatelessWidget {
  const AnimalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AnimalsBloc(animalRepository: context.read<AnimalRepository>())
            ..add(const AnimalsEvent.loadAnimals()),
      child: BlocBuilder<AnimalsBloc, AnimalsState>(
        builder: (context, state) {
          return switch (state) {
            AnimalsSuccess(:final animals) => ListView.separated(
                itemCount: 100,
                itemBuilder: (context, index) =>
                    AnimalTile(animal: animals[index]),
                separatorBuilder: (context, index) => const Divider(
                  indent: 32,
                  endIndent: 32,
                ),
              ),
            _ => const Center(
                child: CircularProgressIndicator(),
              ),
          };
        },
      ),
    );
  }
}

class AnimalTile extends StatelessWidget {
  const AnimalTile({required this.animal, super.key});
  final AnimalModel animal;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.go('${PagePath.animals}/${PagePath.animalDetails}'),
      leading: Text('\u2116 ${animal.id}'),
      subtitle: Text(animal.tag),
      title: Text(animal.title),
    );
  }
}
