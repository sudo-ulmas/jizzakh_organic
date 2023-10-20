import 'package:flutter/material.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/presentation/presentation.dart';
import 'package:uboyniy_cex/util/util.dart';
import 'package:uboyniy_cex/widget/widget.dart';

class CheckNomenclaturePage extends StatelessWidget {
  const CheckNomenclaturePage({
    required this.animalParts,
    required this.animal,
    super.key,
  });
  final List<AnimalPartModel> animalParts;
  final AnimalModel animal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SharedAppbar(title: 'Проверка введенных данных'),
      body: LayoutBuilder(
        builder: (context, constraints) => CustomScrollView(
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
                child: FilledButton(
                  onPressed: () {},
                  child: const Text('Создать документ'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
