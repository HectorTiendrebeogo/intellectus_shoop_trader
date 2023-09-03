
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intellectus_shoop_trader/authentification/login.dart';
import 'package:intellectus_shoop_trader/wapper.dart';
/*
> Task :permission_handler_android:signingReport
Variant: debugAndroidTest
Config: debug
Store: /home/hector/.android/debug.keystore
Alias: AndroidDebugKey
MD5: FB:1F:4F:B6:49:08:E3:1D:50:42:D2:AE:7E:06:C7:61
SHA1: CB:70:8F:16:7E:1C:90:01:57:45:A8:9D:0A:93:4D:D3:BE:30:37:85
SHA-256: 6D:D4:30:F8:7F:46:74:50:9E:40:63:DD:E2:DA:5F:2F:F8:BA:CD:86:C8:C8:96:AA:65:4F:7B:A8:8A:59:7E:51
Valid until: mardi 1 juillet 2053
* */
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      const MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        primaryColor: Colors.black,
        primaryColorDark: Colors.black,
        primaryColorLight: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
              foregroundColor: MaterialStateProperty.all(Theme.of(context).primaryColorLight)
          )
        ),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white38),
        useMaterial3: true,
      ),
      home: const MyHomePage()
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<void> _showSplashScreen() async {
    await Future.delayed(
      const Duration(seconds: 7),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return LoginScreen();
      }));
    }); // Attendez 5 secondes
  }

  @override
  void initState() {
    // TODO: implement initState
    _showSplashScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 5),
        child: const SafeArea(
          child: Stack(
            children: [
              Center(
                child: Text(
                  'INTELLECTUS SHOOP',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold,letterSpacing: 2),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Center(
                      child: SizedBox(
                        width: 50,
                          height: 50,
                          child: CircularProgressIndicator()
                      ),
                    ),
                    Text("Chargement...")
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
