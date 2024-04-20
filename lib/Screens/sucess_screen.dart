import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Styles/constants.dart';
import '../Styles/style.dart';
import '../helpers/custom_text.dart';




class SuccesScreen extends StatelessWidget {

  final String sol;
  final String usdt;

  const SuccesScreen({super.key, required this.sol, required this.usdt});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(

      body: SafeArea(
        child: Center(

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              CircleAvatar(backgroundColor: CupertinoColors.black,
                radius: 25,
                child: Icon(
                  CupertinoIcons.wand_stars_inverse, color: Colors.white,),),
              SizedBox(height:10),
              CustomText(
                color: Colors.black,
                size:21,
                text: "Swap has been completed",
              ),
              SizedBox(height:5),

              CustomText(
                color: Colors.black54,
                size:18,
                weight:FontWeight.w500,

                text: "You just swapped "+sol+"SOL to\nget "+usdt+"USDT successfully",
              ),

              SizedBox(height:10),

              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: kDefaultPadding/2, vertical: kDefaultPadding/2),
                child: InkWell(
                  onTap:(){
                    Navigator.pop(context);

                  },
                  child: Container(

                    decoration: BoxDecoration(color: active,
                        borderRadius: BorderRadius.circular(20)),
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: CustomText(
                      color: Colors.white,
                      text: "Swap again",
                    ),
                  ),
                ),
              ),


              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: kDefaultPadding/2, vertical: kDefaultPadding/2),
                child: InkWell(
                  onTap:(){
                    Navigator.pop(context);

                  },
                  child: Container(

                    decoration: BoxDecoration(color: Colors.black12,
                        borderRadius: BorderRadius.circular(20)),
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: CustomText(
                      color: active,
                      text: "Continue to home",
                    ),
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
