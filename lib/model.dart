import 'dart:convert';

enum DecisionScenario {
  underUncertainty,
  underRisk;
}

class NatureState {
  String name;
  double probability;

  NatureState({
    required this.name,
    this.probability = 1.0,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'probability': probability,
    };
  }

  factory NatureState.fromMap(Map<String, dynamic> map) {
    return NatureState(
      name: map['name'] as String,
      probability: map['probability'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory NatureState.fromJson(String source) =>
      NatureState.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Alternative {
  String name;

  Alternative({required this.name});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
    };
  }

  factory Alternative.fromMap(Map<String, dynamic> map) {
    return Alternative(
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Alternative.fromJson(String source) =>
      Alternative.fromMap(json.decode(source) as Map<String, dynamic>);
}

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
