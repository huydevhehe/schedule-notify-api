enum UserRole { admin, employee }

class UnitInfo {
  const UnitInfo({required this.id, required this.name, required this.code});

  final int id;
  final String name;
  final String code;

  factory UnitInfo.fromJson(Map<String, dynamic> json) => UnitInfo(
        id: json['id'] as int,
        name: json['name'] as String,
        code: json['code'] as String,
      );
}

class User {
  const User({
    required this.id,
    required this.username,
    required this.role,
    required this.units,
  });

  final int id;
  final String username;
  final UserRole role;
  final List<UnitInfo> units;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int,
        username: json['username'] as String,
        role: (json['role'] as String) == 'admin' ? UserRole.admin : UserRole.employee,
        units: (json['units'] as List)
            .map((u) => UnitInfo.fromJson(u as Map<String, dynamic>))
            .toList(),
      );
}
