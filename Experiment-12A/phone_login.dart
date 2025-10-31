import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';

class PhoneLoginPage extends StatefulWidget {
  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  String verificationId = "";

  Future<void> verifyPhone() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneController.text.trim(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
      },
      codeSent: (String verId, int? resendToken) {
        setState(() {
          verificationId = verId;
        });
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
    );
  }

  Future<void> verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: _otpController.text.trim(),
    );
    await _auth.signInWithCredential(credential);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Phone Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _phoneController, decoration: const InputDecoration(labelText: "Phone (+91xxxxxxxxxx)")),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: verifyPhone, child: const Text("Send OTP")),
            TextField(controller: _otpController, decoration: const InputDecoration(labelText: "Enter OTP")),
            ElevatedButton(onPressed: verifyOTP, child: const Text("Verify & Login")),
          ],
        ),
      ),
    );
  }
}
