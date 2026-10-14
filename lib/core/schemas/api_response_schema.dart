import 'package:equatable/equatable.dart';
import 'pagination_schema.dart';

class ApiResponseSchema<T> extends Equatable {
  final bool success;
  final String message;
  final T? data;
  final PaginationSchema? pagination;
  final Map<String, List<String>>? errors;
  final int? statusCode;

  const ApiResponseSchema({
    required this.success,
    required this.message,
    this.data,
    this.pagination,
    this.errors,
    this.statusCode,
  });

  factory ApiResponseSchema.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    return ApiResponseSchema<T>(
      success: json['success'] as bool? ?? (json['status'] == 'success' || json['status'] == true),
      message: json['message'] as String? ?? '',
      data: json['data'] != null && fromJsonT != null ? fromJsonT(json['data']) : json['data'] as T?,
      pagination: json['pagination'] != null
          ? PaginationSchema.fromJson(json['pagination'] as Map<String, dynamic>)
          : (json['meta'] != null
              ? PaginationSchema.fromJson(json['meta'] as Map<String, dynamic>)
              : null),
      errors: json['errors'] != null
          ? (json['errors'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                key,
                (value is List) ? value.map((e) => e.toString()).toList() : [value.toString()],
              ),
            )
          : null,
      statusCode: json['status_code'] as int? ?? json['code'] as int?,
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T data)? toJsonT) {
    return {
      'success': success,
      'message': message,
      if (data != null) 'data': toJsonT != null ? toJsonT(data as T) : data,
      if (pagination != null) 'pagination': pagination!.toJson(),
      if (errors != null) 'errors': errors,
      if (statusCode != null) 'status_code': statusCode,
    };
  }

  @override
  List<Object?> get props => [success, message, data, pagination, errors, statusCode];
}
