import 'package:fishy/constants.dart';
import 'package:fishy/repositories/local_storage_repo.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../reusable widgets/green_button.dart';

class FishyIntroductionScreen extends ConsumerStatefulWidget {
  const FishyIntroductionScreen({super.key, this.isComplete});
  final void Function(bool)? isComplete;
  @override
  ConsumerState<FishyIntroductionScreen> createState() =>
      _FishyIntroductionScreenState();
}

class _FishyIntroductionScreenState
    extends ConsumerState<FishyIntroductionScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  late final SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    prefs = ref.read(sharedPrefsProvider);
  }

  @override
  Widget build(BuildContext context) {
    var pages = [
      SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: SvgPicture.asset(
                'assets/images/intro0.svg',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                'Приветствуем в Fishy!',
                style: Theme.of(context).textTheme.displayLarge!,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'В этом приложении есть всё необходимоё для хранения данных о рыбалке: карта с гео-маркерами, личная галерея пойманной рыбы и многое другое',
                style: Theme.of(context).textTheme.bodyLarge!,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: GreenButton(
                  buttonSize: Size(45.w, 56),
                  buttonText: 'Далее',
                  onTap: () {
                    introKey.currentState?.animateScroll(1);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: SvgPicture.asset(
                'assets/images/intro1.svg',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                'Рыбная карта',
                style: Theme.of(context).textTheme.displayLarge!,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Отмечайте рыбные позиции на карте, оставляйте информацию об этой позиции, делитесь впечатлениями и информацией о рыбалке',
                style: Theme.of(context).textTheme.bodyLarge!,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: GreenButton(
                  buttonSize: Size(45.w, 56),
                  buttonText: 'Далее',
                  onTap: () {
                    introKey.currentState?.animateScroll(2);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: SvgPicture.asset(
                'assets/images/intro2.svg',
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                'Галерея улова',
                style: Theme.of(context).textTheme.displayLarge!,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Сохраняйте свои лучшие уловы в галерею и делитесь ими с другими рыбаками',
                style: Theme.of(context).textTheme.bodyLarge!,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: GreenButton(
                  buttonSize: Size(45.w, 56),
                  buttonText: 'Начать',
                  onTap: () async {
                    widget.isComplete!(
                      await prefs.setBool(
                        introCompletedKey,
                        true,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ];
    return IntroductionScreen(
      key: introKey,

      // pages: pages,
      rawPages: pages,
      curve: Curves.easeInOutBack,
      animationDuration: 700,
      showDoneButton: false,
      showNextButton: false,
      controlsPosition: const Position(left: 0, right: 0, bottom: 20),
      dotsDecorator: DotsDecorator(
        activeSize: const Size(28, 10),
        size: const Size(10, 10),
        color: grayscalePlacehold,
        activeColor: blackColor,
        spacing: const EdgeInsets.symmetric(horizontal: 7.0),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),
    );
  }
}
