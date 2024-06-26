import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flights/core/enums/enums.dart';
import 'package:flights/core/utils/shred_prefs.dart';
import 'package:flights/features/auth/models/client.dart';
import 'package:flights/features/auth/models/company.dart';
import 'package:flights/features/auth/providers/auth_state_provider.dart';
import 'package:flights/features/client/screens/client_home_screen.dart';
import 'package:flights/features/flights/screens/company_flights_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDbServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var firebaseUser = auth.FirebaseAuth.instance.currentUser;

  creatUser({required Client client, required context}) async {
    try {
      await _db.collection('clients').doc(firebaseUser!.uid).set(client.toJson());

      await firebaseUser!.updateDisplayName('client');

      Provider.of<AuthSataProvider>(context, listen: false).changeAuthState(newState: AuthState.notSet);

      Navigator.of(context).pushNamedAndRemoveUntil(ClientHomeScreen.routeName, (route) => false);
    } on FirebaseException catch (e) {
      Provider.of<AuthSataProvider>(context, listen: false).changeAuthState(newState: AuthState.notSet);

      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<String> editClient({required Client client, required context}) async {
    try {
      await _db.collection('clients').doc(firebaseUser!.uid).update(client.toJson());

      return 'success';

      // Navigator.of(context).pushNamedAndRemoveUntil(ClientHomeScreen.routeName, (route) => false);
    } on FirebaseException catch (e) {
      const snackBar = SnackBar(content: Text('حدث خطأ, الرجاء المحاولة لاحقاً'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return 'error';
    }
  }

  createCompany({required Company company, required context}) async {
    try {
      await _db.collection('companies').doc(firebaseUser!.uid).set(company.toJson());

      await firebaseUser!.updateDisplayName('company');

      Navigator.of(context).pushNamedAndRemoveUntil(CompanyFlightScreen.routeName, (route) => false);
    } on FirebaseException catch (e) {
      const snackBar = SnackBar(content: Text('حدث خطأ, الرجاء المحاولة لاحقاً'));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<String> editCompany({required Company company, required context}) async {
    try {
      await _db.collection('companies').doc(firebaseUser!.uid).update(company.toJson());

      return 'success';
    } on FirebaseException catch (e) {
      const snackBar = SnackBar(content: Text('حدث خطأ, الرجاء المحاولة لاحقاً'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      return 'error';
    }
  }

  Future<void> getUserInfo() async {
    final String userType = firebaseUser!.displayName == 'company' ? 'companies' : 'clients';
    try {
      final fireBaseDoc = await _db.collection(userType).doc(firebaseUser!.uid).get();
      // UserModel.fromFirestore(fireBaseDoc);
      SharedPrefs.prefs.setString('name', fireBaseDoc['name']);
      SharedPrefs.prefs.setString('image', fireBaseDoc['imageUrl'] ?? '');
    } on FirebaseException catch (e) {
      print(e.message.toString());
    }
  }

  Future<Client?> getClientProfileInfo(String userId) async {
    const String userType = 'clients';
    try {
      final fireBaseDoc = await _db.collection(userType).doc(userId).get();
      // UserModel.fromFirestore(fireBaseDoc);
      SharedPrefs.prefs.setString('name', fireBaseDoc['name']);
      SharedPrefs.prefs.setString('image', fireBaseDoc['imageUrl'] ?? '');

      return Client.fromFirestore(fireBaseDoc);
    } on FirebaseException catch (e) {
      print(e.message.toString());
      return null;
    }
  }

  Future<Company?> getCompanyProfileInfo(String userId) async {
    const String userType = 'companies';
    try {
      final fireBaseDoc = await _db.collection(userType).doc(userId).get();
      // UserModel.fromFirestore(fireBaseDoc);
      SharedPrefs.prefs.setString('name', fireBaseDoc['name']);
      SharedPrefs.prefs.setString('image', fireBaseDoc['imageUrl'] ?? '');

      return Company.fromFirestore(fireBaseDoc);
    } on FirebaseException catch (e) {
      print(e.message.toString());
      return null;
    }
  }
  // Future<UserModle?> getUser(String id) async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  //   try {
  //     var user = await _db.collection('users').doc(id).get();
  //     String userType = user.data()!['user_type'];
  //     // SharedPref.set('type', userType);

  //     if (userType == UserType.benefactor.name) {
  //       sharedPreferences.setString('type', UserType.benefactor.name);

  //       return Benefactor.fromFirestore(user);
  //     }

  //     if (userType == UserType.patient.name) {
  //       final patient = Patient.fromFirestore(user);
  //       SharedPref.set('diseaseName', patient.disease!.name);
  //       sharedPreferences.setString('diseaseName', patient.disease!.name);
  //       sharedPreferences.setString('type', UserType.patient.name);

  //       return Patient.fromFirestore(user);
  //     }

  //     if (userType == UserType.charityOrg.name) {
  //       sharedPreferences.setString('type', UserType.charityOrg.name);

  //       return Charity.fromFirestore(user);
  //     }
  //   } on FirebaseException catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }

  //update user
  // Future<void> updateUser(UserModle user, context) async {
  //   try {
  //     await _db.collection('users').doc(firebaseUser!.uid).update(getUserType(user).toJson());
  //     await StreamChatService().updateUser(user, context);
  //     Provider.of<UserProvider>(context, listen: false).getUserData();
  //     showSuccessSnackBar(context, 'تم التعديل بنجاح');
  //     Navigator.of(context).pop(true);
  //   } on FirebaseException {
  //     showErrorSnackBar(context, 'حدث خطأ');
  //   }
  // }
}
