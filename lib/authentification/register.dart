import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:crypt/crypt.dart';
import 'dart:io';
import '../model/boutique.dart';
import 'login.dart';
import 'otp_register.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<FormState> _formKey2 = GlobalKey();
  final GlobalKey<FormState> _formKey3 = GlobalKey();
  final TextEditingController _boutiqueNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  bool _showPassword = false;
  int _currentStep = 0;

  final List<String> _villes = [
    'Ouagadougou',
    'Bobo-Dioulasso',
    'Koudougou'
  ];
  String _selectedValue ="";

  //late ImagePicker cnibFace1ImagePicker;
  File? cnibFace1ImageFile;

  //late ImagePicker cnibFace2ImagePicker;
  File? cnibFace2ImageFile;

  //late ImagePicker identityImagePicker;
  File? identityImageFile;

  /*late ImagePicker boutiqueImagePicker;
  File? boutiqueImageFile;
*/

  bool _boutiqueNameExist = false;
  Future<void> verifyBoutiqueName(String boutiqueName) async {
    setState(() {
      _boutiqueNameExist = false;
    });
    final db = FirebaseFirestore.instance;
    try{
      await db.collection("boutique").get().then((event) {
        for (var doc in event.docs) {
          if (doc.get('boutiqueName').toString().replaceAll(" ", "") == boutiqueName.replaceAll(" ", "")) {
            setState(() {
              _boutiqueNameExist = true;
            });
            print(_boutiqueNameExist);
          } else {
            setState(() {
              _boutiqueNameExist = false;
            });
          }
        }
      });
    } catch(error){
      if (kDebugMode) {
        print(error);
      }
    }
  }

  bool _boutiquePhoneExist = false;
  Future<void> verifyBoutiquePhone(String boutiquePhone) async {
    setState(() {
      _boutiquePhoneExist = false;
    });
    final db = FirebaseFirestore.instance;
    try{
      await db.collection("boutique").get().then((event) {
        for (var doc in event.docs) {
          if (doc.get('phone').toString().replaceAll(" ", "") == boutiquePhone.replaceAll(" ", "")) {
            setState(() {
              _boutiquePhoneExist = true;
            });
            print(_boutiquePhoneExist);
          } else {
            setState(() {
              _boutiquePhoneExist = false;
            });
          }
        }
      });
    } catch(error){
      print(error);
    }
  }


  Future<void> _showMyDialog(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:  const Text('Demande de permission'),
          content: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(right: 20,left: 20),
              child: Column(
                children: [
                  Text(message)
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Valider'),
              onPressed: () async {
                Navigator.of(context).pop();
                await openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }
  /*Future<void> pickCNIBFace1Image() async {
    XFile? pickedImage;
    PermissionStatus permissionStatus = await Permission.camera.status;
    switch (permissionStatus) {
      case PermissionStatus.granted:
        pickedImage = await cnibFace1ImagePicker.pickImage(source: ImageSource.gallery);
        if (pickedImage != null) {
          // Faites quelque chose avec l'image sélectionnée ici
          setState(() {
            cnibFace1ImageFile = File(pickedImage!.path);
          });
        }
        break;
      case PermissionStatus.denied:
        //await Permission.camera.shouldShowRequestRationale;
        _showMyDialog("L'application a besoin d'acceder à la gallery de l'appareil");
        //await Permission.photos.request();
        break;
      case PermissionStatus.restricted:
        print('restricted');
        break;
      case PermissionStatus.permanentlyDenied:
        print('Permanently denied');
        break;
      default:
    }
  }
  Future<void> pickCNIBFace2Image() async {
    try {
      XFile? pickedImage;
      PermissionStatus permissionStatus = await Permission.camera.status;
      switch (permissionStatus) {
        case PermissionStatus.granted:
          pickedImage = await cnibFace2ImagePicker.pickImage(source: ImageSource.gallery);
          if (pickedImage != null) {
            // Faites quelque chose avec l'image sélectionnée ici
            setState(() {
              cnibFace2ImageFile = File(pickedImage!.path);
            });
          }
          break;
        case PermissionStatus.denied:
          await Permission.camera.shouldShowRequestRationale;
          _showMyDialog("L'application a besoin d'acceder à la gallery de l'appareil");
          await Permission.photos.request();
          break;
        case PermissionStatus.restricted:
          print('restricted');
          break;
        case PermissionStatus.permanentlyDenied:
          print('Permanently denied');
          break;
        default:
      }
    }catch (e) {
      print("***********");
      print(e);
    }

  }
  Future<void> pickBoutiqueImage() async {
    try {
      XFile? pickedImage;
      PermissionStatus permissionStatus = await Permission.camera.status;
      switch (permissionStatus) {
        case PermissionStatus.granted:
          pickedImage = await boutiqueImagePicker.pickImage(source: ImageSource.gallery);
          if (pickedImage != null) {
            // Faites quelque chose avec l'image sélectionnée ici
            setState(() {
              boutiqueImageFile = File(pickedImage!.path);
            });
          }
          break;
        case PermissionStatus.denied:
          await Permission.camera.shouldShowRequestRationale;
          _showMyDialog("L'application a besoin d'acceder à la gallery de l'appareil");
          await Permission.photos.request();
          break;
        case PermissionStatus.restricted:
          print('restricted');
          break;
        case PermissionStatus.permanentlyDenied:
          print('Permanently denied');
          break;
        default:
      }
    }catch(e){
      print("***********");
      print(e);
    }
  }
  Future<void> pickIdentityImage() async {
    try {
      XFile? pickedImage;
      PermissionStatus permissionStatus = await Permission.camera.status;
      switch (permissionStatus) {
        case PermissionStatus.granted:
          pickedImage = await identityImagePicker.pickImage(source: ImageSource.gallery);
          if (pickedImage != null) {
            // Faites quelque chose avec l'image sélectionnée ici
            setState(() {
              identityImageFile = File(pickedImage!.path);
            });
          }
          break;
        case PermissionStatus.denied:
          await Permission.camera.shouldShowRequestRationale;
          _showMyDialog("L'application a besoin d'acceder à la gallery de l'appareil");
          await Permission.photos.request();
          break;
        case PermissionStatus.restricted:
          print('restricted');
          break;
        case PermissionStatus.permanentlyDenied:
          print('Permanently denied');
          break;
        default:
      }
    }catch(e){
      print("***********");
      print(e);
    }
  }
*/

  late ImagesPicker imagesPicker;
  Future getCnib1Image() async {
    List<Media>? res = await ImagesPicker.pick(
      count: 1,
      pickType: PickType.image,
    );
    if (kDebugMode) {
      print('**********************');
      print(res?.first.path);
    }
    setState(() {
      cnibFace1ImageFile = File(res!.first.path);
    });
  }
  Future getCnib2Image() async {
    List<Media>? res = await ImagesPicker.pick(
      count: 1,
      pickType: PickType.image,
    );
    if (kDebugMode) {
      print('**********************');
      print(res?.first.path);
    }
    setState(() {
      cnibFace2ImageFile = File(res!.first.path);
    });
  }
  Future getIdentityImage() async {
    List<Media>? res = await ImagesPicker.pick(
      count: 1,
      pickType: PickType.image,
    );
    if (kDebugMode) {
      print('**********************');
      print(res?.first.path);
    }
    setState(() {
      identityImageFile = File(res!.first.path);
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

  int? _token;
  //String _verificationId = "";
  Future<void> _sendOtpCode() async {
    try{
      PermissionStatus permissionStatus = await Permission.sms.status;
      switch (permissionStatus) {
        case PermissionStatus.granted:
          FirebaseAuth auth = FirebaseAuth.instance;
          await auth.verifyPhoneNumber(
            phoneNumber: "+226${_phoneController.text}",
            timeout: const Duration(seconds: 60),
            verificationCompleted: (PhoneAuthCredential credential) async {
              // ANDROID ONLY!
              // Sign the user in (or link) with the auto-generated credential
              await auth.signInWithCredential(credential).then((value) => print("Authentification réussi"));
            },
            verificationFailed: (FirebaseAuthException error) {
              if (error.code == 'invalid-phone-number') {
                _callSnackBar(context, "The provided phone number is not valid.");
              }
              _callSnackBar(context, "La vérification RECAPTCHA a échoué");
              print("//////////////////////////");
              print(error);
              print("//////////////////////////");
              throw error;
            },
            codeSent: (String verificationId, int? forceResendingToken) {
              setState(() {
                _token = forceResendingToken;
                //_verificationId = verificationId;
              });
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return OtpRegisterScreen(
                  firstName: _firstNameController.text,
                  lastName: _lastNameController.text,
                  phone: _phoneController.text,
                  password: Crypt.sha256(_passwordController.text).toString(),
                  boutiqueName: _boutiqueNameController.text,
                  ville: _selectedValue,
                  files: [cnibFace1ImageFile!,cnibFace2ImageFile!,identityImageFile!],
                  verificationId: verificationId,
                  token:_token,
                  auth: auth,
                );
              }));
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              _callSnackBar(context, "Récupération automatique de l'sms à échoué");
            },
          );
          break;
        case PermissionStatus.denied:
          await Permission.camera.shouldShowRequestRationale;
          _showMyDialog("L'application a besoin d'accéder au sms du téléphone");
          await Permission.photos.request();
          break;
        case PermissionStatus.restricted:
          print('restricted');
          break;
        case PermissionStatus.permanentlyDenied:
          print('Permanently denied');
          break;
        default:
      }
    } catch (e){
      print(e);
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    imagesPicker = ImagesPicker();
    /*cnibFace1ImagePicker = ImagePicker();
    cnibFace2ImagePicker = ImagePicker();
    identityImagePicker = ImagePicker();
    boutiqueImagePicker = ImagePicker();*/
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColorLight,
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
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const Text(
                      "Formulaire d'inscription",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,letterSpacing: 2),
                    ),
                    const SizedBox(height: 20,),
                    Stepper(
                      physics: ScrollPhysics(),
                      steps:  [
                        Step(
                          title: const Text("Informations personnelles"),
                          isActive: _currentStep == 0,
                          content: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: _firstNameController,
                                  decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.perm_identity),
                                      labelText: "Saisissez votre nom"
                                  ),
                                  validator: (value){
                                    if (value == null || value.isEmpty) {
                                      return 'Champ obligatoire';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: _lastNameController,
                                  decoration: const InputDecoration(
                                    prefixIcon: Icon(Icons.perm_identity),
                                    labelText: "Saisissez votre prénom",
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Champ obligatoire';
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
                                    labelText: "Saisissez un mot de passe",
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Champ obligatoire';
                                    }
                                    if(_passwordController.text != value) {
                                      return 'Vérifier les mots de passe';
                                    }
                                    if (_passwordController.text.length < 5) {
                                      return 'La longueur minimum de 5';
                                    }
                                    if(_passwordController.text !=_password2Controller.text) {
                                      return 'Les mots de passe ne correspondent pas';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: _password2Controller,
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
                                    labelText: "Entrer un mot de passe",
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty ) {
                                      return 'Please enter some text';
                                    }
                                    if(_password2Controller.text != value) {
                                      return 'Vérifier les mots de passe';
                                    }
                                    if (_password2Controller.text.length < 5) {
                                      return 'La longueur minimum de 5';
                                    }
                                    if(_passwordController.text !=_password2Controller.text) {
                                      return 'Les mots de passe ne correspondent pas';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Step(
                          title: Text("Boutique"),
                          isActive: _currentStep == 1,
                          content: Form(
                            key: _formKey2,
                            child: Column(
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: _boutiqueNameController,
                                  decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.account_circle_outlined),
                                      labelText: "Saisissez le nom de la boutique",
                                      //suffixIcon: Icon(Icons.check_circle_outline,color: _boutiqueNameIsAlreadyExist == true ? Colors.red:Colors.green,)
                                  ),
                                  onChanged: (value) async {
                                    await verifyBoutiqueName(value);
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    if(_boutiqueNameExist) {
                                      return 'Le nom est déja pris';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20,),
                                DropdownButtonFormField2<String>(
                                  isExpanded: true,
                                  decoration: const InputDecoration(
                                    // Add Horizontal padding using menuItemStyleData.padding so it matches
                                    // the menu padding when button's width is not specified.
                                    prefixIcon: Icon(Icons.location_city_outlined),
                                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                                    /*border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),*/
                                    // Add more decoration..
                                  ),
                                  hint: const Text(
                                    'Ville',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  items: _villes
                                      .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                                      .toList(),
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Sélectionné une valeur';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    //Do something when selected item is changed.
                                    setState(() {
                                      _selectedValue = value!.toString();
                                      if (kDebugMode) {
                                        print("////////////////////");
                                        print(_selectedValue);
                                      }
                                    });
                                  },
                                  onSaved: (value) {
                                    setState(() {
                                      _selectedValue = value!.toString();
                                    });
                                    if (kDebugMode) {
                                      print("*******************//////////////");
                                      print(_selectedValue);
                                    }
                                  },
                                  buttonStyleData: const ButtonStyleData(
                                    padding: EdgeInsets.only(right: 8),
                                  ),
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black45,
                                    ),
                                    iconSize: 24,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    padding: EdgeInsets.symmetric(horizontal: 16),
                                  ),
                                ),
                                /*TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _positionController,
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.account_circle_outlined),
                                    suffixIcon: IconButton(onPressed: () async {
                                      _getUserLocation();
                                      setState(() {
                                        _positionController.text = _userLocation.toString();
                                      });
                                      if(_positionController.text == "null") {
                                        callSnackBar(context, "Impossible de récupérer votre position!");
                                      }
                                    }, icon: Icon(Icons.map_outlined)),
                                    labelText: "Entrer les coordonnées de votre boutique"
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Svp entrer les coordonnées de votre boutique';
                                  }
                                  return null;
                                },
                              ),*/
                              ],
                            ),
                          ),
                        ),
                        Step(
                          isActive: _currentStep == 2,
                          title: const Text("Importer les fichiers"),
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: /*_onCreating == true ? [
                            LinearProgressIndicator(
                              value: _rate,
                              minHeight: 10,
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                              backgroundColor: Colors.grey,
                            )
                          ]:*/
                            [
                              Container(
                                color: Colors.grey,
                                child: Stack(
                                  children: [
                                    Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        height: 200,
                                        child: cnibFace1ImageFile != null ? Image.file(cnibFace1ImageFile!,fit: BoxFit.fill,) : TextButton(onPressed: () async {
                                          await getCnib1Image();
                                        }, child: const Text("Photo de la face 1 de la CNIB"))
                                    ),
                                    Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          color: Colors.white,
                                          child: GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                cnibFace1ImageFile = null;
                                              });
                                            },
                                            child: const Icon(Icons.highlight_remove_outlined,color: Colors.red,),
                                          ),
                                        )
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                color: Colors.grey,
                                child: Stack(
                                  children: [
                                    Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        height: 200,
                                        child: cnibFace2ImageFile != null ? Image.file(cnibFace2ImageFile!,fit: BoxFit.fill,) : TextButton(onPressed: () async {
                                          await getCnib2Image();
                                        }, child: Text("Photo de la face 2 de la CNIB"))
                                    ),
                                    Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          color: Colors.white,
                                          child: GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                cnibFace2ImageFile = null;
                                              });
                                            },
                                            child: const Icon(Icons.highlight_remove_outlined,color: Colors.red,),
                                          ),
                                        )
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                color: Colors.grey,
                                child: Stack(
                                  children: [
                                    Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        height: 200,
                                        child: identityImageFile != null ? Image.file(identityImageFile!,fit: BoxFit.fill,) : TextButton(onPressed: () async {
                                          await getIdentityImage();
                                        }, child: Text("Photo d'identité"))
                                    ),
                                    Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          color: Colors.white,
                                          child: GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                identityImageFile = null;
                                              });
                                            },
                                            child: const Icon(Icons.highlight_remove_outlined,color: Colors.red,),
                                          ),
                                        )
                                    )
                                  ],
                                ),
                              ),
                              /*Container(
                                margin: EdgeInsets.only(top: 10),
                                color: Colors.grey,
                                child: Stack(
                                  children: [
                                    Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        height: 200,
                                        child: boutiqueImageFile != null ? Image.file(boutiqueImageFile!,fit: BoxFit.fill,) : TextButton(onPressed: () async {
                                          await pickBoutiqueImage();
                                        }, child: Text("Photo de la boutique"))
                                    ),
                                    Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          color: Colors.white,
                                          child: GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                boutiqueImageFile = null;
                                              });
                                            },
                                            child: Icon(Icons.highlight_remove_outlined,color: Colors.red,),
                                          ),
                                        )
                                    )
                                  ],
                                ),
                              ),*/
                            ],
                          ),
                        ),
                        Step(
                            title: const Text("Numéro de téléphone"),
                            isActive: _currentStep == 3,
                            content: Form(
                              key: _formKey3,
                              child: Column(
                                children: [
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _phoneController,
                                    maxLength: 8,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.perm_identity),
                                      labelText: "Saisissez votre numéro",
                                    ),
                                    onChanged: (value) async {
                                     if(value.length >= 7) {
                                       await verifyBoutiquePhone(value);
                                     }
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Champ obligatoire';
                                      }
                                      if (value.length < 8 ) {
                                        return 'Vérifier votre numéro';
                                      }
                                      if(_boutiquePhoneExist) {
                                        return 'Numéro déja attribué à un compte';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            )
                        )
                      ],
                      controlsBuilder: (BuildContext context, ControlsDetails details) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children:  <Widget>[
                            _currentStep != 0 ? TextButton(
                              style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.grey)),
                              onPressed: details.onStepCancel,
                              child: const Text('Retour'),
                            ): const SizedBox(),
                            TextButton(
                              style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.blueAccent)),
                              onPressed: details.onStepContinue,
                              child: const Text('Continuer'),
                            )
                          ],
                        );
                      },
                      currentStep: _currentStep,
                      onStepCancel: () {
                        if (_currentStep > 0) {
                          setState(() {
                            _currentStep -= 1;
                          });
                        }
                      },
                      onStepContinue: () async {
                        if (_currentStep == 0) {
                          if(_formKey.currentState!.validate()) {
                            setState(() {
                              _currentStep +=1;
                            });
                          }
                        } else if (_currentStep == 1){
                          if(_formKey2.currentState!.validate()) {
                            setState(() {
                              _currentStep +=1;
                            });
                          }
                        } else if (_currentStep == 2){
                          if(cnibFace1ImageFile == null || cnibFace2ImageFile == null || identityImageFile ==null){
                            _callSnackBar(context, "Importer les fichier demandés");
                          } else {
                            setState(() {
                              _currentStep +=1;
                            });
                          }
                        } else if (_currentStep == 3) {
                          if(_formKey3.currentState!.validate()) {
                           await _sendOtpCode();
                          }
                        }
                        /*if (_currentStep < 2) {
                        setState(() {
                          _currentStep += 1;
                        });
                      }*/
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("J'ai un compte ?"),
                        TextButton(onPressed: (){

                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                            return LoginScreen();
                          }));
                        }, child: Text("Se connecter"))
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        )
    );
  }
}
