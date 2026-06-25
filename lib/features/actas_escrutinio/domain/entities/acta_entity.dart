import 'package:equatable/equatable.dart';

class ActaEntity extends Equatable {
  final String id;
  final String userId;
  final String imageUrl;
  final String status;
  final double laplacianVariance;
  final Map<String, dynamic>? extractedData;
  final DateTime createdAt;

  const ActaEntity({
    required this.id,
    required this.userId,
    required this.imageUrl,
    this.status = 'pending',
    this.laplacianVariance = 0,
    this.extractedData,
    required this.createdAt,
  });

  ActaEntity copyWith({
    String? id,
    String? userId,
    String? imageUrl,
    String? status,
    double? laplacianVariance,
    Map<String, dynamic>? extractedData,
    DateTime? createdAt,
  }) {
    return ActaEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      laplacianVariance: laplacianVariance ?? this.laplacianVariance,
      extractedData: extractedData ?? this.extractedData,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        imageUrl,
        status,
        laplacianVariance,
        extractedData,
        createdAt,
      ];
}
