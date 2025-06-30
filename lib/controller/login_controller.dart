
import 'dart:math';

import 'package:clickcart_client/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';

import '../model/user/user.dart';

class LoginController extends GetxController{

  GetStorage box = GetStorage();

FirebaseFirestore firestore = FirebaseFirestore.instance;
late CollectionReference userCollection;

TextEditingController registerNameCtrl = TextEditingController();
TextEditingController registerNumberCtrl = TextEditingController();
TextEditingController loginNumberCtrl = TextEditingController();

OtpFieldControllerV2 otpController = OtpFieldControllerV2();
bool otpFieldShown = false;
int? otpSend;
int? otpEnter;

 User? loginUser;


@override
void onReady(){
  Map<String,dynamic>?user = box.read('logiUser');
  if(user != null){
    loginUser = User.fromJson(user);
    Get.to(const HomePage());
  }
  super.onReady();

}

@override
  void onInit() {
        userCollection = firestore.collection('users');
        super.onInit();
  }

addUsers() {
  final name = registerNameCtrl.text.trim();
  final numberText = registerNumberCtrl.text.trim();

  // Validation
  if (name.isEmpty) {
    Get.snackbar('Validation Error', 'Name cannot be empty', colorText: Colors.red);
    return;
  }

  if (numberText.isEmpty) {
    Get.snackbar('Validation Error', 'Phone number cannot be empty', colorText: Colors.red);
    return;
  }

  if (!RegExp(r'^\d{10}$').hasMatch(numberText)) {
    Get.snackbar('Validation Error', 'Enter a valid 10-digit phone number', colorText: Colors.red);
    return;
  }

  try {
    if(otpSend == otpEnter){
      DocumentReference doc = userCollection.doc();

      User user = User(
        id: doc.id,
        name: name,
        number: int.parse(numberText),
      );

      final userJson = user.toJson();
      doc.set(userJson);

      registerNameCtrl.clear();
      registerNumberCtrl.clear();
      otpController.clear();
      Get.snackbar('Success', 'User added successfully', colorText: Colors.green);
    }else{
      Get.snackbar('Error', 'OTP is incorrect', colorText: Colors.red);
    }
  } catch (e) {
    Get.snackbar('Error', e.toString(), colorText: Colors.red);
    print(e);
  }
}



sendOtp(){
  try {
    if(registerNumberCtrl.text.isEmpty || registerNumberCtrl.text.isEmpty){
      Get.snackbar('Error', 'Please fill the fields', colorText: Colors.red);
      return;
    }

    final random = Random();
    int otp =  1000 + random.nextInt(9000);
    print('opt generated: $otp');

    if(otp != null){
        otpFieldShown =true;
        otpSend = otp;
        //otpController.clear();
        Get.snackbar('Success', 'OTP  send successfully !!', colorText:Colors.green);
      }else{
        Get.snackbar('Error', 'Otp not send !!', colorText:Colors.red);
      }
  } catch (e) {
    print(e);
  }finally{
    update();
  }
}


Future<void> logiWithPhone()async {
try{
String phoneNumber = loginNumberCtrl.text;
if(phoneNumber.isNotEmpty){
  var querySnapShot = await userCollection.where('number', isEqualTo: int.tryParse(phoneNumber)).limit(1).get();
  if(querySnapShot.docs.isNotEmpty){
    var userDoc = querySnapShot.docs.first;
    var userData = userDoc.data() as Map<String,dynamic>;
    box.write('logiUser', userData);
    loginNumberCtrl.clear();
    Get.to(HomePage());
    Get.snackbar('Success', 'Login Successful',colorText: Colors.green);
  }else{
    Get.snackbar('Error', 'User not found, please register',colorText: Colors.red);
  }
}else{
  Get.snackbar('Error', 'Please enter a phone  number',colorText: Colors.red);
}
}catch(error){
  print('Failde to login : $error');
  Get.snackbar('Error', 'Failed to login',colorText: Colors.red);
}
}
}