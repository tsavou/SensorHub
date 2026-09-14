import 'package:flutter/material.dart';
import 'package:sensor_hub/data/mock_sensors.dart';
import 'package:sensor_hub/models/sensor.dart';
import 'package:sensor_hub/widgets/sensor_card.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key, List<Sensor>? sensors})
    : sensors = sensors ?? mockSensors;

  final List<Sensor> sensors;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'SensorHub',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Actualiser',
                    onPressed: () {},
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Mes capteurs', style: theme.textTheme.titleMedium),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: sensors.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return SensorCard(sensor: sensors[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
