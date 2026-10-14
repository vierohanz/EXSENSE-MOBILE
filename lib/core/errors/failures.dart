import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'Terjadi kesalahan pada server',
    int? statusCode,
  ]) : super(statusCode: statusCode);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Tidak ada koneksi internet']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Gagal memproses data lokal']);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([
    super.message = 'Sesi telah berakhir, silakan login kembali',
  ]) : super(statusCode: 401);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message) : super(statusCode: 422);
}
