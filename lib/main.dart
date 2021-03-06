import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realestateapp/layout/layout_screen.dart';
import 'package:realestateapp/models/user_model.dart';
import 'package:realestateapp/modules/cubit/cubit.dart';
import 'package:realestateapp/modules/cubit/states.dart';
import 'package:realestateapp/modules/login/login_screen.dart';
import 'package:realestateapp/modules/onboarding_screen.dart';
import 'package:realestateapp/modules/setting/setting_screen.dart';
import 'package:realestateapp/modules/setting/userprofile.dart';
import 'package:realestateapp/modules/splash_screen.dart';
import 'package:realestateapp/modules/videoandphoneCall/videoCallScreen.dart';
import 'package:realestateapp/shared/components/constant.dart';
import 'package:realestateapp/shared/network/local/cache_helper.dart';
import 'package:realestateapp/shared/styles/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );

  await CacheHelper.init();

  bool? isDark = CacheHelper.getData(key: 'isDark');

  Widget widget;

  uid = CacheHelper.getData(key: 'uid');
  bool? onboarding = CacheHelper.getData(key: 'onBoarding');
  print(uid);

  // print(uid);

  if (onboarding != null) {
    if (uid != null) {
      widget = LayoutScreen();
    } else {
      widget = LoginScreen();
    }
  } else {
    widget = OnBoardingScreen();
  }

  runApp(MyApp(
    startWidget: widget,
    isDark: isDark,
  ));
}

class MyApp extends StatelessWidget {
  bool? isDark;
  String? uid;
  Widget? startWidget;
  MyApp({this.startWidget, this.uid, this.isDark});

  // This widget is the root of your application.
  @override
  Widget build(
    BuildContext context,
  ) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()
        ..getUserData()
        ..getPosts()
        ..changeAppMode(
          themeMode: isDark,
        )
        ..getCategoryData(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode:
                AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: AnimatedSplashScreen(
              splash: Icons.home_outlined,
              nextScreen: startWidget! ,
              centered: true,
              splashIconSize: 100,
              splashTransition: SplashTransition.fadeTransition,
            ),
          );
        },
      ),
    );
  }
}
