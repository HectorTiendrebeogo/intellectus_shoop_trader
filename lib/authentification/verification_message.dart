import 'package:flutter/material.dart';

import 'login.dart';

class VerificationMessageScreen extends StatefulWidget {
  const VerificationMessageScreen({super.key});

  @override
  State<VerificationMessageScreen> createState() => _VerificationMessageScreenState();
}

class _VerificationMessageScreenState extends State<VerificationMessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: Container(
        margin: const EdgeInsets.only(top: 10,left: 10,right: 10,bottom: 5),
        child: SafeArea(
          child: Stack(
            children: [
              const Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline,color: Colors.green,size: 150,),
                  Text(
                    "Compte créer avec succès \n Attendez l'activation de votre compte pour profiter de nos services",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,letterSpacing: 2),
                  ),
                ],
              )),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black),foregroundColor: MaterialStateProperty.all(Colors.white)),
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                              return const LoginScreen();
                          }));
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Se connecter",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,letterSpacing: 2),),
                        )
                    ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
