class LivroModel {
  final String id;
  final String status;
  final int currentPage;
  final int totalPages;

  LivroModel({
    required this.id,
    required this.status,
    required this.currentPage,
    required this.totalPages,
  });

  factory LivroModel.fromMap(String id, Map<String, dynamic> map) {
    return LivroModel(
      id: id,
      status: map['status']?.toString().toLowerCase() ?? '',
      currentPage: (map['currentPage'] ?? 0) is num ? (map['currentPage'] as num).toInt() : 0,
      totalPages: (map['totalPages'] ?? 1) is num ? (map['totalPages'] as num).toInt() : 1,
    );
  }
}

class HistoricoModel {
  final String date;
  final int pagesRead;

  HistoricoModel({
    required this.date,
    required this.pagesRead,
  });

  factory HistoricoModel.fromMap(Map<String, dynamic> map) {
    return HistoricoModel(
      date: map['date']?.toString() ?? '',
      pagesRead: (map['pagesRead'] ?? 0) is num ? (map['pagesRead'] as num).toInt() : 0,
    );
  }
}

class MetaModel {
  final String categoria;
  final double alvo;
  final String livroId;
  final String titulo;

  MetaModel({
    required this.categoria,
    required this.alvo,
    required this.livroId,
    required this.titulo,
  });

  factory MetaModel.fromMap(Map<String, dynamic> map) {
    return MetaModel(
      categoria: map['categoria']?.toString() ?? '',
      alvo: (map['alvo'] ?? 1).toDouble(),
      livroId: map['livroId']?.toString() ?? '',
      titulo: map['titulo']?.toString().toLowerCase() ?? '',
    );
  }
}

class TimerLapModel {
  final int durationInSeconds;
  final DateTime? createdAt;

  TimerLapModel({
    required this.durationInSeconds,
    this.createdAt,
  });

  factory TimerLapModel.fromMap(Map<String, dynamic> map) {
    return TimerLapModel(
      durationInSeconds: (map['durationInSeconds'] ?? 0) is num 
          ? (map['durationInSeconds'] as num).toInt() 
          : 0,
      createdAt: map['createdAt'] != null 
          ? (map['createdAt'] as dynamic).toDate() 
          : null,
    );
  }
}