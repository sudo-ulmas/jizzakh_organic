import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/presentation/add_nomenclature/view/bloc/nomenclatures_bloc.dart';
import 'package:uboyniy_cex/presentation/add_nomenclature/view/cubit/add_nomenclature_cubit.dart';
import 'package:uboyniy_cex/presentation/presentation.dart';
import 'package:uboyniy_cex/util/util.dart';
import 'package:uboyniy_cex/widget/widget.dart';

class NomenclatureCard extends StatefulWidget {
  const NomenclatureCard({
    required this.removeNomenclature,
    required this.animation,
    required this.animalPart,
    this.removable = true,
    super.key,
  });
  final VoidCallback removeNomenclature;
  final Animation<double> animation;
  final bool removable;
  final AnimalPartModel animalPart;

  @override
  State<NomenclatureCard> createState() => _NomenclatureCardState();
}

class _NomenclatureCardState extends State<NomenclatureCard> {
  final _controller = TextEditingController();

  @override
  void didUpdateWidget(covariant NomenclatureCard oldWidget) {
    if (widget.animalPart.count == '') {
      _controller.text = '';
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: widget.animation,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Stack(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Номенклатура',
                      style: context.theme.textTheme.titleMedium?.copyWith(
                        color: context.theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        context
                            .read<NomenclaturesBloc>()
                            .add(const NomenclaturesEvent.loadNomenclatures());
                        showModalBottomSheet<NomenclatureModel>(
                          context: context,
                          isScrollControlled: true,
                          showDragHandle: true,
                          useRootNavigator: true,
                          builder: (context) => const NomenclatureList(),
                        ).then((model) {
                          if (model != null) {
                            context
                                .read<AddNomenclatureCubit>()
                                .editNomenclature(
                                    model, widget.animalPart.listIndex);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: context.theme.colorScheme.surface,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          border: Border.all(
                            color: context.theme.colorScheme.onSurface
                                .withOpacity(0.8),
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 8),
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.animalPart.nomenclature.title,
                              style:
                                  context.theme.textTheme.bodyLarge?.copyWith(
                                color: context.theme.colorScheme.onSurface,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: context.theme.colorScheme.onSurface,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InputField(
                      controller: _controller,
                      title:
                          '''Количество (${widget.animalPart.nomenclature.countingStrategy.name})''',
                      countingStrategy:
                          widget.animalPart.nomenclature.countingStrategy,
                      onChanged: (text) => context
                          .read<AddNomenclatureCubit>()
                          .editCount(text, widget.animalPart.listIndex),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.removable)
              Positioned(
                top: 3,
                right: 8,
                child:
                    TrashButton(removeNomenclature: widget.removeNomenclature),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
