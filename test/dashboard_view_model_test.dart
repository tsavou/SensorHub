import 'package:flutter_test/flutter_test.dart';
import 'package:sensor_hub/repositories/fake_sensor_repository.dart';
import 'package:sensor_hub/viewmodels/dashboard_state.dart';
import 'package:sensor_hub/viewmodels/dashboard_view_model.dart';

void main() {
  test('un listener observe loading puis success, sans widget', () async {
    final viewModel = DashboardViewModel(
      repository: FakeSensorRepository(delay: Duration.zero),
    );
    final states = <DashboardState>[];
    viewModel.addListener(() => states.add(viewModel.state));

    expect(viewModel.state, isA<DashboardInitial>());

    await viewModel.load();

    expect(states, hasLength(2));
    expect(states[0], isA<DashboardLoading>());
    expect(states[1], isA<DashboardSuccess>());
    expect((states[1] as DashboardSuccess).sensors, hasLength(3));
  });

  test('un listener observe loading puis error, sans widget', () async {
    final viewModel = DashboardViewModel(
      repository: FakeSensorRepository(delay: Duration.zero, shouldFail: true),
    );
    final states = <DashboardState>[];
    viewModel.addListener(() => states.add(viewModel.state));

    await viewModel.load();

    expect(states[0], isA<DashboardLoading>());
    expect(states[1], isA<DashboardError>());
    expect(
      (states[1] as DashboardError).message,
      'Impossible de charger les capteurs.',
    );
  });
}
