import 'package:hive_flutter/hive_flutter.dart';
import 'package:ulid/ulid.dart';

import '../dtos/create_payoff_matrix_dto.dart';
import '../models/payoff_matrix.dart';

class MatrixRepository {
  static const _boxName = 'payoff-matrices';

  factory MatrixRepository() => const MatrixRepository._();

  const MatrixRepository._();

  Future<PayoffMatrix> create(CreatePayoffMatrixDto dto) async {
    final payoffMatrix = PayoffMatrix(
      id: Ulid().toString(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      name: dto.name,
      decisionScenario: dto.decisionScenario,
      natureStates: dto.natureStates,
      alternatives: dto.alternatives,
      values: dto.values,
    );
    final box = await Hive.openBox(_boxName);
    await box.put(payoffMatrix.id, payoffMatrix.toJson());
    await box.close();
    return payoffMatrix;
  }

  Future<List<PayoffMatrix>> readAll() async {
    final box = await Hive.openBox(_boxName);
    final result =
        box.values.cast<String>().map(PayoffMatrix.fromJson).toList();
    await box.close();
    return result;
  }

  Future<PayoffMatrix?> update(PayoffMatrix payoffMatrix) async {
    final box = await Hive.openBox(_boxName);
    var json = box.get(payoffMatrix.id);
    if (json != null) {
      final existingMatrix = PayoffMatrix.fromJson(json);
      existingMatrix
        ..name = payoffMatrix.name
        ..updatedAt = DateTime.now()
        ..natureStates = payoffMatrix.natureStates
        ..alternatives = payoffMatrix.alternatives
        ..values = payoffMatrix.values;
      await box.put(existingMatrix.id, existingMatrix.toJson());
      return existingMatrix;
    }
    await box.close();
    return null;
  }

  Future<bool> delete(String id) async {
    final box = await Hive.openBox(_boxName);
    final canDelete = box.containsKey(id);
    if (canDelete) await box.delete(id);
    await box.close();
    return canDelete;
  }
}
