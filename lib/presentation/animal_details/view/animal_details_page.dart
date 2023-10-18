import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/util/util.dart';
import 'package:uboyniy_cex/widget/widget.dart';

class AnimalDetailsPage extends StatefulWidget {
  const AnimalDetailsPage({required this.animal, super.key});
  final AnimalModel animal;

  @override
  State<AnimalDetailsPage> createState() => _AnimalDetailsPageState();
}

class _AnimalDetailsPageState extends State<AnimalDetailsPage> {
  late TextEditingController _titleController;
  late TextEditingController _tagController;
  late TextEditingController _weightController;
  bool weightIsValid = true;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.animal.title);
    _tagController = TextEditingController(text: widget.animal.tag);
    _weightController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const SharedAppbar(title: 'Ввод данных животного'),
        body: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(minHeight: constraints.maxHeight - 48),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputField(
                      title: 'Наименование',
                      controller: _titleController,
                      enabled: false,
                    ),
                    const SizedBox(height: 24),
                    InputField(
                      title: 'Бирка',
                      controller: _tagController,
                      enabled: false,
                    ),
                    const SizedBox(height: 24),
                    InputField(
                      title: 'Вес животного (кг)',
                      controller: _weightController,
                      countingStrategy: CountingStrategy.weight,
                    ),
                    if (!weightIsValid)
                      Padding(
                        padding: const EdgeInsets.only(left: 8, top: 3),
                        child: Text(
                          'Введенный вес не действителен',
                          style: context.theme.textTheme.labelMedium
                              ?.copyWith(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 24),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {
                            weightIsValid =
                                _weightController.text.validateWeightKg;
                          });
                          if (weightIsValid) {
                            context.push(
                              '${PagePath.animals}/${PagePath.addNomenclature}',
                              extra: widget.animal.copyWith(
                                weight: _weightController.text,
                              ),
                            );
                          }
                        },
                        child: const Text('Далее'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _titleController.dispose();
    _tagController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}
