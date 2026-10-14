import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:boilerplate_flutter/app.dart';
import 'package:boilerplate_flutter/core/providers/core_providers.dart';
import 'package:boilerplate_flutter/core/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences mockPrefs;

  setUp(() async {
    dotenv.loadFromString(
      envString: 'API_BASE_URL=https://api.margamulya.com\nAPP_ENV=test',
    );
    FlutterSecureStorage.setMockInitialValues({});
    SharedPreferences.setMockInitialValues({});
    mockPrefs = await SharedPreferences.getInstance();
  });

  testWidgets('App initialization test', (WidgetTester tester) async {
    const mockSecure = FlutterSecureStorage();
    final storageService = StorageService(mockPrefs, mockSecure);
    await storageService.init();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          secureStorageProvider.overrideWithValue(mockSecure),
          storageServiceProvider.overrideWithValue(storageService),
        ],
        child: const MargaMulyaApp(),
      ),
    );
    expect(find.byType(MargaMulyaApp), findsOneWidget);

    // Pump past the splash delay and animations to flush pending timers
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 500));
  });
}
