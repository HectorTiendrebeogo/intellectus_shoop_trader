import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intellectus_shoop_trader/authentification/register.dart';

import '../model/boutique.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;


  bool _boutiqueExist = false;
  Future<void> authentification(String boutiqueName,String password) async {
    setState(() {
      _boutiqueExist = false;
      isLoginStart = true;
    });
    final db = FirebaseFirestore.instance;
    try{
      await db.collection("boutique").get().then((event) {
        for (var doc in event.docs) {
          if (doc.get('boutiqueName').toString().replaceAll(" ", "") == boutiqueName.replaceAll(" ", "") && Boutique.isValid(doc.get('password'), password) ) {
            setState(() {
              _boutiqueExist = true;
            });
          } else {
            setState(() {
              _boutiqueExist = false;
            });
          }
        }
      });
    } catch(error){
      setState(() {
        isLoginStart = false;
      });
    }
    setState(() {
      isLoginStart = false;
    });
  }

  void _callSnackBar(BuildContext context,String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        content: Text(message),
      ),
    );
  }
  bool isLoginStart = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(30),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Formulaire de connexion',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,letterSpacing: 2),
                    ),
                    const SizedBox(height: 30),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            //SizedBox(height: 150,),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: _loginController,
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.account_circle_outlined),
                                  labelText: "Entrer votre login"
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Entrer votre login svp';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: _passwordController,
                              obscureText: _showPassword == false? true : false,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.password_outlined),
                                suffixIcon: IconButton(
                                    onPressed: (){
                                      setState(() {
                                        _showPassword = !_showPassword;
                                      });
                                    }, icon: Icon(_showPassword == false? Icons.visibility_off_outlined :Icons.visibility_outlined)
                                ),
                                labelText: "Entrer votre mot de passe",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Entrer un mot de passe svp';
                                }
                                if(value.length < 6){
                                  return 'La longueur doit être supérieure à 6';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20,),
                            isLoginStart == true ? const SizedBox(width:30,height:30,child: CircularProgressIndicator()) :SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black),foregroundColor: MaterialStateProperty.all(Colors.white)),
                                  onPressed: ()  {
                                    if (_formKey.currentState!.validate()) {
                                      //loginFunction(context,_loginController.text,_passwordController.text);
                                      authentification(_loginController.text,_passwordController.text);
                                    }
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Se connecter",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,letterSpacing: 2),),
                                  )
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Pas de compte ?"),
                                TextButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return const RegisterScreen();
                                  }));
                                }, child: const Text("S'inscire"))
                              ],
                            ),
                            /*Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Se connecter plutôt avec"),
                          TextButton(onPressed: (){
                          }, child: Text("Google"))
                        ],
                      ),*/
                            //inLoginProcess? Center(child: CircularProgressIndicator()):
                          ],
                        )
                    ),
                  ],
                )
            ),
            Positioned(
              bottom: 10,
                right: 0,
                left: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Mot de passe oublié?"),
                    TextButton(onPressed: (){
                      /*Navigator.push(context, MaterialPageRoute(builder: (context){
                                return const RecoveryScreen();
                              }));*/
                    }, child: const Text("Récupérer"))
                  ],
                ),
            )
          ],
        )
      ),
    );
  }
}
