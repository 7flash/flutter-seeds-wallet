import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:seeds/constants/app_colors.dart';
import 'package:seeds/screens/authentication/onboarding/components/onboarding_pages.dart';

class ThirdPage extends StatelessWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return OnboardingPage(
      onboardingImage: "assets/images/onboarding/onboarding3.png",
      topPadding: 50,
      title: localization.onboardingEconomyTitle,
      subTitle: localization.onboardingEconomySubtitle,
      topLeaf1: Positioned(
        right: -20,
        top: -90,
        child: SvgPicture.asset(
          'assets/images/onboarding/leaves/pointing_right/big_light_leaf.svg',
          color: AppColors.lightGreen3,
        ),
      ),
      bottomLeaf1: Positioned(
        right: 100,
        bottom: 90,
        child: SvgPicture.asset('assets/images/onboarding/leaves/pointing_left/small_light_leaf.svg'),
      ),
      bottomLeaf2: Positioned(
        left: 30,
        top: 20,
        child: SvgPicture.asset('assets/images/onboarding/leaves/pointing_left/medium_dark_leaf.svg'),
      ),
    );
  }
}
