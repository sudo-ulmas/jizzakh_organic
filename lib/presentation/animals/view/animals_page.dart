import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uboyniy_cex/bloc/queue_bloc.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/presentation/animals/bloc/animals_bloc.dart';
import 'package:uboyniy_cex/repository/repository.dart';
import 'package:uboyniy_cex/util/util.dart';
import 'package:uboyniy_cex/widget/widget.dart';

class AnimalsPage extends StatefulWidget {
  const AnimalsPage({super.key});

  @override
  State<AnimalsPage> createState() => _AnimalsPageState();
}

class _AnimalsPageState extends State<AnimalsPage> {
  final _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SharedAppbar(
        title: 'Животные в загоне',
        includeLogoutButton: true,
      ),
      body: BlocProvider(
        create: (context) => AnimalsBloc(
          animalRepository: context.read<AnimalRepository>(),
        )..add(const AnimalsEvent.loadAnimals()),
        child: BlocConsumer<AnimalsBloc, AnimalsState>(
          listener: (context, state) {
            if (state is AnimalsSuccess) {
              if (state.removeIndex != null) {
                _listKey.currentState?.removeItem(
                  state.removeIndex!,
                  (context, animation) => AnimalTile(
                    animation: animation,
                    animal: state.removedAnimal!,
                    index: state.removeIndex!,
                    uploading: true,
                  ),
                );
              }
            }
          },
          builder: (context, state) {
            return switch (state) {
              AnimalsSuccess(:final animals) =>
                BlocBuilder<QueueBloc, QueueState>(
                  builder: (context, state) => AnimatedList(
                    key: _listKey,
                    initialItemCount: animals.length,
                    itemBuilder: (context, index, animation) => AnimalTile(
                      animation: animation,
                      animal: animals[index],
                      index: index,
                      uploading: state.documents
                          .where(
                            (element) =>
                                element.idNomenclature == animals[index].id,
                          )
                          .isNotEmpty,
                    ),
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
  const AnimalTile({
    required this.animal,
    required this.index,
    required this.uploading,
    required this.animation,
    super.key,
  });
  final AnimalModel animal;
  final int index;
  final bool uploading;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: ListTile(
        onTap: uploading
            ? null
            : () => context.go(
                  '${PagePath.animals}/${PagePath.animalDetails}',
                  extra: animal,
                ),
        leading: Text(
          '\u2116 ${index + 1}',
          style: context.theme.textTheme.bodySmall?.copyWith(
            color:
                uploading ? Colors.grey : context.theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Бирка: ${animal.tag}',
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: uploading
                    ? Colors.grey
                    : context.theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            if (uploading)
              const Row(
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    color: Colors.orange,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Готовится к отправке',
                    style: TextStyle(
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
          ],
        ),
        title: Text(
          animal.title,
          style: context.theme.textTheme.bodyLarge?.copyWith(
            color:
                uploading ? Colors.grey : context.theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
