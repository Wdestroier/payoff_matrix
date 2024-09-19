import 'package:payoff_matrix/dtos/create_payoff_matrix_dto.dart';
import 'package:payoff_matrix/repositories/matrix_repository.dart';
import 'package:payoff_matrix/states/translations_state.dart';

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
      name: translations.matrixService.newMatrix,
      decisionScenario: DecisionScenario.underUncertainty,
      natureStates: [
        NatureState(name: '${translations.matrixService.natureState} 1'),
        NatureState(name: '${translations.matrixService.natureState} 2')
      ],
      alternatives: [
        Alternative(name: '${translations.matrixService.alternative} 1'),
        Alternative(name: '${translations.matrixService.alternative} 2')
      ],
      values: [
        [2, 3],
        [5, 7],
      ],
    ));
  }

  Future<PayoffMatrix> createUnderRisk() async {
    return _matrixRepository.create(CreatePayoffMatrixDto(
      name: translations.matrixService.newMatrix,
      decisionScenario: DecisionScenario.underRisk,
      natureStates: [
        NatureState(
          name: '${translations.matrixService.natureState} 1',
          probability: 0.3,
        ),
        NatureState(
          name: '${translations.matrixService.natureState} 2',
          probability: 0.7,
        )
      ],
      alternatives: [
        Alternative(name: '${translations.matrixService.alternative} 1'),
        Alternative(name: '${translations.matrixService.alternative} 2')
      ],
      values: [
        [2, 3],
        [5, 7],
      ],
    ));
  }
}
