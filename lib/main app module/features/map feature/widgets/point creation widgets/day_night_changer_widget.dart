import 'package:fishy/main%20app%20module/features/map%20feature/providers/point_creation_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rive/rive.dart';

class DayNightChangerWidget extends StatefulWidget {
  const DayNightChangerWidget({
    super.key,
  });

  @override
  State<DayNightChangerWidget> createState() => _DayNightChangerWidgetState();
}

class _DayNightChangerWidgetState extends State<DayNightChangerWidget> {
  SMIInput<bool>? _boolInput;

  void _onInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine 1',
    );
    artboard.addController(controller!);
    _boolInput = controller.findInput<bool>('day') as SMIBool;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      height: 230,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 185,
            child: RiveAnimation.asset(
              'assets/images/sunmoonanim.riv',
              onInit: _onInit,
              fit: BoxFit.fitWidth,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                final isDay = ref.watch(dayNightProvider);

                return CupertinoSlidingSegmentedControl<bool>(
                  children: const {
                    true: Text(
                      'День',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    false: Text(
                      'Ночь',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  },
                  onValueChanged: (value) {
                    if (value != null) {
                      ref.read(dayNightProvider.notifier).state = value;

                      switch (isDay) {
                        case true:
                          _boolInput!.value = false;
                          break;
                        case false:
                          _boolInput!.value = true;
                          break;
                      }
                    }
                  },
                  groupValue: isDay,
                );
              },
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
