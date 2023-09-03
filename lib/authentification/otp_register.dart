import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:intellectus_shoop_trader/authentification/login.dart';
import 'package:intellectus_shoop_trader/authentification/verification_message.dart';
import 'package:intellectus_shoop_trader/model/boutique.dart';

class OtpRegisterScreen extends StatefulWidget {
  const OtpRegisterScreen({super.key, required this.firstName, required this.lastName, required this.phone, required this.password, required this.boutiqueName, required this.ville, required this.files, required this.verificationId, this.token, required this.auth});

  final String firstName;
  final String lastName;
  final String phone;
  final String password;
  final String boutiqueName;
  final String ville;
  final List<File> files;
  final String verificationId;
  final int? token;
  final FirebaseAuth auth;

  @override
  State<OtpRegisterScreen> createState() => _OtpRegisterScreenState();
}

class _OtpRegisterScreenState extends State<OtpRegisterScreen> with TickerProviderStateMixin{
  late AnimationController _controller;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _otpController = TextEditingController();


  @override
  void dispose() {
    //_controller.dispose();
    super.dispose();
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

  bool _isVerify = false;
  bool _isVerifyStarting = false;
  Future<void> _verifyOTPCode(String codeOtp) async {
    setState(() {
      _isVerifyStarting = true;
    });
    //FirebaseAuth auth = FirebaseAuth.instance;
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: codeOtp
    );
    widget.auth
        .signInWithCredential(phoneAuthCredential)
        .catchError((error) {
            setState(() {
              _isVerify = false;
              _isVerifyStarting = false;
            });
          _callSnackBar(context, "La vérification à échoué");
          Navigator.pop(context);
          throw error;
        })
        .timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          setState(() {
            _isVerify = false;
            _isVerifyStarting = false;
          });
          _callSnackBar(context, "Délais d'attente dépassé,Réessayer svp");
          Navigator.pop(context);
          throw Future.error("Délais d'attente dépassé");
        })
        //.whenComplete(() => null)
        .then((value) => {
          setState(() {
          _isVerify = true;
          _isVerifyStarting = false;
          }),
      _uploadFile(widget.files)
        });
  }

  double _progress = 0.0;
  int _index = 0;
  final List<String> _downloadUrl = [];
  Future<void> _uploadFile(List<File> files) async {
    // Create a reference to the Firebase Storage bucket
    for (File file in files) {
      final storageRef = FirebaseStorage.instance.ref().child('fichiers/_${widget.firstName}_${widget.lastName}_${widget.boutiqueName}/image_${DateTime.now().millisecondsSinceEpoch}.jpg');
      // Upload file and metadata to the path 'images/mountains.jpg'
      final uploadTask = storageRef
          .putFile(file);
      // Listen for state changes, errors, and completion of the upload.
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            setState(() {
              _progress = taskSnapshot.bytesTransferred / taskSnapshot.totalBytes;
            });
            print("Upload is $_progress% complete.");
            break;
          case TaskState.paused:
            print("Upload is paused.");
            break;
          case TaskState.canceled:
            print("Upload was canceled");
            break;
          case TaskState.error:
          // Handle unsuccessful uploads
            break;
          case TaskState.success:
            setState(() {
              _index = _index+1;
              _progress = 0.0;
            });
            String url = await storageRef.getDownloadURL();
            // Handle successful uploads on complete
            _downloadUrl.add(url);
            if(_index == 3) {
              Boutique boutique = Boutique(
                  widget.firstName,
                  widget.lastName,
                  widget.phone,
                  widget.password,
                  widget.boutiqueName,
                  widget.ville,
                  false,
                  false,
                  _downloadUrl[0],
                  _downloadUrl[1],
                  _downloadUrl[2]
              );
              try {
                Boutique.createBoutique(boutique);
                if (mounted) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                    return const VerificationMessageScreen();
                  }));
                }
              } catch (e){
                if (mounted ) _callSnackBar(context, "Erreur lors de la création du compte");
              }
            }
            break;
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColorLight,
        leading: IconButton(onPressed: (){
          if (Navigator.canPop(context)){
            Navigator.pop(context);
          }
        }, icon: const Icon(Icons.arrow_back),
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
        ),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _isVerify == false ? Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //SizedBox(height: 150,),
                    const Text(
                      "Entrer le code OTP envoyé au +226 ",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,letterSpacing: 2),
                    ),
                    const SizedBox(height: 20,),
                    OtpTextField(
                      numberOfFields: 6,
                      showFieldAsBox: false,
                      borderWidth: 2.0,
                      focusedBorderColor: const Color.fromRGBO(0, 0, 0, 1),
                      //runs when a code is typed in
                      onCodeChanged: (String code) {
                        //handle validation or checks here if necessary
                        setState(() {
                          print(_otpController.text);
                        });
                      },
                      //runs when every textfield is filled
                      onSubmit: (String verificationCode) async {
                        setState(() {
                          _otpController.text = verificationCode;
                          _isVerify = true;
                        });
                       await _verifyOTPCode(_otpController.text);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(onPressed: (){
                        }, child: Text("Renvoyé le code"))
                      ],
                    )
                    //inLoginProcess? Center(child: CircularProgressIndicator()):
                  ],
                ),
              ): SizedBox(),
              const SizedBox(height: 20,),
              _isVerifyStarting == true ? const CircularProgressIndicator():const SizedBox(),
              const SizedBox(height: 20,),
              _isVerify == true ? const Text("Télechargement des fichiers en cours"):const SizedBox(),
              _isVerify == true ? SizedBox(
                child: SizedBox(
                  width: double.infinity,
                  child: LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Colors.grey,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
              ):const SizedBox(),
              _isVerify == true ? Text("$_index/3"):const SizedBox(),
              _isVerify == true ? SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black),foregroundColor: MaterialStateProperty.all(Colors.white)),
                          onPressed: () async {
                            _uploadFile(widget.files);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Télecharger",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,letterSpacing: 2),),
                          )
                      ),
                    ): const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
