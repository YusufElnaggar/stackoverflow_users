import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackoverflow_users/core/data/local/shared_prefs_storage_service.dart';

final sharedPrefsServiceProvider = Provider<SharedPrefsService>(
  (ref) {
    final sharedPrefsService = SharedPrefsService();
    sharedPrefsService.init();
    return sharedPrefsService;
  },
);
