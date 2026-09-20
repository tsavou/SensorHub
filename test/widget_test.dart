import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensor_hub/main.dart';
import 'package:sensor_hub/repositories/fake_sensor_repository.dart';
import 'package:sensor_hub/screens/dashboard_screen.dart';
import 'package:sensor_hub/viewmodels/dashboard_view_model.dart';

void main() {
  testWidgets('affiche la liste des capteurs et ouvre un détail', (
    tester,
  ) async {
    await tester.pumpWidget(const SensorHubApp());
    await tester.pump();
    await tester.pump(FakeSensorRepository.defaultDelay);
    await tester.pumpAndSettle();

    expect(find.text('SensorHub'), findsOneWidget);
    expect(find.text('Mes capteurs'), findsOneWidget);
    expect(find.text('Salon'), findsOneWidget);
    expect(find.text('Garage'), findsOneWidget);
    expect(find.text('Cave'), findsOneWidget);
    expect(find.text('Hors ligne'), findsOneWidget);
    expect(find.text('Alerte'), findsOneWidget);
    expect(find.text('En ligne'), findsOneWidget);

    await tester.tap(find.text('Salon'));
    await tester.pumpAndSettle();

    expect(find.text('Capteur du salon'), findsOneWidget);
    expect(find.text('Température'), findsOneWidget);
    expect(find.text('21,8°C'), findsOneWidget);
    expect(find.text('Humidité'), findsOneWidget);
    expect(find.text('Batterie'), findsOneWidget);
    expect(find.text('État'), findsOneWidget);
    expect(find.text('OK'), findsOneWidget);
    expect(find.text('Dernière mesure'), findsOneWidget);
  });

  testWidgets('affiche une erreur simulée par le fake', (tester) async {
    final viewModel = DashboardViewModel(
      repository: FakeSensorRepository(delay: Duration.zero, shouldFail: true),
    );

    await tester.pumpWidget(
      CupertinoApp(home: DashboardScreen(viewModel: viewModel)),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1));

    expect(find.text('Impossible de charger les capteurs.'), findsOneWidget);
    expect(find.text('Réessayer'), findsOneWidget);
  });
}
