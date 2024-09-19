import 'dart:convert';

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
