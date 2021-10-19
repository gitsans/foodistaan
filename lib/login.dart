import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodistan/front.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
//import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId;
  bool showLoading = false;
  String currentText="";

  void signInWithPhoneAuthCredential(PhoneAuthCredential phoneAuthCredential) async{
    setState(() {
      showLoading=true;
    });
   try {
     final authCredential = await _auth.signInWithCredential(
         phoneAuthCredential);
     setState(() {
       showLoading=false;
     });
     if(authCredential?.user!=null){
       Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
     }
   } on FirebaseAuthException catch(e){
      setState(() {
        showLoading = false;
      });
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(e.message)));
   }
  }

  MobileVerificationState currentState = MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  getMobileFormWidget(context) {
    return ListView(
      children: [
        Container(
            height: 300,
            child:
                Image.asset('images/top.jpeg', height: 20, fit: BoxFit.fill)),
        SizedBox(
          height: 30,
        ),
        Container(
          child: Image.asset('images/pic4.png'),
        ),
        SizedBox(
          height: 40,
        ),

        Container(
          width: 200,
          height: 100,
          child: TextField(
            controller: phoneController,
            //keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              focusColor: Colors.yellow,
              hintText: 'Phone Number',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF7C12B), width: 3.0),
              ),
            ),
          ),
        ),
        Container(
          width: 319,
          height: 48,
          child: ElevatedButton(
            onPressed: () async {
              setState(() {
                showLoading=true;
              });
              await _auth.verifyPhoneNumber(
                phoneNumber: phoneController.text,
                verificationCompleted: (phoneAuthCredential) async {
                  setState(() {
                    showLoading=false;
                  });
                  //signInWithPhoneAuthCredential
                },
                verificationFailed: (verificationFailed) async {
                  setState(() {
                    showLoading=false;
                  });
                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(verificationFailed.message),));
                },
                codeSent: (verificationId, resendingToken) async {
                  setState(() {
                    showLoading=false;
                    currentState=MobileVerificationState.SHOW_OTP_FORM_STATE;
                    this.verificationId=verificationId;
                  });
                },
                codeAutoRetrievalTimeout: (verificationId) async {},
              );
            },
            child: Text(
              'Send OTP',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFFF7C12B),
              fixedSize: Size(100, 48),
            ),
          ),
        ),
        //   ],
        // ),

        Container(
            height: 300,
            child: Image.asset('images/bottom.jpeg',
                height: 20, fit: BoxFit.fill)),
      ],
    );
  }

  getOtpFormWidget(context) {
    return ListView(
      children: [
        Container(
            height: 300,
            child:
                Image.asset('images/top.jpeg', height: 20, fit: BoxFit.fill)),
        SizedBox(
          height: 30,
        ),
        Container(
          child: Image.asset('images/pic4.png'),
        ),
        SizedBox(
          height: 40,
        ),

        Container(
          width: 200,
          height: 100,
          child: TextField(
            controller: otpController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              focusColor: Colors.yellow,
              hintText: 'Enter OTP',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF7C12B), width: 3.0),
              ),
            ),
          ),
        ),

        // Container(
        //   child: OTPTextField(
        //     length: 6,
        //     width: MediaQuery.of(context).size.width,
        //     fieldWidth: 40,
        //     style: TextStyle(
        //         fontSize: 17
        //     ),
        //     textFieldAlignment: MainAxisAlignment.spaceAround,
        //     fieldStyle: FieldStyle.underline,
        //     onCompleted: (pin) {
        //       print("Completed: " + pin);
        //     },
        //   ),
        // ),
        Container(
          width: 319,
          height: 48,
          child: ElevatedButton(
            onPressed: () async{
              PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otpController.text);
              signInWithPhoneAuthCredential(phoneAuthCredential);
            },
            child: Text(
              'Verify OTP',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFFF7C12B),
              fixedSize: Size(100, 48),
            ),
          ),
        ),
        //   ],
        // ),

        Container(
            height: 300,
            child: Image.asset('images/bottom.jpeg',
                height: 20, fit: BoxFit.fill)),
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child:showLoading?Center(child: CircularProgressIndicator(),): currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
            ? getMobileFormWidget(context)
            : getOtpFormWidget(context),
      ),
    );
  }
}



// class Login extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     double height, width;
//     height = MediaQuery.of(context).size.height;
//     width = MediaQuery.of(context).size.width;
//     return
//   }
// }
