import 'package:google_form_manager/auth/domain/entities/user_profile_entity.dart';
import 'package:google_form_manager/core/helper/google_auth_helper.dart';

UserProfile userProfile() {
  if (googleSigning.currentUser != null) {
    final user = googleSigning.currentUser!;
    return UserProfile(
      id: user.id,
      displayName: user.displayName ?? '',
      photoUrl: user.photoUrl ?? '',
      email: user.email,
    );
  } else {
    return UserProfile();
  }
}
