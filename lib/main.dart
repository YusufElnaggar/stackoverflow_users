import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:stackoverflow_users/core/utils/http_client.dart';

import 'core/utils/observers.dart';
import 'core/utils/theme.dart';
import 'features/users/presentation/pages/users_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  /// used to initiate the flutter hive
  await Hive.initFlutter();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.black,
  ));

  ///force the device orientation to be only portraitUp
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(
      /// a provider scope to contain the iverpod providers on top of the widget tree
      ProviderScope(
        observers: [
          Observers(),
        ],
        child: const StackOverFlowUsersApp(),
      ),
    ),
  );
}

class StackOverFlowUsersApp extends ConsumerWidget {
  const StackOverFlowUsersApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'StackOverFlow Users',
        theme: theme(),
        home: const UsersScreen(),
      );
    });
  }
}
