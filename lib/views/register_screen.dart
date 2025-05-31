import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skinai/appservices/image_picker_service.dart';
import 'package:skinai/constants/colors.dart';
import 'package:skinai/constants/size_config.dart';
import 'package:skinai/views/login_screen.dart';
import 'package:uuid/uuid.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final key = GlobalKey<FormState>();

  File? userImage;
  bool isImagePicked = false;
  bool isHidden = true;
  bool isProcessing = false;

  void getUserImage()async{
    XFile? pickImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pickImage != null){
      File convertedFile = File(pickImage.path);
      setState(() {
        userImage = convertedFile;
        isImagePicked = true;
      });
    }
  }

  void passwordHideShow(){
    setState(() {
      isHidden = ! isHidden;
    });
  }

  uploadUserImage(String userID)async{
    if(userImage != null){
      try{
        UploadTask uploadTask = FirebaseStorage.instance.ref().child("AppUsers").child(userID).putFile(userImage!);
        TaskSnapshot taskSnapshot = await uploadTask;
        String userImageUpload = await taskSnapshot.ref.getDownloadURL();
        debugPrint("UserImage Uploaded: $userImage");
        return userImageUpload;
      } catch(e){
        throw Exception(e);
      }
    } else{
        ImagePickerService.customMessage(context, "Image Required", 1);
    }
  }

  addDataToFirebase()async{
    try{
      setState(() {
        isProcessing = true;
      });
      final id = const Uuid().v1();
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text.toLowerCase().toString(), password: password.text.toLowerCase().toString());

      String getUserImage = await uploadUserImage(id);

      await FirebaseFirestore.instance.collection("AppUsers").add({
        "userID" : id,
        "userImage" : getUserImage,
        "userName" : name.text.toString(),
        "userEmail" : email.text.toLowerCase().toString(),
        "userPassword" : password.text.toLowerCase().toString(),
      });

      ImagePickerService.customMessage(context, "Data Uploaded Successfully", 0);

      setState(() {
        isProcessing = false;
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));

    }on FirebaseAuthException catch(e){
      setState(() {
        isProcessing = false;
      });
      ImagePickerService.customMessage(context, e.code, 1);
      throw Exception(e);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: SizeConfig.screenWidth * 1,
        height: SizeConfig.screenHeight * 1,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [


              Text("Register Screen", style: TextStyle(
                fontSize: SizeConfig.textMultiplier * 2,
                fontWeight: FontWeight.w600,
                color: primaryColor
              ),),

              SizedBox(height: SizeConfig.heightMultiplier * 2,),

              isImagePicked ? GestureDetector(
               onTap: (){
                 getUserImage();
               },
                child: CircleAvatar(
                  radius: 64,
                  backgroundColor: accentColor,
                  backgroundImage: FileImage(userImage!),
                ),
              ) : GestureDetector(
                onTap: (){
                  getUserImage();
                },
                child: CircleAvatar(
                  radius: 64,
                  backgroundColor: accentColor,
                  child: Icon(Icons.person, color: secondaryColor,size: 50,),
                ),
              ),

              SizedBox(height: SizeConfig.heightMultiplier * 2,),

              TextFormField(
                controller: name,
                validator: (val){
                  if(val == "" || val == null || val.isEmpty ){
                    return("Name is Required");
                  } return null;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your name',
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
                      addDataToFirebase();
                    }
                  }, child: Text("Sign Up",style: TextStyle(
                  color: secondaryColor
              ),)),

              SizedBox(height: SizeConfig.heightMultiplier * 1,),

              InkWell(
                onTap:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                },
                child: Text("Already have an Account ! Sign in", style: TextStyle(
                    fontSize: SizeConfig.textMultiplier * 1.4,
                    fontWeight: FontWeight.w400,
                    color: primaryColor
                ),),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
