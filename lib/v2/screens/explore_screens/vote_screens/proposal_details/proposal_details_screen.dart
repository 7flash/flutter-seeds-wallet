import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/v2/components/full_page_error_indicator.dart';
import 'package:seeds/v2/components/full_page_loading_indicator.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposal_details/components/proposal_details_bottom.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposal_details/components/proposal_details_header.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposal_details/components/proposal_details_middle.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposal_details/interactor/viewmodels/bloc.dart';
import 'package:seeds/v2/screens/explore_screens/vote_screens/proposals/viewmodels/proposals_args_data.dart';
import 'package:flutter/material.dart';

class ProposalDetailsScreen extends StatefulWidget {
  const ProposalDetailsScreen({Key? key}) : super(key: key);

  @override
  _ProposalDetailsScreenState createState() => _ProposalDetailsScreenState();
}

class _ProposalDetailsScreenState extends State<ProposalDetailsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ProposalsArgsData? proposalsArgsData = ModalRoute.of(context)?.settings.arguments as ProposalsArgsData?;
    return Scaffold(
      body: BlocProvider(
        create: (_) => ProposalDetailsBloc(proposalsArgsData!)..add(const OnLoadProposalData()),
        child: BlocConsumer<ProposalDetailsBloc, ProposalDetailsState>(
          listenWhen: (_, current) => current.pageCommand != null,
          listener: (_, __) async {
            // Delay to avoid error when list is not drawed yet
            // because of (loading->success) transition
            await Future.delayed(const Duration(microseconds: 500));
            await _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
          },
          builder: (context, state) {
            switch (state.pageState) {
              case PageState.initial:
                return const SizedBox.shrink();
              case PageState.loading:
                return const FullPageLoadingIndicator();
              case PageState.failure:
                return const FullPageErrorIndicator();
              case PageState.success:
                return WillPopScope(
                  onWillPop: () async {
                    if (state.currentIndex != proposalsArgsData!.index) {
                      Navigator.of(context).pop(state.currentIndex);
                    }
                    return true;
                  },
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      const ProposalDetailsHeader(),
                      const SliverList(
                        delegate: SliverChildListDelegate.fixed([ProposalDetailsMiddle(), ProposalDetailsBottom()]),
                      ),
                    ],
                  ),
                );
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
