import 'package:hive_flutter/hive_flutter.dart';
import 'package:ulid/ulid.dart';

import 'model.dart';

class MatrixService {
  static const _boxName = 'payoff-matrices';

  factory MatrixService() => const MatrixService._();

  const MatrixService._();

  Future<PayoffMatrix> createUnderUncertainty() async {
    final payoffMatrix = PayoffMatrix(
      id: Ulid().toString(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      name: 'Nova matriz',
      decisionScenario: DecisionScenario.underUncertainty,
      natureStates: [
        NatureState(name: 'Estado da Natureza 1'),
        NatureState(name: 'Estado da Natureza 2')
      ],
      alternatives: [
        Alternative(name: 'Alternativa 1'),
        Alternative(name: 'Alternativa 2')
      ],
      values: [
        [2, 3],
        [5, 7],
      ],
    );
    final box = await Hive.openBox(_boxName);
    await box.put(payoffMatrix.id, payoffMatrix.toJson());
    await box.close();
    return payoffMatrix;
  }

  Future<PayoffMatrix> createUnderRisk() async {
    final payoffMatrix = PayoffMatrix(
      id: Ulid().toString(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      name: 'Nova matriz',
      decisionScenario: DecisionScenario.underRisk,
      natureStates: [
        NatureState(
          name: 'Estado da Natureza 1',
          probability: 0.3,
        ),
        NatureState(
          name: 'Estado da Natureza 2',
          probability: 0.7,
        )
      ],
      alternatives: [
        Alternative(name: 'Alternativa 1'),
        Alternative(name: 'Alternativa 2')
      ],
      values: [
        [2, 3],
        [5, 7],
      ],
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

  Future<bool> update(PayoffMatrix payoffMatrix) async {
    final box = await Hive.openBox(_boxName);
    var serializedOldPayoffMatrix = box.get(payoffMatrix.id);
    if (serializedOldPayoffMatrix != null) {
      final PayoffMatrix oldPayoffMatrix =
          PayoffMatrix.fromJson(serializedOldPayoffMatrix);
      oldPayoffMatrix
        ..name = payoffMatrix.name
        ..updatedAt = DateTime.now()
        ..natureStates = payoffMatrix.natureStates
        ..alternatives = payoffMatrix.alternatives
        ..values = payoffMatrix.values;
      await box.put(oldPayoffMatrix.id, oldPayoffMatrix.toJson());
      return true;
    }
    await box.close();
    return false;
  }

  Future<bool> delete(String id) async {
    final box = await Hive.openBox(_boxName);
    final canDelete = box.containsKey(id);
    if (canDelete) await box.delete(id);
    await box.close();
    return canDelete;
  }
}
