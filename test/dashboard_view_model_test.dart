import 'package:flutter_test/flutter_test.dart';
import 'package:sensor_hub/repositories/fake_sensor_repository.dart';
import 'package:sensor_hub/viewmodels/dashboard_state.dart';
import 'package:sensor_hub/viewmodels/dashboard_view_model.dart';

void main() {
  test('la même instance échoue puis réussit', () async {
    final repository = FakeSensorRepository(
      delay: Duration.zero,
      failuresBeforeSuccess: 1,
    );
    final viewModel = DashboardViewModel(repository: repository);
    addTearDown(viewModel.dispose);

    await viewModel.load();

    expect(viewModel.state, isA<DashboardError>());
    expect(viewModel.lastSuccessfulRefresh, isNull);
    expect(viewModel.lastRefreshLabel, 'Aucune actualisation réussie');
    expect(repository.loadCount, 1);

    await viewModel.load();

    expect(viewModel.state, isA<DashboardSuccess>());
    expect(viewModel.lastSuccessfulRefresh, isNotNull);
    expect(
      viewModel.lastRefreshLabel,
      startsWith('Dernière actualisation réussie à '),
    );
    expect(repository.loadCount, 2);
  });

  test('des actualisations simultanées ne lancent qu’un chargement', () async {
    final repository = FakeSensorRepository(
      delay: const Duration(milliseconds: 40),
    );
    final viewModel = DashboardViewModel(repository: repository);
    addTearDown(viewModel.dispose);
    final states = <DashboardState>[];
    viewModel.addListener(() => states.add(viewModel.state));

    await Future.wait([viewModel.load(), viewModel.load(), viewModel.load()]);

    expect(repository.loadCount, 1);
    expect(states.whereType<DashboardLoading>(), hasLength(1));
    expect(viewModel.state, isA<DashboardSuccess>());
  });

  test('une erreur après un succès conserve l’heure', () async {
    final repository = FakeSensorRepository(delay: Duration.zero);
    final viewModel = DashboardViewModel(repository: repository);
    addTearDown(viewModel.dispose);

    await viewModel.load();
    final refreshedAt = viewModel.lastSuccessfulRefresh;
    expect(refreshedAt, isNotNull);

    repository.shouldFail = true;
    await viewModel.load();

    expect(viewModel.state, isA<DashboardError>());
    expect(viewModel.lastSuccessfulRefresh, refreshedAt);
    expect(repository.loadCount, 2);
    expect(
      viewModel.lastRefreshLabel,
      startsWith('Dernière actualisation réussie à '),
    );
  });

  test('les données deviennent anciennes après le seuil', () async {
    final viewModel = DashboardViewModel(
      repository: FakeSensorRepository(delay: Duration.zero),
      staleAfter: const Duration(milliseconds: 30),
    );
    addTearDown(viewModel.dispose);

    await viewModel.load();
    expect(viewModel.isStale, isFalse);

    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(viewModel.isStale, isTrue);
    expect(viewModel.lastRefreshLabel, contains('Données anciennes'));
  });
}
