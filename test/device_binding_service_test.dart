import 'package:drift_pos/core/services/device_binding_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    DeviceBindingService.setTestMachineIdOverride('test-machine-a');
  });

  tearDown(() {
    DeviceBindingService.setTestMachineIdOverride(null);
  });

  test('first launch binds the current device', () async {
    final result = await DeviceBindingService.ensureAuthorized();

    expect(result.isAuthorized, isTrue);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(DeviceBindingService.storageKey), isNotEmpty);
  });

  test('matching device is authorized on later launches', () async {
    await DeviceBindingService.ensureAuthorized();

    final result = await DeviceBindingService.ensureAuthorized();

    expect(result.isAuthorized, isTrue);
  });

  test('different device is blocked', () async {
    await DeviceBindingService.ensureAuthorized();

    DeviceBindingService.setTestMachineIdOverride('test-machine-b');
    final result = await DeviceBindingService.ensureAuthorized();

    expect(result.isAuthorized, isFalse);
    expect(result.reason, isNotEmpty);
  });

  test('rebindCurrentDevice registers the current machine', () async {
    await DeviceBindingService.ensureAuthorized();

    DeviceBindingService.setTestMachineIdOverride('replacement-machine');
    await DeviceBindingService.rebindCurrentDevice();

    final result = await DeviceBindingService.ensureAuthorized();
    expect(result.isAuthorized, isTrue);
  });
}
