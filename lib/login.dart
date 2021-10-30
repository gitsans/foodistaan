import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodistan/front.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final formKey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;

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
        Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
          child: RichText(
            text: TextSpan(
                text: "Sent OTP to ",
                children: [
                  TextSpan(
                      text: phoneController.text,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                ],
                style: TextStyle(color: Colors.black54, fontSize: 15)),
            textAlign: TextAlign.center,
          ),
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



        // Form(
        //   key: formKey,
        //   child: Padding(
        //       padding: const EdgeInsets.symmetric(
        //           vertical: 8.0, horizontal: 30),
        //       child: PinCodeTextField(
        //         appContext: context,
        //         pastedTextStyle: TextStyle(
        //           color: Colors.green.shade600,
        //           fontWeight: FontWeight.bold,
        //         ),
        //         length: 6,
        //         obscureText: true,
        //         obscuringCharacter: '*',
        //         obscuringWidget: FlutterLogo(
        //           size: 24,
        //         ),
        //         blinkWhenObscuring: true,
        //         animationType: AnimationType.fade,
        //         validator: (v) {
        //           if (v.length < 3) {
        //             return "I'm from validator";
        //           } else {
        //             return null;
        //           }
        //         },
        //         pinTheme: PinTheme(
        //           shape: PinCodeFieldShape.box,
        //           borderRadius: BorderRadius.circular(5),
        //           fieldHeight: 50,
        //           fieldWidth: 40,
        //           activeFillColor: Colors.white,
        //         ),
        //         cursorColor: Colors.black,
        //         animationDuration: Duration(milliseconds: 300),
        //         enableActiveFill: true,
        //         errorAnimationController: errorController,
        //         controller: textEditingController,
        //         keyboardType: TextInputType.number,
        //         boxShadows: [
        //           BoxShadow(
        //             offset: Offset(0, 1),
        //             color: Colors.black12,
        //             blurRadius: 10,
        //           )
        //         ],
        //         onCompleted: (v) {
        //           print("Completed");
        //         },
        //         // onTap: () {
        //         //   print("Pressed");
        //         // },
        //         onChanged: (value) {
        //           print(value);
        //           setState(() {
        //             currentText = value;
        //           });
        //         },
        //         beforeTextPaste: (text) {
        //           print("Allowing to paste $text");
        //           //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
        //           //but you can show anything you want here, like your pop up saying wrong paste format or etc
        //           return true;
        //         },
        //       )),
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
