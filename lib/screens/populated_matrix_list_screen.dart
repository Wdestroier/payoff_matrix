import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payoff_matrix/states/translations_state.dart';
import 'package:ulid/ulid.dart';

import '../models/payoff_matrix.dart';
import '../repositories/matrix_repository.dart';
import '../states/active_screen_state.dart';
import '../states/editing_matrix_state.dart';

class PopulatedMatrixListScreen extends ConsumerStatefulWidget {
  final List<PayoffMatrix> payoffMatrices;

  const PopulatedMatrixListScreen({
    required this.payoffMatrices,
    super.key,
  });

  @override
  ConsumerState<PopulatedMatrixListScreen> createState() =>
      _PopulatedMatrixListScreenState();
}

class _PopulatedMatrixListScreenState
    extends ConsumerState<PopulatedMatrixListScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: widget.payoffMatrices.map((payoffMatrix) {
          openEditView() {
            updatePayoffMatrix(ref, payoffMatrix);
            ref.read(activeScreenIndex.notifier).state = 1;
          }

          final updatedAt = formatDateTime(payoffMatrix.updatedAt);
          return ListTile(
            onTap: openEditView,
            leading: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: ulidToColor(payoffMatrix.id),
              ),
              height: 40,
              width: 40,
            ),
            title: Text(payoffMatrix.name),
            subtitle: Text(translations.populatedMatrixListScreen
                .updatedOnAt(updatedAt.date, updatedAt.time)),
            trailing: SizedBox(
              width: 96,
              height: 64,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_rounded),
                    tooltip: translations.populatedMatrixListScreen.edit,
                    onPressed: openEditView,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete_rounded),
                    tooltip: translations.populatedMatrixListScreen.delete,
                    onPressed: () async {
                      final deleted =
                          await MatrixRepository().delete(payoffMatrix.id);
                      if (deleted) {
                        setState(() {
                          widget.payoffMatrices.remove(payoffMatrix);
                        });
                      }
                    },
                  )
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  ({String date, String time}) formatDateTime(DateTime dateTime) {
    return (
      date:
          '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}',
      time:
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}'
    );
  }

  Color ulidToColor(String ulid) {
    if (ulid.length != 26) {
      throw ArgumentError('ULID must be 26 characters long.');
    }
    final [r, g, b] = Ulid.parse(ulid).toBytes().reversed.take(3).toList();
    return Color.fromRGBO(r, g, b, 1.0);
  }
}
