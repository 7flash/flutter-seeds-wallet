import 'package:equatable/equatable.dart';
import 'package:seeds/v2/datasource/local/settings_storage.dart';
import 'package:seeds/v2/datasource/remote/model/profile_model.dart';
import 'package:seeds/v2/domain-shared/page_state.dart';
import 'package:seeds/v2/domain-shared/page_command.dart';
import 'package:seeds/v2/screens/profile_screens/contribution/interactor/viewmodels/scores_view_model.dart';

class ShowLogoutDialog extends PageCommand {}

/// --- STATE
class ProfileState extends Equatable {
  final PageState pageState;
  final String? errorMessage;
  final ProfileModel? profile;
  final ScoresViewModel? score;
  final PageCommand? showLogoutDialog;
  final bool showLogoutButton;
  final bool hasSecurityNotification;

  const ProfileState({
    required this.pageState,
    this.errorMessage,
    this.profile,
    this.score,
    this.showLogoutDialog,
    required this.showLogoutButton,
    required this.hasSecurityNotification,
  });

  @override
  List<Object?> get props => [
        pageState,
        errorMessage,
        profile,
        score,
        showLogoutDialog,
        showLogoutButton,
        hasSecurityNotification,
      ];

  bool get shoulShowCitizenshipShimmer {
    return pageState == PageState.loading || pageState == PageState.initial && !settingsStorage.isCitizen;
  }

  ProfileState copyWith({
    PageState? pageState,
    String? errorMessage,
    ProfileModel? profile,
    ScoresViewModel? score,
    PageCommand? showDialog,
    bool? showLogoutButton,
    bool? hasSecurityNotification,
  }) {
    return ProfileState(
      pageState: pageState ?? this.pageState,
      errorMessage: errorMessage,
      profile: profile ?? this.profile,
      score: score ?? this.score,
      showLogoutDialog: showDialog,
      showLogoutButton: showLogoutButton ?? this.showLogoutButton,
      hasSecurityNotification: hasSecurityNotification ?? this.hasSecurityNotification,
    );
  }

  factory ProfileState.initial() {
    return const ProfileState(pageState: PageState.initial, showLogoutButton: false, hasSecurityNotification: false);
  }
}
