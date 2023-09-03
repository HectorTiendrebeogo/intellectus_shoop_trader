import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypt/crypt.dart';

class Boutique {
  String firstName;
  String lastName;
  String phone;
  String password;
  String boutiqueName;
  String ville;
  bool isVerified;
  bool isActive;
  String cnibFace1Path;
  String cnibFace2Path;
  String identityPhotoPath;

  Boutique(
      this.firstName,
      this.lastName,
      this.phone,
      this.password,
      this.boutiqueName,
      this.ville,
      this.isVerified,
      this.isActive,
      this.cnibFace1Path,
      this.cnibFace2Path,
      this.identityPhotoPath
      );
  factory Boutique.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Boutique(
        data['firstName'],
        data['lastName'],
        data['phone'],
        data['password'],
        data['boutiqueName'],
        data['ville'],
        data['isVerified'],
        data['isActive'],
        data['cnibFace1Path'],
        data['cnibFace2Path'],
        data['identityPhotoPath']
    );
  }

  static bool isValid(String cryptFormatHash, String enteredPassword) => Crypt(cryptFormatHash).match(enteredPassword);

  static final db = FirebaseFirestore.instance;
  static void createBoutique(Boutique boutique) {
    final newBoutique = <String, dynamic>{
      'firstName' : boutique.firstName,
      'lastName' : boutique.lastName,
      'phone' : boutique.phone,
      'password' : boutique.password,
      'boutiqueName' : boutique.boutiqueName,
      'localization' : boutique.ville,
      'isVerified' : boutique.isVerified,
      'isActive' : boutique.isActive,
      'cnibFace1Path' : boutique.cnibFace1Path,
      'cnibFace2Path' : boutique.cnibFace2Path,
      'identityPhotoPath' : boutique.identityPhotoPath,
    };
    // Add a new document with a generated ID
    db.collection("boutique").add(newBoutique)
        .timeout(const Duration(seconds: 60))
        .onError((error, stackTrace) => Future.error(error!))
        .whenComplete(() => (){

    });
    /*.then((DocumentReference doc) =>
          print('DocumentSnapshot added with ID: ${doc.id}'));*/
  }


}