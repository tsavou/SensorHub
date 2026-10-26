import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:sensor_hub/models/sensor.dart';
import 'package:sensor_hub/theme/app_theme.dart';
import 'package:sensor_hub/utils/formatters.dart';
import 'package:sensor_hub/viewmodels/dashboard_state.dart';
import 'package:sensor_hub/viewmodels/dashboard_view_model.dart';
import 'package:sensor_hub/widgets/status_badge.dart';

class SensorDetailScreen extends StatefulWidget {
  const SensorDetailScreen({
    super.key,
    required this.sensorId,
    required this.viewModel,
  });

  final String sensorId;
  final DashboardViewModel viewModel;

  @override
  State<SensorDetailScreen> createState() => _SensorDetailScreenState();
}

class _SensorDetailScreenState extends State<SensorDetailScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.viewModel.state is DashboardInitial) {
      widget.viewModel.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        return switch (widget.viewModel.state) {
          DashboardInitial() || DashboardLoading() => const _DetailFallback(
            title: 'Capteur',
            child: Center(child: CupertinoActivityIndicator()),
          ),
          DashboardError(:final message) => _DetailFallback(
            title: 'Capteur',
            child: _DetailMessage(
              icon: CupertinoIcons.exclamationmark_triangle,
              iconColor: CupertinoColors.systemOrange.resolveFrom(context),
              message: message,
              actionLabel: 'Réessayer',
              onAction: widget.viewModel.load,
            ),
          ),
          DashboardSuccess(:final sensors) => _loaded(context, sensors),
        };
      },
    );
  }

  Widget _loaded(BuildContext context, List<Sensor> sensors) {
    final sensor = sensors
        .where((item) => item.id == widget.sensorId)
        .firstOrNull;
    if (sensor == null) {
      return _DetailFallback(
        title: 'Capteur introuvable',
        child: _DetailMessage(
          icon: CupertinoIcons.search,
          iconColor: CupertinoColors.secondaryLabel.resolveFrom(context),
          message: 'Aucun capteur ne correspond à cet identifiant.',
          actionLabel: 'Retour à la liste',
          onAction: () => _goBack(context),
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

class _DetailFallback extends StatelessWidget {
  const _DetailFallback({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        previousPageTitle: 'SensorHub',
        middle: Text(title),
      ),
      child: child,
    );
  }
}

class _DetailMessage extends StatelessWidget {
  const _DetailMessage({
    required this.icon,
    required this.iconColor,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final Color iconColor;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: iconColor),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            CupertinoButton.filled(
              onPressed: onAction,
              child: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
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
