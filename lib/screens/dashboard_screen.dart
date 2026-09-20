import 'package:flutter/cupertino.dart';
import 'package:sensor_hub/utils/formatters.dart';
import 'package:sensor_hub/viewmodels/dashboard_state.dart';
import 'package:sensor_hub/viewmodels/dashboard_view_model.dart';
import 'package:sensor_hub/widgets/sensor_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.viewModel});

  final DashboardViewModel viewModel;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardViewModel get _viewModel => widget.viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel.load();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final state = _viewModel.state;
        final isLoading =
            state is DashboardLoading || state is DashboardInitial;

        return CupertinoPageScaffold(
          child: CustomScrollView(
            slivers: [
              CupertinoSliverNavigationBar(
                largeTitle: const Text('SensorHub'),
                border: null,
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: isLoading ? null : _viewModel.load,
                  child: isLoading
                      ? const CupertinoActivityIndicator()
                      : const Icon(CupertinoIcons.refresh),
                ),
              ),
              ..._sliversFor(context, state),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _sliversFor(BuildContext context, DashboardState state) {
    return switch (state) {
      DashboardInitial() || DashboardLoading() => const [
        SliverFillRemaining(child: Center(child: CupertinoActivityIndicator())),
      ],
      DashboardError(:final message) => [
        SliverFillRemaining(
          child: _ErrorSensors(message: message, onRetry: _viewModel.load),
        ),
      ],
      DashboardSuccess(:final sensors) when sensors.isEmpty => const [
        SliverFillRemaining(child: _EmptySensors()),
      ],
      DashboardSuccess(
        :final sensors,
        :final offlineCount,
        :final alertCount,
      ) =>
        [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Text(
                _summaryLabel(
                  total: sensors.length,
                  offlineCount: offlineCount,
                  alertCount: alertCount,
                ),
                style: TextStyle(
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                  fontSize: 15,
                ),
              ),
            ),
          ),
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
    };
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

class _ErrorSensors extends StatelessWidget {
  const _ErrorSensors({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.exclamationmark_triangle,
              size: 40,
              color: CupertinoColors.systemOrange.resolveFrom(context),
            ),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            CupertinoButton.filled(
              onPressed: onRetry,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
