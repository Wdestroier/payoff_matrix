import 'dart:convert';

import 'alternative.dart';
import 'decision_scenario.dart';
import 'nature_state.dart';

class PayoffMatrix {
  String id;
  DateTime createdAt;
  DateTime updatedAt;
  String name;
  DecisionScenario decisionScenario;
  List<NatureState> natureStates;
  List<Alternative> alternatives;
  List<List<int>> values;

  PayoffMatrix({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.decisionScenario,
    required this.natureStates,
    required this.alternatives,
    List<List<int>>? values,
  }) : values = values ?? [];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'name': name,
      'decisionScenario': decisionScenario.name,
      'natureStates': natureStates.map((x) => x.toMap()).toList(),
      'alternatives': alternatives.map((x) => x.toMap()).toList(),
      'values': values,
    };
  }

  factory PayoffMatrix.fromMap(Map<String, dynamic> map) {
    return PayoffMatrix(
      id: map['id'] as String,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      name: map['name'] as String,
      decisionScenario: DecisionScenario.values.byName(map['decisionScenario']),
      natureStates: List<NatureState>.from(
        (map['natureStates'] as List<dynamic>).map<NatureState>(
          (x) => NatureState.fromMap(x as Map<String, dynamic>),
        ),
      ),
      alternatives: List<Alternative>.from(
        (map['alternatives'] as List<dynamic>).map<Alternative>(
          (x) => Alternative.fromMap(x as Map<String, dynamic>),
        ),
      ),
      values: List<List<int>>.from(
        (map['values'] as List<dynamic>)
            .map((x) => <int>[...(x as List<dynamic>)]),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory PayoffMatrix.fromJson(String source) =>
      PayoffMatrix.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant PayoffMatrix other) => other.id == id;

  @override
  int get hashCode => id.hashCode;
}
