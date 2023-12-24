import 'dart:math';

import 'package:google_form_manager/core/helper/google_auth_helper.dart';
import 'package:share_plus/share_plus.dart';

import '../feature/auth/domain/entities/user_profile_entity.dart';

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

String getRandomId() {
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();

  return String.fromCharCodes(Iterable.generate(
      10, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}

String updateMaskBuilder(Set updateMask) {
  return updateMask.isNotEmpty
      ? updateMask.toString().replaceAll(RegExp(r'[ {}]'), '')
      : '';
}

Future<void> shareForm(String url) async {
  final result = await Share.shareWithResult('Please fill out the form \n$url');

  if (result.status == ShareResultStatus.success) {
    return;
  }
}
