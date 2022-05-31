import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/datasource/remote/firebase/firebase_remote_config.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/images/explore/exclamation_circle.dart';
import 'package:seeds/images/explore/invite_person.dart';
import 'package:seeds/images/explore/plant_seeds.dart';
import 'package:seeds/images/explore/regions.dart';
import 'package:seeds/images/explore/seeds_symbol.dart';
import 'package:seeds/images/explore/swap_seeds.dart';
import 'package:seeds/images/explore/vote.dart';
import 'package:seeds/images/explore/vouch.dart';
import 'package:seeds/navigation/navigation_service.dart';
import 'package:seeds/screens/explore_screens/explore/components/explore_card.dart';
import 'package:seeds/screens/explore_screens/explore/interactor/viewmodels/explore_bloc.dart';
import 'package:seeds/screens/explore_screens/explore/interactor/viewmodels/explore_item.dart';
import 'package:seeds/utils/build_context_extension.dart';

class ExploreView extends StatelessWidget {
  const ExploreView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ExploreItem> exploreItems = [
      ExploreItem(
          title: context.loc.explorerRegionsItemTitle,
          icon: const Padding(
              padding: EdgeInsets.only(left: 2.0), child: CustomPaint(size: Size(40, 40), painter: Regions())),
          onTapEvent: const OnRegionsTapped()),
      ExploreItem(
          title: context.loc.explorerInviteItemTitle,
          icon: const Padding(
              padding: EdgeInsets.only(left: 6.0), child: CustomPaint(size: Size(40, 40), painter: InvitePerson())),
          onTapEvent: const OnExploreCardTapped(Routes.createInvite)),
      ExploreItem(
          title: context.loc.explorerVouchItemTitle,
          icon: const CustomPaint(size: Size(35, 41), painter: Vouch()),
          onTapEvent: const OnExploreCardTapped(Routes.vouch)),
      ExploreItem(
          title: context.loc.explorerFlagItemTitle,
          icon: const CustomPaint(size: Size(41, 41), painter: ExclamationCircle()),
          onTapEvent: const OnFlagUserTapped()),
      ExploreItem(
        title: context.loc.explorerVoteItemTitle,
        icon: const Padding(
            padding: EdgeInsets.only(right: 6.0), child: CustomPaint(size: Size(40, 40), painter: Vote())),
        onTapEvent: const OnExploreCardTapped(Routes.vote),
      ),
      ExploreItem(
        title: context.loc.explorerPlantItemTitle,
        icon: const CustomPaint(size: Size(31, 41), painter: PlantSeeds()),
        onTapEvent: const OnExploreCardTapped(Routes.plantSeeds),
      ),
      ExploreItem(
        title: context.loc.explorerUnplantItemTitle,
        icon: const CustomPaint(size: Size(31, 41), painter: PlantSeeds()),
        onTapEvent: const OnExploreCardTapped(Routes.unPlantSeeds),
      ),
      ExploreItem(
        title: context.loc.explorerSwapItemTitle,
        icon: const CustomPaint(size: Size(24, 24), painter: SwapSeeds()),
        iconUseCircleBackground: false,
        onTapEvent: const OnExploreCardTapped(Routes.swapSeeds),
      ),
      ExploreItem(
        title: context.loc.explorerGetSeedsItemTitle,
        icon: const CustomPaint(size: Size(9, 22), painter: SeedsSymbol()),
        backgroundIconColor: AppColors.white,
        backgroundImage: 'assets/images/explore/get_seeds_card.png',
        gradient: const LinearGradient(
          colors: [AppColors.green1, AppColors.green2],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        iconUseCircleBackground: false,
        onTapEvent: const OnBuySeedsCardTapped(),
      ),
    ];
    if (!remoteConfigurations.featureFlagP2PEnabled) {
      exploreItems.removeWhere((i) => i.title == context.loc.explorerSwapItemTitle);
    }
    if (!remoteConfigurations.featureFlagRegionsEnabled) {
      exploreItems.removeWhere((i) => i.title == context.loc.explorerRegionsItemTitle);
    }
    return GridView.count(
      padding: const EdgeInsets.all(18),
      crossAxisSpacing: 18,
      mainAxisSpacing: 18,
      crossAxisCount: 2,
      children: [
        for (final i in exploreItems)
          ExploreCard(
            title: i.title,
            icon: i.icon,
            backgroundIconColor: i.backgroundIconColor,
            iconUseCircleBackground: i.iconUseCircleBackground,
            backgroundImage: i.backgroundImage,
            gradient: i.gradient,
            onTap: () => BlocProvider.of<ExploreBloc>(context).add(i.onTapEvent),
          )
      ],
    );
  }
}
