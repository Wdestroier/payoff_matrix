import 'dart:convert';

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