import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skinai/views/home_screen.dart';
import 'package:skinai/views/register_screen.dart';

import '../appservices/image_picker_service.dart';
import '../constants/colors.dart';
import '../constants/size_config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final key = GlobalKey<FormState>();

  bool isHidden = true;
  bool isProcessing = false;

  loginUser()async{
    try{
      setState(() {
        isProcessing = true;
      });

      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text.toLowerCase().toString(), password: password.text.toLowerCase().toString());

      final SharedPreferences userLog = await SharedPreferences.getInstance();
      userLog.setString("email", email.text.toLowerCase().toString());

      ImagePickerService.customMessage(context, "Login Successfully", 0);

      setState(() {
        isProcessing = false;
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));

    }on FirebaseAuthException catch(e){
      setState(() {
        isProcessing = false;
      });
      ImagePickerService.customMessage(context, e.code, 1);
      throw Exception(e);
    }
  }

  void passwordHideShow(){
    setState(() {
      isHidden = ! isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) => exit(0),
      child: Scaffold(
        body: Container(
          width: SizeConfig.screenWidth * 1,
          height: SizeConfig.screenHeight * 1,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [


                Text("Login Screen", style: TextStyle(
                    fontSize: SizeConfig.textMultiplier * 2,
                    fontWeight: FontWeight.w600,
                    color: primaryColor
                ),),

                SizedBox(height: SizeConfig.heightMultiplier * 2,),

                TextFormField(
                  controller: email,
                  validator: (val){
                    if(val == "" || val == null || val.isEmpty ){
                      return("Email is Required");
                    } return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(
                      color: Colors.grey,          // color of hint text
                      fontSize: 14,                // size of hint text
                      fontWeight: FontWeight.w400, // weight of hint text
                      fontStyle: FontStyle.normal, // optional italic style
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: accentColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: accentColor, width: 2),
                    ),
                  ),
                ),

                SizedBox(height: SizeConfig.heightMultiplier * 1,),

                TextFormField(
                  controller: password,
                  validator: (val){
                    if(val == "" || val == null || val.isEmpty ){
                      return("Password is Required");
                    } return null;
                  },
                  obscureText: isHidden,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(onPressed: (){
                      passwordHideShow();
                    }, icon: isHidden ?Icon(Icons.close) :Icon(Icons.remove_red_eye)),
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(
                      color: Colors.grey,          // color of hint text
                      fontSize: 14,                // size of hint text
                      fontWeight: FontWeight.w400, // weight of hint text
                      fontStyle: FontStyle.normal, // optional italic style
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: accentColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: accentColor, width: 2),
                    ),
                  ),
                ),


                SizedBox(height: SizeConfig.heightMultiplier * 1,),

                isProcessing ? CircularProgressIndicator() : ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(accentColor)
                    ),
                    onPressed: (){
                      if(key.currentState!.validate()){
                        loginUser();
                      }
                    }, child: Text("Sign In",style: TextStyle(
                    color: secondaryColor
                ),)),

                SizedBox(height: SizeConfig.heightMultiplier * 1,),

                InkWell(
                  onTap:(){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen(),));
                  },
                  child: Text("Don't have an Account ! Sign Up", style: TextStyle(
                      fontSize: SizeConfig.textMultiplier * 1.4,
                      fontWeight: FontWeight.w400,
                      color: primaryColor
                  ),),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
