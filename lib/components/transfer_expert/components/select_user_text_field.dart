import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:seeds/components/search_user/interactor/viewmodels/search_user_bloc.dart';
import 'package:seeds/components/transfer_expert/interactor/viewmodels/transfer_expert_bloc.dart';
import 'package:seeds/design/app_colors.dart';
import 'package:seeds/domain-shared/page_state.dart';
import 'package:seeds/screens/transfer/send/send_search_user/new_auth_screen.dart';
import 'package:seeds/utils/build_context_extension.dart';

class SelectUserTextField extends StatefulWidget {
  final String? initialValue;
  final Function(String s)? updater;
  final String accountKey;
  const SelectUserTextField({this.initialValue, this.updater = null, this.accountKey = "", super.key});
  

  @override
  SelectUserTextFieldState createState() => SelectUserTextFieldState();
}

class SelectUserTextFieldState extends State<SelectUserTextField> {
  final TextEditingController _controller = TextEditingController();
  final _searchBorder = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: AppColors.darkGreen2, width: 2.0),
  );
  TextStyle? inputTextStyle;

  void setText(String t) {
    _controller.text = t;
  }
  
  @override
  void initState(){;
    _controller.text = widget.initialValue ?? "";

    if (widget.accountKey != "" && widget.initialValue != null) {
      BlocProvider.of<TransferExpertBloc>(context)
        .add(OnSearchChange(searchQuery: widget.initialValue!.toLowerCase(), accountKey: widget.accountKey));
      }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.updater != null) {
      widget.updater!(_controller.text);
    }
    if (widget.accountKey != "") {
      return BlocBuilder<TransferExpertBloc,TransferExpertState>(
        builder: (context, state) { return TextField(
          autofocus: true,
          autocorrect: false,
          controller: _controller,
          style:  TextStyle(color: state.validChainAccounts.contains(widget.accountKey) ?
            Colors.green : Colors.white),
          onChanged: (value) {
            if (widget.updater != null) {
              widget.updater!(value);
            }
            BlocProvider.of<TransferExpertBloc>(context)
              .add(OnSearchChange(searchQuery: value.toLowerCase(), accountKey: widget.accountKey));
          },
          decoration: InputDecoration(
            enabledBorder: _searchBorder,
            focusedBorder: _searchBorder,
            border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
            hintText: context.loc.searchUserHintText,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.deny(" "),
          ],
        );
          }
      );
    } else {
      return TextField(
        autofocus: true,
        autocorrect: false,
        controller: _controller,
        style:  TextStyle(color: Colors.purpleAccent),
        onChanged: (value) {
          if (widget.updater != null) {
            widget.updater!(value);
          }
        },
        decoration: InputDecoration(
          enabledBorder: _searchBorder,
          focusedBorder: _searchBorder,
          border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          hintText: context.loc.searchUserHintText,
        ),
      );
    }

  }
}
