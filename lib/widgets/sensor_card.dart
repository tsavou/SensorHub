import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:sensor_hub/models/sensor.dart';
import 'package:sensor_hub/theme/app_theme.dart';
import 'package:sensor_hub/utils/formatters.dart';
import 'package:sensor_hub/widgets/status_badge.dart';

class SensorCard extends StatelessWidget {
  const SensorCard({super.key, required this.sensor});

  final Sensor sensor;

  Color _accentColor(BuildContext context) {
    if (!sensor.isOnline) {
      return CupertinoColors.systemGrey.resolveFrom(context);
    }
    if (sensor.status == SensorStatus.alert) {
      return CupertinoColors.systemOrange.resolveFrom(context);
    }
    return AppTheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final isOffline = !sensor.isOnline;
    final muted = isOffline
        ? CupertinoColors.secondaryLabel.resolveFrom(context)
        : CupertinoColors.label.resolveFrom(context);

    return Semantics(
      button: true,
      label:
          '${sensor.name}, ${formatTemperature(sensor.temperature)}, ${sensor.cardStatusLabel}',
      child: CupertinoListTile(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        leadingSize: 12,
        leading: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: _accentColor(context),
            shape: BoxShape.circle,
          ),
        ),
        title: Text(sensor.name, style: TextStyle(color: muted)),
        subtitle: Row(
          children: [
            Icon(
              CupertinoIcons.drop,
              size: 14,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
            const SizedBox(width: 4),
            Text(
              formatPercent(sensor.humidity),
              style: TextStyle(
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
                fontSize: 15,
              ),
            ),
            const SizedBox(width: 8),
            StatusBadge(sensor: sensor),
          ],
        ),
        additionalInfo: Text(
          formatTemperature(sensor.temperature, withUnit: false),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: muted,
          ),
        ),
        trailing: const CupertinoListTileChevron(),
        onTap: () => context.push('/sensors/${sensor.id}'),
      ),
    );
  }
}
