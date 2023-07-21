class Member {
  String id;
  String smallTeamId;
  String firstName;
  String lastName;
  String middleName;
  String nationality;
  DateTime birthDate;
  String gender;
  DateTime registrationDate;
  String fullName;

  Member({
    required this.id,
    required this.smallTeamId,
    required this.firstName,
    required this.lastName,
    required this.middleName,
    required this.nationality,
    required this.birthDate,
    required this.gender,
    required this.registrationDate,
    required this.fullName,
  });

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      id: map['id'] ?? '',
      smallTeamId: map['small_team_id'] ?? '',
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      middleName: map['middle_name'] ?? '',
      nationality: map['nationality'] ?? '',
      birthDate: DateTime.parse(map['birth_date'] ?? ''),
      gender: map['gender'] ?? '',
      registrationDate: DateTime.parse(map['registration_date'] ?? ''),
      fullName: map['full_name'] ?? '',
    );
  }
  @override
  String toString() {
    return 'Member: { id: $id, fullName: $fullName, ... }';
  }
}
