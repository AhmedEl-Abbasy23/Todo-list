import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:todo_list/presentation/screens/home_screen.dart';

import 'business_logic/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  late bool connectionStatus;
  ConnectivityResult connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
   print('connectivityResult: $connectivityResult');
   connectionStatus = true;
  }else{
    connectionStatus = false;
  }
  runApp(MainApp(connectionStatus: connectionStatus));
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key, required this.connectionStatus}) : super(key: key);

  final bool connectionStatus;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(brightness: Brightness.dark,primaryColor: Colors.purple),
      home: HomeScreen(connectionStatus: connectionStatus),
      builder: (context, widget) => ResponsiveWrapper.builder(
        widget,
        maxWidth: 2460,
        minWidth: 450,
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.resize(450, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(800, name: TABLET),
          const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
          const ResponsiveBreakpoint.autoScale(2460, name: '4K'),
        ],
      ),
    );
  }
}
