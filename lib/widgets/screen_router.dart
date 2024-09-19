import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/create_matrix_screen.dart';
import '../screens/edit_matrix_screen.dart';
import '../screens/matrix_list_screen.dart';
import '../screens/not_found_screen.dart';
import '../states/editing_matrix_state.dart';

class ScreenRouter extends ConsumerWidget {
  final int screenIndex;

  const ScreenRouter({
    required this.screenIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payoffMatrix = ref.watch(editingPayoffMatrix);
    return switch (screenIndex) {
      0 => const MatrixListScreen(),
      1 => payoffMatrix == null
          ? const CreateMatrixScreen()
          : const EditMatrixScreen(),
      _ => const NotFoundScreen(),
    };
  }
}
