import 'package:flutter/material.dart';
import 'package:vitalinguu/exercise/tab/exercise_setup/domain/exercise_configuration.dart';
import 'package:vitalinguu/exercise/tab/exercise_setup/presentation/priority_selection_tile.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

class CefrDropdown extends StatefulWidget {
  const CefrDropdown({super.key, required this.onChanged});

  final ValueChanged<CEFR> onChanged;

  @override
  State<CefrDropdown> createState() => _CefrDropdownState();
}

class _CefrDropdownState extends State<CefrDropdown> {
  CEFR _selected = CEFR.defaultValue;

  void _select(CEFR cefr) {
    if (cefr == _selected) return;
    setState(() => _selected = cefr);
    widget.onChanged(cefr);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: colors.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.t.exerciseSetup.cefrLevel),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final columnCount = switch (constraints.maxWidth) {
                >= 840 => 6,
                >= 560 => 3,
                _ => 2,
              };

              return GridView.builder(
                primary: false,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: CEFR.values.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columnCount,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  mainAxisExtent: PrioritySelectionTile.height,
                ),
                itemBuilder: (context, index) {
                  final cefr = CEFR.values[index];
                  return _CefrSelectionTile(
                    label: cefr.name.toUpperCase(),
                    selected: cefr == _selected,
                    onTap: () => _select(cefr),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CefrSelectionTile extends StatelessWidget {
  const _CefrSelectionTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      selected: selected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: selected ? colors.primaryContainer : null,
          border: Border.all(
            color: selected ? colors.primary : colors.outline,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Center(
              child: Text(
                label,
                style: selected
                    ? TextStyle(
                        color: colors.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
