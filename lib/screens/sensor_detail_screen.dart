import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:sensor_hub/models/sensor.dart';
import 'package:sensor_hub/theme/app_theme.dart';
import 'package:sensor_hub/utils/formatters.dart';
import 'package:sensor_hub/viewmodels/dashboard_view_model.dart';
import 'package:sensor_hub/widgets/status_badge.dart';

class SensorDetailScreen extends StatelessWidget {
  const SensorDetailScreen({
    super.key,
    required this.sensorId,
    required this.viewModel,
  });

  final String sensorId;
  final DashboardViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final sensor = viewModel.findById(sensorId);
    if (sensor == null) {
      return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          previousPageTitle: 'SensorHub',
          middle: Text('Capteur introuvable'),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.search,
                  size: 40,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
                const SizedBox(height: 12),
                const Text('Aucun capteur ne correspond à cet identifiant.'),
                const SizedBox(height: 16),
                CupertinoButton.filled(
                  onPressed: () => _goBack(context),
                  child: const Text('Retour à la liste'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return _SensorDetailBody(sensor: sensor);
  }

  static void _goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }
}

class _SensorDetailBody extends StatelessWidget {
  const _SensorDetailBody({required this.sensor});

  final Sensor sensor;

  @override
  Widget build(BuildContext context) {
    final isOffline = !sensor.isOnline;
    final isAlert = sensor.status == SensorStatus.alert;
    final secondary = CupertinoColors.secondaryLabel.resolveFrom(context);
    final labelColor = CupertinoColors.label.resolveFrom(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'SensorHub',
        middle: Text(sensor.detailTitle),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatusBadge(sensor: sensor, connectionOnly: true),
                  if (isOffline) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Dernières valeurs connues, le capteur ne répond plus.',
                      style: TextStyle(color: secondary, fontSize: 15),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Text(
                    formatTemperature(sensor.temperature),
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1,
                      color: isOffline ? secondary : labelColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Température',
                    style: TextStyle(color: secondary, fontSize: 17),
                  ),
                ],
              ),
            ),
            CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile(
                  leading: Icon(
                    CupertinoIcons.drop,
                    color: CupertinoColors.systemBlue.resolveFrom(context),
                  ),
                  title: const Text('Humidité'),
                  additionalInfo: Text(formatPercent(sensor.humidity)),
                ),
                CupertinoListTile(
                  leading: Icon(
                    CupertinoIcons.battery_25_percent,
                    color: _batteryColor(context, sensor.battery),
                  ),
                  title: const Text('Batterie'),
                  additionalInfo: Text(
                    formatPercent(sensor.battery),
                    style: TextStyle(
                      color: _batteryColor(context, sensor.battery),
                    ),
                  ),
                ),
                CupertinoListTile(
                  leading: Icon(
                    isAlert
                        ? CupertinoIcons.exclamationmark_triangle_fill
                        : CupertinoIcons.check_mark_circled,
                    color: isAlert
                        ? CupertinoColors.systemOrange.resolveFrom(context)
                        : AppTheme.primary,
                  ),
                  title: const Text('État'),
                  additionalInfo: Text(
                    sensor.etatLabel,
                    style: TextStyle(
                      color: isAlert
                          ? CupertinoColors.systemOrange.resolveFrom(context)
                          : AppTheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              header: const Text('Dernière mesure'),
              children: [
                CupertinoListTile(
                  title: Text(formatDateTime(sensor.lastMeasurement)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Color _batteryColor(BuildContext context, int battery) {
    if (battery <= 20) {
      return CupertinoColors.systemRed.resolveFrom(context);
    }
    if (battery <= 40) {
      return CupertinoColors.systemOrange.resolveFrom(context);
    }
    return AppTheme.primary;
  }
}
