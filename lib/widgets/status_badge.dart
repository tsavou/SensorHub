import 'package:flutter/cupertino.dart';
import 'package:sensor_hub/models/sensor.dart';
import 'package:sensor_hub/theme/app_theme.dart';
import 'package:sensor_hub/utils/formatters.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.sensor,
    this.connectionOnly = false,
  });

  final Sensor sensor;
  final bool connectionOnly;

  @override
  Widget build(BuildContext context) {
    final isOffline = !sensor.isOnline;
    final isAlert =
        !connectionOnly &&
        sensor.isOnline &&
        sensor.status == SensorStatus.alert;
    final label = connectionOnly
        ? sensor.connectionLabel
        : sensor.cardStatusLabel;

    final Color foreground;
    final Color background;
    final IconData icon;

    if (isOffline) {
      foreground = CupertinoColors.secondaryLabel.resolveFrom(context);
      background = CupertinoColors.systemGrey5.resolveFrom(context);
      icon = CupertinoIcons.wifi_slash;
    } else if (isAlert) {
      foreground = CupertinoColors.systemOrange.resolveFrom(context);
      background = CupertinoColors.systemOrange
          .resolveFrom(context)
          .withValues(alpha: 0.16);
      icon = CupertinoIcons.exclamationmark_triangle_fill;
    } else {
      foreground = AppTheme.primary;
      background = AppTheme.primary.withValues(alpha: 0.12);
      icon = CupertinoIcons.wifi;
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: foreground),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: foreground,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
