import '../../domain/entities/acta_entity.dart';

class ActaModel extends ActaEntity {
  const ActaModel({
    required super.id,
    required super.userId,
    required super.imageUrl,
    super.status = 'pending',
    super.laplacianVariance = 0,
    super.extractedData,
    required super.createdAt,
  });

  factory ActaModel.fromJson(Map<String, dynamic> json) {
    return ActaModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      imageUrl: json['image_url'] as String,
      status: json['status'] as String? ?? 'pending',
      laplacianVariance: (json['laplacian_variance'] as num?)?.toDouble() ?? 0,
      extractedData: json['extracted_data'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'image_url': imageUrl,
      'status': status,
      'laplacian_variance': laplacianVariance,
      'extracted_data': extractedData,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ActaEntity toEntity() {
    return ActaEntity(
      id: id,
      userId: userId,
      imageUrl: imageUrl,
      status: status,
      laplacianVariance: laplacianVariance,
      extractedData: extractedData,
      createdAt: createdAt,
    );
  }

  factory ActaModel.fromEntity(ActaEntity entity) {
    return ActaModel(
      id: entity.id,
      userId: entity.userId,
      imageUrl: entity.imageUrl,
      status: entity.status,
      laplacianVariance: entity.laplacianVariance,
      extractedData: entity.extractedData,
      createdAt: entity.createdAt,
    );
  }
}
