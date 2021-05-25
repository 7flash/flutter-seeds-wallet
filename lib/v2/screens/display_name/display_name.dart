import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seeds/i18n/edit_name.i18n.dart';
import 'package:seeds/v2/components/flat_button_long.dart';
import 'package:seeds/v2/components/text_form_field_custom.dart';
import 'package:seeds/v2/design/app_theme.dart';
import 'package:seeds/v2/screens/sign_up/viewmodels/bloc.dart';

class DisplayName extends StatefulWidget {
  @override
  _DisplayNameState createState() => _DisplayNameState();
}

class _DisplayNameState extends State<DisplayName> {
  late SignupBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<SignupBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormFieldCustom(
              labelText: 'Full Name'.i18n,
              onFieldSubmitted: (_) => _onSubmitted(),
              maxLength: 36,
              validator: (String? value) {
                if (value?.isEmpty == true) {
                  return 'Name cannot be empty'.i18n;
                }
                return null;
              },
            ),
            Expanded(
                child: Text(
              "Enter your full name. You will be able to change this later in your profile settings.".i18n,
              style: Theme.of(context).textTheme.subtitle2OpacityEmphasis,
            )),
            FlatButtonLong(
              onPressed: () {},
              title: 'Next'.i18n,
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmitted() {}
}
