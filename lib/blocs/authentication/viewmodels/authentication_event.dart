import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:seeds/datasource/local/models/auth_data_model.dart';

/// --- EVENTS
@immutable
abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
  @override
  List<Object> get props => [];
}

class InitAuthStatus extends AuthenticationEvent {
  const InitAuthStatus();
  @override
  String toString() => 'InitAuthStatus';
}

class InitOnResumeAuth extends AuthenticationEvent {
  const InitOnResumeAuth();
  @override
  String toString() => 'InitOnResumeAuth';
}

class SuccessOnResumeAuth extends AuthenticationEvent {
  const SuccessOnResumeAuth();
  @override
  String toString() => 'SuccessOnResumeAuth';
}

class OnInviteLinkRecived extends AuthenticationEvent {
  const OnInviteLinkRecived();
  @override
  String toString() => 'OnInviteLinkRecived';
}

class OnCreateAccount extends AuthenticationEvent {
  final String account;
  final AuthDataModel authData;
  const OnCreateAccount({required this.account, required this.authData});
  @override
  String toString() => 'OnCreateAccount { account: $account }';
}

class OnImportAccount extends AuthenticationEvent {
  final String account;
  final AuthDataModel authData;
  const OnImportAccount({required this.account, required this.authData});
  @override
  String toString() => 'OnImportAccount { account: $account }';
}

class OnRecoverAccount extends AuthenticationEvent {
  const OnRecoverAccount();
  @override
  String toString() => 'OnRecoverAccount';
}

class OnSwitchAccount extends AuthenticationEvent {
  final String account;

  const OnSwitchAccount(this.account);
  @override
  String toString() => 'OnSwitchAccount { account: $account }';
}

class UnlockWallet extends AuthenticationEvent {
  const UnlockWallet();
  @override
  String toString() => 'UnlockWallet';
}

class EnablePasscode extends AuthenticationEvent {
  final String newPasscode;
  const EnablePasscode({required this.newPasscode});
  @override
  String toString() => 'EnablePasscode';
}

class DisablePasscode extends AuthenticationEvent {
  const DisablePasscode();
  @override
  String toString() => 'DisablePasscode';
}

class EnableBiometric extends AuthenticationEvent {
  const EnableBiometric();
  @override
  String toString() => 'EnableBiometric';
}

class DisableBiometric extends AuthenticationEvent {
  const DisableBiometric();
  @override
  String toString() => 'DisableBiometric';
}

class OnLogout extends AuthenticationEvent {
  const OnLogout();
  @override
  String toString() => 'OnLogout';
}
