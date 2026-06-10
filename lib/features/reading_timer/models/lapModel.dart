import 'package:cloud_firestore/cloud_firestore.dart';

class LapModel {
  final String? id;
  final int durationInSeconds;
  final DateTime createdAt;
  final String formattedLap;

  LapModel({
    this.id,
    required this.durationInSeconds,
    required this.createdAt,
    required this.formattedLap,
  });

  Map<String, dynamic> toMap() {
    return {
      'durationInSeconds': durationInSeconds,
      'createdAt': createdAt, 
      'formateddLap': formattedLap
    };
  }

  factory LapModel.fromMap(Map<String, dynamic> map, String documentId) {
    return LapModel(
      id: documentId,
      durationInSeconds: map['durationInSeconds']?.toInt() ?? 0,
      createdAt: map['createdAt'] != null 
          ? (map['createdAt'] as Timestamp).toDate() 
          : DateTime.now(),
      formattedLap: map['formateddLap'].toString()
    );
  }

  LapModel copyWith({
    String? id,
    int? durationInSeconds,
    DateTime? createdAt,
    String? formateddLap,
  }) {
    return LapModel(
      id: id ?? this.id,
      durationInSeconds: durationInSeconds ?? this.durationInSeconds,
      createdAt: createdAt ?? this.createdAt,
      formattedLap: formateddLap ?? this.formattedLap,
    );
  }

  String get formattedDuration {
    int h = durationInSeconds ~/ 3600;
    int m = (durationInSeconds % 3600) ~/ 60;
    int s = durationInSeconds % 60;
    
    String hoursStr = h.toString().padLeft(2, '0');
    String minutesStr = m.toString().padLeft(2, '0');
    String secondsStr = s.toString().padLeft(2, '0');

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  String get formattedDate {
    return "${createdAt.day.toString().padLeft(2, '0')}/${createdAt.month.toString().padLeft(2, '0')}/${createdAt.year}";
  }

  String get formattedTime {
    return "às ${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}";
  }
}