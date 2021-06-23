import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/i18n/profile.i18n.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seeds/v2/screens/profile_screens/profile/components/edit_profile_pic_bottom_sheet/interactor/viewmodels/bloc.dart';

class EditProfilePicBottomSheet extends StatelessWidget {
  const EditProfilePicBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PickImageBloc(),
      child: BlocConsumer<PickImageBloc, PickImageState>(
        listenWhen: (previous, current) => previous.file != current.file,
        listener: (context, state) => Navigator.of(context).pop(state.file),
        builder: (context, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.image),
                title: Text('Choose Picture'.i18n),
                onTap: () => BlocProvider.of<PickImageBloc>(context).add(const GetImage(source: ImageSource.gallery)),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text('Take a picture'.i18n),
                onTap: () => BlocProvider.of<PickImageBloc>(context).add(const GetImage(source: ImageSource.camera)),
              ),
            ],
          );
        },
      ),
    );
  }
}
