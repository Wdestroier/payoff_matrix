import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/matrix_service.dart';
import '../states/editing_matrix_state.dart';

class CreateMatrixScreen extends ConsumerWidget {
  const CreateMatrixScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Nova matriz',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            Flex(
              direction:
                  constraints.maxWidth > 450 ? Axis.horizontal : Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.tonal(
                  onPressed: () async {
                    updatePayoffMatrix(
                        ref, await MatrixService().createUnderUncertainty());
                  },
                  child: const Text('Decisão sob incerteza'),
                ),
                const SizedBox(
                  width: 16,
                  height: 16,
                ),
                FilledButton.tonal(
                  onPressed: () async {
                    updatePayoffMatrix(
                        ref, await MatrixService().createUnderRisk());
                  },
                  child: const Text('Decisão sob risco'),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
