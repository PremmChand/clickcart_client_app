import 'package:clickcart_client/controller/login_controller.dart';
import 'package:clickcart_client/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../model/user/user.dart';

class PurchaseController extends GetxController {
  late Razorpay _razorpay;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderCollection;

  TextEditingController addressController = TextEditingController();

  double orderPrice = 0;
  String itemName = '';
  String orderAddress = '';

  @override
  void onInit() {
    orderCollection = firestore.collection('orders');
    super.onInit();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet); // Optional
  }

  @override
  void onClose() {
    _razorpay.clear(); // Avoid memory leaks
    super.onClose();
  }

  void submitOrder({
    required double price,
    required String item,
    required String description,
  }) {
    orderPrice = price;
    itemName = item;
    orderAddress = addressController.text;

    var options = {
      'key': 'your key from razorpay',
      'amount': (price * 100).toInt(), // Razorpay expects int in paisa
      'name': item,
      'description': description.length > 255
    ? '${description.substring(0, 252)}...'
        : description,
      'prefill': {
        'contact': '', // Optional
        'email': ''    // Optional
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      Get.snackbar('Error', 'Failed to open payment: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    orderSuccess(transactionId:response.paymentId);
    Get.snackbar('Payment Success', 'Payment ID: ${response.paymentId}', colorText: Get.theme.colorScheme.primary);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar('Payment Failed', response.message ?? 'Unknown error', colorText: Get.theme.colorScheme.error);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar('External Wallet', response.walletName ?? '', colorText: Get.theme.colorScheme.secondary);
  }

  Future<void> orderSuccess({required String? transactionId}) async {
    User ? loginUse = Get.find<LoginController>().loginUser;
    try{
      if(transactionId != null){
        DocumentReference docRef = await orderCollection.add({
          'customer': loginUse?.name ?? '',
          'phone': loginUse?.number ?? '',
          'item': itemName,
          'price': orderPrice,
          'address': orderAddress,
          'transactionId': transactionId,
          'dateTime': DateTime.now().toString(),
        });
       // print('Order Created Successfully: ${docRef.id}');
        showOrderSuccessDialog(docRef.id);
        Get.snackbar('Payment Success', 'Order Created Successfully', colorText: Get.theme.colorScheme.primary);
      }else{
        Get.snackbar('Error', 'Please fill all fields', colorText: Get.theme.colorScheme.error);
      }
    }catch(error){
     // print('Failed to register user: $error');
      Get.snackbar('Error', 'Please fill all fields', colorText: Get.theme.colorScheme.error);
    }
  }

  void  showOrderSuccessDialog(String orderId){
    Get.defaultDialog(
      title: "Order Success",
      content: Text("Your OrderId is $orderId"),
      confirm: ElevatedButton(onPressed: () {
        Get.off(const HomePage());
      },
          child: const Text("Close"))
    );
  }

}
