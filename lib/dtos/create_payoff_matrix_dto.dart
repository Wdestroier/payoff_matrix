import '../models/alternative.dart';
import '../models/decision_scenario.dart';
import '../models/nature_state.dart';

class CreatePayoffMatrixDto {
  String name;
  DecisionScenario decisionScenario;
  List<NatureState> natureStates;
  List<Alternative> alternatives;
  List<List<int>>? values;

  CreatePayoffMatrixDto({
    required this.name,
    required this.decisionScenario,
    required this.natureStates,
    required this.alternatives,
    this.values,
  });
}
