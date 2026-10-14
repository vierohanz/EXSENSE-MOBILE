import 'package:equatable/equatable.dart';

class PaginationSchema extends Equatable {
  final int currentPage;
  final int totalPages;
  final int perPage;
  final int totalItems;
  final bool hasNextPage;
  final bool hasPrevPage;

  const PaginationSchema({
    required this.currentPage,
    required this.totalPages,
    required this.perPage,
    required this.totalItems,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory PaginationSchema.fromJson(Map<String, dynamic> json) {
    final current = json['current_page'] as int? ?? json['page'] as int? ?? 1;
    final total = json['total_pages'] as int? ?? json['last_page'] as int? ?? 1;
    final per = json['per_page'] as int? ?? json['limit'] as int? ?? 15;
    final totalCount = json['total'] as int? ?? json['total_items'] as int? ?? 0;

    return PaginationSchema(
      currentPage: current,
      totalPages: total,
      perPage: per,
      totalItems: totalCount,
      hasNextPage: json['has_next'] as bool? ?? (current < total),
      hasPrevPage: json['has_prev'] as bool? ?? (current > 1),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'total_pages': totalPages,
      'per_page': perPage,
      'total_items': totalItems,
      'has_next': hasNextPage,
      'has_prev': hasPrevPage,
    };
  }

  @override
  List<Object?> get props => [
        currentPage,
        totalPages,
        perPage,
        totalItems,
        hasNextPage,
        hasPrevPage,
      ];
}
