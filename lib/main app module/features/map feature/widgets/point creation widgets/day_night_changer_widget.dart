
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  TimeOfDay timeOfDay = TimeOfDay.day;

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
            child: CupertinoSlidingSegmentedControl<TimeOfDay>(
              children: const {
                TimeOfDay.day: Text(
                  'День',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                TimeOfDay.night: Text(
                  'Ночь',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              },
              onValueChanged: (value) {
                if (value != null) {
                  setState(() {
                    timeOfDay = value;
                  });
                  switch (timeOfDay) {
                    case TimeOfDay.day:
                      _boolInput!.value = true;
                      break;
                    case TimeOfDay.night:
                      _boolInput!.value = false;
                      break;
                  }
                }
              },
              groupValue: timeOfDay,
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

enum TimeOfDay {
  day,
  night,
}
