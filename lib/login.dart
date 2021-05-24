
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seven_bits_task/profile.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
     _loadPrefrences();
  
    super.initState();
  }

  // late Timer _timer;
  // int _start = 60;

  // void startTimer() {
  //   const oneSec = const Duration(seconds: 1);
  //   _timer = new Timer.periodic(
  //     oneSec,
  //     (Timer timer) {
  //       if (_start == 0) {
  //         setState(() {
  //           timer.cancel();
  //         });
  //       } else {
  //         setState(() {
  //           _start--;
  //         });
  //       }
  //     },
  //   );
  // }

  _loadPrefrences() async {
       User? user = FirebaseAuth.instance.currentUser;
  if(user != null){
          Navigator.of(context).pop();

       Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => ProfileScreen()));

  }

    
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    // String? name = preferences.getString("name");
    // String? email = preferences.getString("email");

    // String? number = preferences.getString("number");
    // String? img = preferences.getString("img");

    // if (name!.isNotEmpty ||
    //     email!.isNotEmpty ||
    //     number!.isNotEmpty ||
    //     img!.isNotEmpty) {
   
    // }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  String initialCountry = 'IN';
  PhoneNumber number = PhoneNumber(isoCode: 'IN');

  FirebaseAuth _auth = FirebaseAuth.instance;
  String phonenumber = '';

  String verificationId = '';

  bool showLoading = false;

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });

      if (authCredential.user != null) {
        Navigator.of(context).pop();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfileScreen()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });
      e.message;
    }
  }

  _getnumber(PhoneNumber numb) {
    phonenumber = numb.phoneNumber!;
  }

  getMobileFormWidget(context) {
  
    return Column(
      children: [
        Spacer(),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Container(color: Color.fromRGBO(14, 54, 146, 7),height: 200, width: MediaQuery.of(context).size.width, 
                          //  child: Text("Login",style: TextStyle(fontSize: 30,color:Colors.white),),
                          child: Icon(Icons.group,color: Colors.white,size: 200,),
),
              Padding(
                padding: const EdgeInsets.all(30.0),
              ),
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  print(number.phoneNumber);
                  _getnumber(number);
              
                },
                onInputValidated: (bool value) {
                  print(value);
                  setState(() {
                  
                  });
                },
                selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                selectorTextStyle: TextStyle(color: Colors.black),
                initialValue: number,
                textFieldController: phoneController,
                formatInput: false,
                keyboardType: TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputBorder: OutlineInputBorder(),
                onSaved: (PhoneNumber number) {
                  print('On Saved: $number');
                },
              ),
            ],
          ),
        ),
        
        SizedBox(
          height: 16,
        ),
        FlatButton(
          onPressed: () async {
            setState(() {
              showLoading = true;
            });

            await _auth.verifyPhoneNumber(
              phoneNumber: phonenumber,
              verificationCompleted: (phoneAuthCredential) async {
                setState(() {
                  showLoading = false;
                });
              },
              verificationFailed: (verificationFailed) async {
                setState(() {
                  showLoading = false;
                });
              },
              codeSent: (verificationId, resendingToken) async {
                setState(() {
                  showLoading = false;
                  currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                  this.verificationId = verificationId;
                });
              },
              codeAutoRetrievalTimeout: (verificationId) async {},
            );
          },
          child: Text("Login"),
          color: Colors.blue,
          textColor: Colors.white,
        ),
      ],
    );
  }

  getOtpFormWidget(context) {
    return Column(
      children: [
        Spacer(),
        TextField(
          controller: otpController,
          decoration: InputDecoration(
            hintText: "Enter 6 digit otp OTP",
          ),
        ),
        SizedBox(
          height: 16,
        ),
        // if(_start == 60 || _start == 0)
        FlatButton(
          
          onPressed: () async {
            if(otpController.text.isEmpty || otpController.text.length < 6 || otpController.text.length > 6)
            {
               Fluttertoast.showToast(
        msg: "Enter 6 digits otp !",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
  
        textColor: Colors.white,
    );

            }else{
 PhoneAuthCredential phoneAuthCredential =
                PhoneAuthProvider.credential(
                    verificationId: verificationId,
                    smsCode: otpController.text);

            signInWithPhoneAuthCredential(phoneAuthCredential);
            }
           
          },
          child: Text("VERIFY"),
          color: Colors.blue,
          textColor: Colors.white,
        ),
        Spacer(),
        
      ] ,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          child: showLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                  ? getMobileFormWidget(context)
                  : getOtpFormWidget(context),
          padding: const EdgeInsets.all(16),
        ));
  }
}
