import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/firebase/firestore_service.dart';
import 'package:flower_app/config/secure_storage/secure_storage_service.dart';
import 'package:flower_app/core/values/app_routes_name.dart';
import 'package:flower_app/core/values/app_strings.dart';
import 'package:flower_app/features/profile/presentation/widgets/row_section.dart';
import 'package:flutter/material.dart';

class NotificationToggle extends StatefulWidget {
  const NotificationToggle({super.key});

  @override
  State<NotificationToggle> createState() => _NotificationToggleState();
}

class _NotificationToggleState extends State<NotificationToggle> {
  final SecureStorageService _storage = getIt<SecureStorageService>();
  final FirestoreService _firestoreService = getIt<FirestoreService>();
  bool _enabled = true;

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  Future<void> _loadState() async {
    final enabled = await _storage.readNotificationsEnabled();
    if (!mounted) return;
    setState(() => _enabled = enabled);
  }

  Future<void> _onToggle(bool value) async {
    final language = context.locale.languageCode == 'ar' ? 'ar' : 'en';
    setState(() => _enabled = value);
    await _storage.writeNotificationsEnabled(value);
    if (value) {
      final userId = await _storage.readUserId();
      final token = await FirebaseMessaging.instance.getToken();
      if (userId != null &&
          userId.isNotEmpty &&
          token != null &&
          token.isNotEmpty) {
        await _firestoreService.saveUserFcmData(
          userId: userId,
          fcmToken: token,
          language: language,
        );
      }
    } else {
      await FirebaseMessaging.instance.deleteToken();
    }
  }

  @override
  Widget build(BuildContext context) {
    context.locale;
    return RowSection.toggle(
      title: AppStrings.notification,
      value: _enabled,
      onToggle: _onToggle,
      onTap: () => Navigator.pushNamed(context, AppRoutesName.notifications),
    );
  }
}
