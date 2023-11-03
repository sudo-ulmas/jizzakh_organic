import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/presentation/create_document/bloc/create_document_bloc.dart';
import 'package:uboyniy_cex/presentation/presentation.dart';
import 'package:uboyniy_cex/util/util.dart';
import 'package:uboyniy_cex/widget/widget.dart';

class CreateDocumentPage extends StatelessWidget {
  const CreateDocumentPage({
    required this.animalParts,
    required this.animal,
    super.key,
  });
  final List<AnimalPartModel> animalParts;
  final AnimalModel animal;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateDocumentBloc(animalRepository: context.read()),
      child: Scaffold(
        appBar: const SharedAppbar(title: 'Проверка введенных данных'),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    AnimalInfoText(
                      title: 'Наименование:',
                      value: animal.title,
                    ),
                    const SizedBox(height: 6),
                    AnimalInfoText(
                      title: 'Бирка:',
                      value: animal.tag,
                    ),
                    const SizedBox(height: 6),
                    AnimalInfoText(
                      title: 'Вес:',
                      value: animal.weight!,
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Divider(),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(left: 12, bottom: 6),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Номенклатуры',
                  style: context.theme.textTheme.headlineMedium?.copyWith(
                    color: context.theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            SliverList.builder(
              itemCount: animalParts.length,
              itemBuilder: (context, index) => AnimalPartInfoText(
                title: animalParts[index].nomenclature.title,
                value:
                    '''${animalParts[index].count} ${animalParts[index].nomenclature.countingStrategy.name}''',
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverToBoxAdapter(
                child: BlocConsumer<CreateDocumentBloc, CreateDocumentState>(
                  listener: (context, state) {
                    if (state is CreateDocumentSuccess) {
                      context.go(PagePath.animals);
                    } else if (state is CreateDocumentError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.exception.message(),
                          ),
                        ),
                      );
                    }
                  },
                  builder: (context, state) => FilledButton(
                    onPressed: () {
                      if (state is! CreateDocumentInProgress) {
                        context.read<CreateDocumentBloc>().add(
                              CreateDocumentEvent.create(
                                animal: animal,
                                animalParts: animalParts,
                              ),
                            );
                      }
                    },
                    child: state is CreateDocumentInProgress
                        ? const CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          )
                        : const Text('Создать документ'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
