import 'package:payoff_matrix/dtos/create_payoff_matrix_dto.dart';
import 'package:payoff_matrix/repositories/matrix_repository.dart';

import '../models/alternative.dart';
import '../models/decision_scenario.dart';
import '../models/nature_state.dart';
import '../models/payoff_matrix.dart';

class MatrixService {
  static final MatrixService _instance = MatrixService._();

  final _matrixRepository = MatrixRepository();

  factory MatrixService() => _instance;

  MatrixService._();

  Future<PayoffMatrix> createUnderUncertainty() async {
    return _matrixRepository.create(CreatePayoffMatrixDto(
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
    ));
  }

  Future<PayoffMatrix> createUnderRisk() async {
    return _matrixRepository.create(CreatePayoffMatrixDto(
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
    ));
  }
}
