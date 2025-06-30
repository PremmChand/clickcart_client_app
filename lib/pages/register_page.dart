import 'package:clickcart_client/controller/login_controller.dart';
import 'package:clickcart_client/pages/login_page.dart';
import 'package:clickcart_client/pages/widgets/otp_txt_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (ctrl) {
      return Scaffold(
        body: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blueGrey[50],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Create Your Account !!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),),
              const SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.name,
                controller: ctrl.registerNameCtrl,
                decoration: InputDecoration(
                  labelText: 'Your Name',
                  hintText: 'Enter your name',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.phone,
                controller: ctrl.registerNumberCtrl,
                maxLength: 10,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  hintText: 'Enter your mobile number',
                  counterText: '', // hides the character counter under the TextField
                  prefixIcon: const Icon(Icons.phone_android),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              OtpTxtField(otpController: ctrl.otpController,
                  visible: ctrl.otpFieldShown,
                onComplete: (otp) {
                ctrl.otpEnter = int.tryParse(otp ?? '0000');
                },
              ),

              const SizedBox(height: 20),
              ElevatedButton(onPressed: () {
                if(ctrl.otpFieldShown){
                  ctrl.addUsers();
                }else{
                  ctrl.sendOtp();
                }
              },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: Text(ctrl.otpFieldShown ? 'Register' : 'Send OTP')),

              const SizedBox(height: 20),
              TextButton(onPressed: () {
                Get.to(LoginPage());
              },
                  child: Text('Login'))
            ],
          ),
        ),
      );
    });
  }
}
