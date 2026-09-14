import 'package:flutter/cupertino.dart';
import 'package:sensor_hub/utils/formatters.dart';
import 'package:sensor_hub/viewmodels/dashboard_view_model.dart';
import 'package:sensor_hub/widgets/sensor_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.viewModel});

  final DashboardViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final sensors = viewModel.sensors;

    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('SensorHub'),
            border: null,
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => _showRefreshMessage(context),
              child: const Icon(CupertinoIcons.refresh),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Text(
                _summaryLabel(
                  total: sensors.length,
                  offlineCount: viewModel.offlineCount,
                  alertCount: viewModel.alertCount,
                ),
                style: TextStyle(
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                  fontSize: 15,
                ),
              ),
            ),
          ),
          if (sensors.isEmpty)
            const SliverFillRemaining(child: _EmptySensors())
          else ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 20, 20, 4),
                child: Text(
                  'Mes capteurs',
                  style: TextStyle(
                    color: CupertinoColors.secondaryLabel.resolveFrom(context),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SliverList.builder(
              itemCount: sensors.length,
              itemBuilder: (context, index) {
                final sensor = sensors[index];
                return CupertinoListSection.insetGrouped(
                  margin: const EdgeInsets.fromLTRB(20, 6, 20, 6),
                  children: [SensorCard(sensor: sensor)],
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  static String _summaryLabel({
    required int total,
    required int offlineCount,
    required int alertCount,
  }) {
    final parts = <String>[sensorCountLabel(total)];
    if (alertCount > 0) {
      parts.add('$alertCount alerte${alertCount > 1 ? 's' : ''}');
    }
    if (offlineCount > 0) {
      parts.add('$offlineCount hors ligne');
    }
    return parts.join(' · ');
  }

  static void _showRefreshMessage(BuildContext context) {
    showCupertinoDialog<void>(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: const Text('Actualisation'),
          content: const Text(
            'Les données sont encore locales. L’actualisation arrivera plus tard.',
          ),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class _EmptySensors extends StatelessWidget {
  const _EmptySensors();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CupertinoIcons.wifi_slash,
            size: 40,
            color: CupertinoColors.secondaryLabel.resolveFrom(context),
          ),
          const SizedBox(height: 12),
          const Text('Aucun capteur'),
          const SizedBox(height: 4),
          Text(
            'Les capteurs apparaîtront ici.',
            style: TextStyle(
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
          ),
        ],
      ),
    );
  }
}
