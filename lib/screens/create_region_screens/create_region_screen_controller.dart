import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/screens/create_region_screens/add_region_background_image/add_region_background_image.dart';
import 'package:seeds/screens/create_region_screens/add_region_description/add_region_description.dart';
import 'package:seeds/screens/create_region_screens/choose_region_name/choose_region_name.dart';
import 'package:seeds/screens/create_region_screens/review_region_information/review_region_information.dart';
import 'package:seeds/screens/create_region_screens/select_region/select_region.dart';
import 'package:seeds/screens/create_region_screens/viewmodels/create_region_bloc.dart';

class CreateRegionScreenController extends StatelessWidget {
  const CreateRegionScreenController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateRegionBloc(),
      child: BlocConsumer<CreateRegionBloc, CreateRegionState>(
        listenWhen: (_, current) => current.pageCommand != null,
        listener: (context, state) {
          },
        buildWhen: (previous, current) => previous.createRegionsScreens != current.createRegionsScreens,
        builder: (_, state) {
          final CreateRegionScreen createRegionsScreens = state.createRegionsScreens;
          switch (createRegionsScreens) {
            case CreateRegionScreen.selectRegion:
              return const SelectRegion();
            case CreateRegionScreen.displayName:
              return const ChooseRegionName();
            case CreateRegionScreen.addDescription:
              return const AddRegionDescription();
            case CreateRegionScreen.selectBackgroundImage:
              return const AddRegionBackgroundImage();
            case CreateRegionScreen.reviewRegion:
              return const ReviewRegion();
          }
        },
      ),
    );
  }
}
