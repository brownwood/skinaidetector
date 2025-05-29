import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinai/appservices/image_picker_service.dart';
import 'package:skinai/constants/colors.dart';
import 'package:skinai/constants/size_config.dart';

class ProductDescriptionScreen extends StatefulWidget {
  const ProductDescriptionScreen({super.key, required this.image, required this.title, required this.stock, required this.productPrice});

  final String image;
  final String title;
  final String stock;
  final int productPrice;

  @override
  State<ProductDescriptionScreen> createState() => _ProductDescriptionScreenState();
}

class _ProductDescriptionScreenState extends State<ProductDescriptionScreen> {

  int count = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: SafeArea(
        top: true,
        child: Container(
          width: SizeConfig.screenWidth * 1,
          margin: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(
                height: SizeConfig.heightMultiplier * 2,
              ),

              Stack(
                children: [

                  // Background Support Container

                  SizedBox(
                    width: SizeConfig.screenWidth * 1,
                    height: SizeConfig.screenHeight * 0.38,
                  ),

                  // Image Container
                  Container(
                    width: SizeConfig.screenWidth * 1,
                    height: SizeConfig.screenHeight * 0.38,
                    decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha:0.8),
                      borderRadius: BorderRadius.circular(20),
                      image:DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(widget.image)),
                    ),
                  ),

                  // Icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon: const Icon(Iconsax.arrow_left,color: primaryColor,size: 30,)),
                      IconButton(onPressed: (){}, icon: const Icon(Iconsax.shopping_bag4,color: primaryColor,size: 30,)),
                    ],
                  ),

                  Positioned(
                      top: 240,
                      left: 16,
                      child: Container(
                    decoration: BoxDecoration(
                      color: widget.stock == "In Stock" ? successColor : dangerColor,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                    child: Text(widget.stock,style: TextStyle(fontSize: SizeConfig.textMultiplier * 1.4, fontWeight: FontWeight.w800,color: secondaryColor)),
                  )),
                ],
              ),

              SizedBox(
                height: SizeConfig.heightMultiplier * 2,
              ),

              SizedBox(
                // height: SizeConfig.screenHeight * 0.07,
                  width: SizeConfig.screenWidth * 0.8,
                  child: Text(widget.title,style: TextStyle(fontSize: SizeConfig.textMultiplier * 2.5, fontWeight: FontWeight.w800,color: primaryColor),overflow: TextOverflow.ellipsis,maxLines: 2,)),

              SizedBox(
                height: SizeConfig.heightMultiplier * 2,
              ),


              Text('Description:',style: TextStyle(fontSize: SizeConfig.textMultiplier * 1.6, fontWeight: FontWeight.w400,color: primaryColor.withValues(alpha:0.6))),

              Container(
                width: SizeConfig.screenWidth * 0.95,
                height: SizeConfig.screenHeight * 0.336,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Text(ImagePickerService.testDescription),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: SizeConfig.screenWidth * 1,
        height: SizeConfig.screenHeight * 0.08,
        margin: const EdgeInsets.only(left: 26, right: 26),
        decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(40)
        ),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(14)
              ),
              child: Text("Add to Cart",style: TextStyle(
                  fontSize: SizeConfig.textMultiplier * 1.8,
                  color: secondaryColor,
                  fontWeight: FontWeight.w600
              ),),
            ),

            Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        if(count > 1){
                          setState(() {
                            count--;
                          });
                        }
                      },
                      child: Container(
                        width: SizeConfig.screenWidth * 0.08,
                        height: SizeConfig.screenHeight * 0.055,
                        decoration: const BoxDecoration(
                            color: accentColor,
                            shape: BoxShape.circle
                        ),
                        child: const Icon(Iconsax.minus,color: secondaryColor,),
                      ),
                    ),

                    SizedBox(
                      width: SizeConfig.widthMultiplier * 6,
                    ),

                    Text('$count',style: TextStyle(fontSize: SizeConfig.textMultiplier * 2, fontWeight: FontWeight.w600,color: primaryColor.withValues(alpha:0.6))),

                    SizedBox(
                      width: SizeConfig.widthMultiplier * 6,
                    ),

                    GestureDetector(
                      onTap: (){
                        setState(() {
                          count++;
                        });
                      },
                      child: Container(
                        width: SizeConfig.screenWidth * 0.08,
                        height: SizeConfig.screenHeight * 0.055,
                        decoration: const BoxDecoration(
                            color: accentColor,
                            shape: BoxShape.circle
                        ),
                        child: const Icon(Iconsax.add,color: secondaryColor,),
                      ),
                    )
                  ],
                ),

                Text('${widget.productPrice * count} PKR',style: TextStyle(fontSize: SizeConfig.textMultiplier * 1.5, fontWeight: FontWeight.w800,color: primaryColor)),

              ],
            )
          ],
        ),

      ),
    );
  }
}
