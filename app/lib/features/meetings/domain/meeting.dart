class Meeting {
  const Meeting({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.host,
    required this.preparation,
    required this.participants,
    required this.location,
    required this.note,
    required this.isImportant,
    required this.unitId,
    this.createdAt,
  });

  final int id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String host;
  final String preparation;
  final String participants;
  final String location;
  final String note;
  final bool isImportant;
  final int unitId;
  final DateTime? createdAt;

  factory Meeting.fromJson(Map<String, dynamic> json) => Meeting(
        id: json['id'] as int,
        title: json['title'] as String,
        startTime: DateTime.parse(json['start_time'] as String),
        endTime: DateTime.parse(json['end_time'] as String),
        host: json['host'] as String? ?? '',
        preparation: json['preparation'] as String? ?? '',
        participants: json['participants'] as String? ?? '',
        location: json['location'] as String,
        note: json['note'] as String? ?? '',
        isImportant: json['is_important'] as bool? ?? false,
        unitId: json['unit'] as int,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : null,
      );
}

class MeetingDraft {
  const MeetingDraft({
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.host,
    required this.preparation,
    required this.participants,
    required this.location,
    required this.note,
    required this.isImportant,
    required this.unitId,
  });

  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final String host;
  final String preparation;
  final String participants;
  final String location;
  final String note;
  final bool isImportant;
  final int unitId;

  Map<String, dynamic> toJson() => {
        'title': title,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'host': host,
        'preparation': preparation,
        'participants': participants,
        'location': location,
        'note': note,
        'is_important': isImportant,
        'unit': unitId,
      };
}
