import 'package:get/get.dart';
import '../network/api_client.dart';
import '../router/app_router.dart';
import '../services/storage_service.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/home/presentation/controllers/home_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Storage Service
    final storageService = Get.isRegistered<StorageService>()
        ? Get.find<StorageService>()
        : Get.put<StorageService>(StorageService(), permanent: true);

    // Network / API Client
    Get.lazyPut<ApiClient>(
      () => ApiClient(
        storageService: storageService,
        onUnauthorized: () {
          Get.offAllNamed(Routes.login);
        },
      ),
      fenix: true,
    );

    // Auth Data Sources
    Get.lazyPut<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(Get.find<StorageService>()),
      fenix: true,
    );
    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(Get.find<ApiClient>()),
      fenix: true,
    );

    // Auth Repository
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: Get.find<AuthRemoteDataSource>(),
        localDataSource: Get.find<AuthLocalDataSource>(),
      ),
      fenix: true,
    );

    // Auth UseCases
    Get.lazyPut<LoginUseCase>(
      () => LoginUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );

    // Controllers
    Get.put<AuthController>(
      AuthController(
        storageService: storageService,
        loginUseCase: Get.find<LoginUseCase>(),
        authRemoteDataSource: Get.find<AuthRemoteDataSource>(),
        authLocalDataSource: Get.find<AuthLocalDataSource>(),
        authRepository: Get.find<AuthRepository>(),
      ),
      permanent: true,
    );

    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
  }
}
