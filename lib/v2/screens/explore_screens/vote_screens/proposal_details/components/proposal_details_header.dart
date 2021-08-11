import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/domain-shared/ui_constants.dart';
import 'package:seeds/v2/images/vote/proposal_category.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposal_details/interactor/viewmodels/bloc.dart';

class ProposalDetailsHeader extends StatelessWidget {
  const ProposalDetailsHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return BlocBuilder<ProposalDetailsBloc, ProposalDetailsState>(
      buildWhen: (previous, current) => previous.currentIndex != current.currentIndex,
      builder: (context, state) {
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(defaultCardBorderRadius),
              bottomRight: Radius.circular(defaultCardBorderRadius),
            ),
          ),
          height: width,
          child: Stack(
            fit: StackFit.expand,
            children: [
              FittedBox(
                clipBehavior: Clip.hardEdge,
                fit: BoxFit.cover,
                child: CachedNetworkImage(
                  imageUrl: state.proposals[state.currentIndex].image,
                  errorWidget: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                child: Container(
                  width: width,
                  height: 80,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black54, Colors.transparent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned(left: 0, top: 0, right: 0, child: AppBar(backgroundColor: Colors.transparent)),
              Positioned(
                bottom: kToolbarHeight + 42,
                left: 0,
                child: CustomPaint(
                  size: const Size(100, 40),
                  painter: const ProposalCategory(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    child: Text(
                      state.proposals[state.currentIndex].campaignTypeLabel,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
