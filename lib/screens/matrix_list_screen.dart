import 'package:flutter/material.dart';

import '../repositories/matrix_repository.dart';
import 'empty_matrix_list_page.dart';
import 'populated_matrix_list_screen.dart';

class MatrixListScreen extends StatelessWidget {
  const MatrixListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MatrixRepository().readAll(),
      builder: (context, snapshot) {
        return switch ((snapshot.hasData, snapshot.data)) {
          (false, _) => const Center(child: CircularProgressIndicator()),
          (true, final payoffMatrices)
              when payoffMatrices == null || payoffMatrices.isEmpty =>
            const EmptyMatrixListScreen(),
          (true, final payoffMatrices) =>
            PopulatedMatrixListScreen(payoffMatrices: payoffMatrices!),
        };
      },
    );
  }
}
