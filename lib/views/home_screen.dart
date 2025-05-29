import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skinai/appservices/image_picker_service.dart';
import 'package:skinai/bloc/process_image_bloc.dart';
import 'package:skinai/bloc/process_image_state.dart';
import 'package:skinai/constants/colors.dart';
import 'package:skinai/constants/size_config.dart';
import 'package:skinai/views/chat_screen.dart';
import 'package:skinai/views/product_description_screen.dart';

import '../bloc/process_image_event.dart';
import '../reuseablewidgets/face_scanning_container.dart';
import '../reuseablewidgets/product_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final List<String> productImages = ['images/productImages/serum1.jpg','images/productImages/serum2.jpg','images/productImages/serum3.jpg'];
  final List<String> productTitle = ['Glow Recipe Strawberry Smooth BHA +','La Roche-Posay Hyalu B5', 'Hyaluronic + Peptide 24'];
  final List<int> productPrice = [25000,14000, 23000];
  final List<String> productAvailability = ['In Stock','Out of Stock', 'In Stock'];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<ProcessImageBloc>(context).add(ProcessImageEvent(false));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: secondaryColor,
      drawer: const Drawer(),
      body: BlocListener<ProcessImageBloc, ProcessImageState>(listener: (context, state) {
        if(state is ProcessStatus){
          state.isProcessing ? ImagePickerService.customMessage(context, "Processing Image",0) : Container() ;
        }
      },child: SafeArea(
        top: true,
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 14),
            width: SizeConfig.screenWidth * 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(
                  width: SizeConfig.screenWidth * 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      IconButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(),));
                      }, icon: const Icon(Iconsax.message)),

                      Text('AI Care',style: TextStyle(fontSize: SizeConfig.textMultiplier * 2, fontWeight: FontWeight.w600,color: primaryColor),overflow: TextOverflow.fade,),


                      IconButton(onPressed: (){}, icon: const Icon(Iconsax.shopping_bag4))
                    ],
                  ),
                ),


                // Face Scanning Container
                const FaceScanningContainer(),

                SizedBox(
                  height: SizeConfig.blockSizeVertical * 2,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Top Selling',style: TextStyle(fontSize: SizeConfig.textMultiplier * 2, fontWeight: FontWeight.w600,color: primaryColor),),
                    Text('see more',style: TextStyle(fontSize: SizeConfig.textMultiplier * 1.5, fontWeight: FontWeight.w400,color: primaryColor),),
                  ],
                ),

                // Product Listing

                SizedBox(
                  width: SizeConfig.screenWidth * 1,
                  height: SizeConfig.screenHeight * 0.5,
                  child: CustomScrollView(
                    physics: const ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    slivers:[

                      SliverAnimatedList(
                        itemBuilder: (context, index, animation) {
                          return GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDescriptionScreen(image: productImages[index], title: productTitle[index],stock: productAvailability[index],productPrice: productPrice[index],),));
                          },
                          child: ProductContainer(
                            productImage: productImages[index],
                            productTitle: productTitle[index],
                            productCategory: 'Beauty',
                            productPrice: '${productPrice[index]} PKR',
                            productAvailability: productAvailability[index],
                          ),
                        );
                      },initialItemCount: productTitle.length,)
                    ]
                  ),
                )

              ],
            )
        ),
      ))
    );
  }
}


