import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/payoff_matrix.dart';

final editingPayoffMatrix = StateProvider<PayoffMatrix?>((ref) => null);

updatePayoffMatrix(WidgetRef ref, PayoffMatrix? payoffMatrix) {
  ref.read(editingPayoffMatrix.notifier).state = null;
  ref.read(editingPayoffMatrix.notifier).state = payoffMatrix;
}
