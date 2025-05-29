import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skinai/bloc/process_image_bloc.dart';
import 'package:skinai/bloc/process_image_event.dart';
import 'package:skinai/constants/colors.dart';
import 'package:skinai/constants/size_config.dart';

class ImagePickerService{

  Future<void> getDataGallery(BuildContext context) async {

    dynamic gemini = Gemini.instance;
    XFile? pickImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    BlocProvider.of<ProcessImageBloc>(context).add(ProcessImageEvent(true));
    if (pickImage != null) {
      var convertedFile = File(pickImage.path);
      gemini
          .textAndImage(
        text: "You are a medical image analysis expert. Analyze the given image only if it clearly shows human skin with a visible skin condition. If the image does not contain skin or is unrelated (e.g., object, landscape, animal), respond with: Error: Please provide a clear image of human skin showing a potential skin condition.If the input is valid, detect and describe the possible skin disease in 5 to 6 concise lines, including:Name of the likely condition,Visible symptoms,Possible causes,Urgency or severity,Suggestion to consult a healthcare provider", // text
        images: [convertedFile.readAsBytesSync()], // list of images
      )
          .then((value) {
        // Safely parse the response
        final responseText = value.content!.parts.first.text;
        if(responseText.contains("Error:")){
          customMessage(context, "Please Provide a clear image of human skin showing potential skin condition.", 1);
        } else{
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context, builder: (context) {
            return Container(
              constraints: BoxConstraints(
                minWidth: SizeConfig.screenWidth * 1,
                maxWidth: SizeConfig.screenWidth * 1,
                minHeight: SizeConfig.screenHeight * 0.8,
                maxHeight: SizeConfig.screenHeight * 0.8,
              ),
              decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(20)
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: responseText == null ? const Center(child: Text("Generating response..."),) : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(height: SizeConfig.heightMultiplier * 0.5,),

                  Container(
                    width: SizeConfig.screenWidth * 1,
                    height: SizeConfig.screenHeight * 0.2,
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(primaryColor.withOpacity(0.4), BlendMode.darken),
                            image: FileImage(convertedFile))
                    ),
                    child: Text("Generated Result",style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 2.2,
                        color: secondaryColor,
                        fontWeight: FontWeight.bold
                    ),),
                  ),

                  SizedBox(height: SizeConfig.heightMultiplier * 1,),

                  Container(
                    height: SizeConfig.screenHeight * 0.2,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SingleChildScrollView(
                      physics: const ScrollPhysics(),
                      child: Text(responseText,style: TextStyle(
                          fontSize: SizeConfig.textMultiplier * 1.6,
                          color: primaryColor,
                          fontWeight: FontWeight.w400
                      ),),
                    ),
                  ),

                  SizedBox(height: SizeConfig.heightMultiplier * 1,),

                  Center(
                    child: ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(accentColor)
                        ),
                        onPressed: (){}, child: Text("Suggest Products",style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 1.4,
                        color: secondaryColor,
                        fontWeight: FontWeight.w400
                    ),)),
                  ),

                ],
              ),
            );
          },);
        }

      })
          .catchError((e) => print('Error: $e'));
    } else {
      if(context.mounted){
        BlocProvider.of<ProcessImageBloc>(context).add(ProcessImageEvent(false));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image Not Selected')),
        );
      }
    }
  }

  Future<void> getDataCamera(BuildContext context) async {

    dynamic gemini = Gemini.instance;
    XFile? pickImage = await ImagePicker().pickImage(source: ImageSource.camera);
    BlocProvider.of<ProcessImageBloc>(context).add(ProcessImageEvent(true));
    if (pickImage != null) {
      var convertedFile = File(pickImage.path);
      gemini
          .textAndImage(
        text: "You are a medical image analysis expert. Analyze the given image only if it clearly shows human skin with a visible skin condition. If the image does not contain skin or is unrelated (e.g., object, landscape, animal), respond with: Error: Please provide a clear image of human skin showing a potential skin condition.If the input is valid, detect and describe the possible skin disease in 5 to 6 concise lines, including:Name of the likely condition,Visible symptoms,Possible causes,Urgency or severity,Suggestion to consult a healthcare provider", // text
        images: [convertedFile.readAsBytesSync()], // list of images
      )
          .then((value) {
        // Safely parse the response
        final responseText = value.content!.parts.first.text;
        if(responseText.contains("Error:")){
          customMessage(context, "Please Provide a clear image of human skin showing potential skin condition.", 1);
        } else{
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context, builder: (context) {
            return Container(
              constraints: BoxConstraints(
                minWidth: SizeConfig.screenWidth * 1,
                maxWidth: SizeConfig.screenWidth * 1,
                minHeight: SizeConfig.screenHeight * 0.8,
                maxHeight: SizeConfig.screenHeight * 0.8,
              ),
              decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(20)
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: responseText == null ? const Center(child: Text("Generating response..."),) : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(height: SizeConfig.heightMultiplier * 0.5,),

                  Container(
                    width: SizeConfig.screenWidth * 1,
                    height: SizeConfig.screenHeight * 0.2,
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(primaryColor.withOpacity(0.4), BlendMode.darken),
                            image: FileImage(convertedFile))
                    ),
                    child: Text("Generated Result",style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 2.2,
                        color: secondaryColor,
                        fontWeight: FontWeight.bold
                    ),),
                  ),

                  SizedBox(height: SizeConfig.heightMultiplier * 1,),

                  Container(
                    height: SizeConfig.screenHeight * 0.2,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SingleChildScrollView(
                      physics: const ScrollPhysics(),
                      child: Text(responseText,style: TextStyle(
                          fontSize: SizeConfig.textMultiplier * 1.6,
                          color: primaryColor,
                          fontWeight: FontWeight.w400
                      ),),
                    ),
                  ),

                  SizedBox(height: SizeConfig.heightMultiplier * 1,),

                  Center(
                    child: ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(accentColor)
                        ),
                        onPressed: (){}, child: Text("Suggest Products",style: TextStyle(
                        fontSize: SizeConfig.textMultiplier * 1.4,
                        color: secondaryColor,
                        fontWeight: FontWeight.w400
                    ),)),
                  ),

                ],
              ),
            );
          },);
        }

      })
          .catchError((e) => print('Error: $e'));
    } else {
      if(context.mounted){
        BlocProvider.of<ProcessImageBloc>(context).add(ProcessImageEvent(false));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image Not Selected')),
        );
      }
    }
  }

  static void customMessage(BuildContext context, String message, int type){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.down,
        elevation: 0,
        duration: const Duration(seconds: 6),
        margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
        content: Container(
      decoration: BoxDecoration(
        color: type == 1 ? dangerColor : accentColor,
        borderRadius: BorderRadius.circular(14)
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
      child: Row(
        children: [

          Icon(type == 1 ? Iconsax.danger : Iconsax.magicpen, size: 20, color: secondaryColor,),

          SizedBox(width: SizeConfig.widthMultiplier * 2,),

          SizedBox(
            width: SizeConfig.screenWidth * 0.6,
            child: Text(message,style: TextStyle(
              color: secondaryColor,
              fontSize: SizeConfig.textMultiplier * 1.5,
              fontWeight: FontWeight.w600
            ),textAlign: TextAlign.left,overflow: TextOverflow.fade, maxLines: 3,),
          ),
        ],
      ),
    )));
  }

  static String testDescription = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";


  Future uploadingImageToFirebase(BuildContext context, int type)async{
    XFile? image = await ImagePicker().pickImage(source: type == 0 ? ImageSource.camera : ImageSource.gallery);
    if(image != null){
      File convertedImage = File(image.path);
      customMessage(context, "Analyzing Images", 0);
      UploadTask uploadTask = FirebaseStorage.instance.ref().child("ImageForAI").child(DateTime.now().toString()).putFile(convertedImage);
      TaskSnapshot taskSnapshot = await uploadTask;
      String userImage = await taskSnapshot.ref.getDownloadURL();
      debugPrint("UserImage Uploaded: $userImage");
      return userImage;
    } else{
      customMessage(context, "message", 1);
    }
  }
  Future analyzeImageWithOpenAI(BuildContext context, int type)async{
    final String userImage = await uploadingImageToFirebase(context, type);

    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://hydra-hub-mf38ztuwu-touseef-ahmeds-projects.vercel.app/api/ai/analyze'));
    request.body = json.encode({
      "imageUrl": userImage,
      "message": "Please analyze this skin condition"
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var res = await response.stream.bytesToString();
      var message = jsonDecode(res);
      debugPrint("${message["data"]}");
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context, builder: (context) {
        return Container(
          constraints: BoxConstraints(
            minWidth: SizeConfig.screenWidth * 1,
            maxWidth: SizeConfig.screenWidth * 1,
            minHeight: SizeConfig.screenHeight * 0.8,
            maxHeight: SizeConfig.screenHeight * 0.8,
          ),
          decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(20)
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: SizeConfig.heightMultiplier * 0.5,),

              Container(
                width: SizeConfig.screenWidth * 1,
                height: SizeConfig.screenHeight * 0.2,
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(primaryColor.withOpacity(0.4), BlendMode.darken),
                        image: NetworkImage(userImage))
                ),
                child: Text("Generated Result",style: TextStyle(
                    fontSize: SizeConfig.textMultiplier * 2.2,
                    color: secondaryColor,
                    fontWeight: FontWeight.bold
                ),),
              ),

              SizedBox(height: SizeConfig.heightMultiplier * 1,),

              Container(
                height: SizeConfig.screenHeight * 0.2,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Text("${message["data"]["analysis"]}",style: TextStyle(
                      fontSize: SizeConfig.textMultiplier * 1.6,
                      color: primaryColor,
                      fontWeight: FontWeight.w400
                  ),),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(accentColor)
                      ),
                      onPressed: (){}, child: Text("Suggest Products",style: TextStyle(
                      fontSize: SizeConfig.textMultiplier * 1.4,
                      color: secondaryColor,
                      fontWeight: FontWeight.w400
                  ),)),
                  ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(accentColor)
                      ),
                      onPressed: (){}, child: Text("Suggest Doctors",style: TextStyle(
                      fontSize: SizeConfig.textMultiplier * 1.4,
                      color: secondaryColor,
                      fontWeight: FontWeight.w400
                  ),))
                ],
              )

            ],
          ),
        );
      },);
    }
    else {
      print(response.reasonPhrase);
    }


  }
}