import 'package:SimpleSwap/Screens/sucess_screen.dart';
import 'package:SimpleSwap/Styles/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:solana_web3/programs.dart';
import 'package:solana_web3/solana_web3.dart' as web3;
import 'package:solana_web3/solana_web3.dart';
import '../Styles/constants.dart';
import '../Styles/style.dart';
import '../helpers/custom_text.dart';
import '../helpers/helperFunctions.dart';
import '../main.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';


const LAMPORTS_PER_SOL = 1000000000;

class Review_Swap_Screen extends StatefulWidget {
  @override
  State<Review_Swap_Screen> createState() => _Review_Swap_ScreenState();
}

class _Review_Swap_ScreenState extends State<Review_Swap_Screen> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  final programId = web3.Pubkey.fromBase58("dummy_program_id");
  late BlockhashWithExpiryBlockHeight blockhash;
  String SOLADRESS="8Nm6jv1281Wj988SgK1WRBWbVDHJNC8MJEF5K8uwdiZn";

  TextEditingController xxx = new TextEditingController();
  TextEditingController wallet = new TextEditingController();
  final connection = Connection(Cluster.devnet);
  String _solAmount = '0.0';
  String _usdtEquivalent = '0.0';
  double balance=50.0;
  // Exchange rate (1 SOL = 145 USDT)
  static const double exchangeRate = 145;
  List<String> percentages=["25%","50%","75%","100%"];

  Future<double?> getTestnetBalance() async {

    blockhash = await connection.getLatestBlockhash();

    final publicKey = web3.Pubkey.fromString(SOLADRESS);


    // Check the account balances before making the transfer.
    final balance = await connection.getBalance(publicKey);

    return balance.toDouble()/ LAMPORTS_PER_SOL;
  }


  double calculateEquivalentUSDT(double solAmount) {
    return solAmount * exchangeRate;
  }

  void calculatePercentage(double _percentage,double balance) {
    if (balance > 0 && _percentage > 0 && _percentage <= 100) {
      double calculatedAmount = (_percentage / 100) * balance;
      double temp_usdtEquivalent = calculateEquivalentUSDT(calculatedAmount);
      setState(() {
         _solAmount = calculatedAmount .toString();
         _usdtEquivalent = temp_usdtEquivalent.toString();


      });
    }else{
      snack("Top up your SOL balance to implement this",context);
    }
  }

  void _openPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter amount of SOL to swap:'),
          content: TextField(
            keyboardType: TextInputType.number,
            controller:xxx,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],

          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {

                if(xxx.text.length>0) {
                  setState(() {
                    _solAmount = xxx.text;
                    _usdtEquivalent =
                        calculateEquivalentUSDT(double.parse(_solAmount))
                            .toString();
                  });
                  Navigator.of(context).pop();
                }else{
                  Navigator.of(context).pop();

                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void wallet_openPopup(BuildContext context) {

    bool showPBAR=false;
    String displayedAddress = SOLADRESS.substring(0, 4) +
        "............" +
        SOLADRESS.substring(SOLADRESS.length - 4);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter a valid SOL Address:'),
          content: TextField(
            controller:wallet,
            decoration: InputDecoration(
              labelText: displayedAddress ,
              border: OutlineInputBorder(),
            ),


          ),
          actions: <Widget>[



            ElevatedButton(
              onPressed: () async{

                if(wallet.text.length>0) {
                  setState(() {
                    SOLADRESS=wallet.text;

                    showPBAR=true;

                  });
                  SmartDialog.showLoading(msg: "Just a moment...",clickMaskDismiss: true,backDismiss: true);

                  await getTestnetBalance();

                  SmartDialog.dismiss();

                  showPBAR=false;

                  Navigator.of(context).pop();



                }else{
                  Navigator.of(context).pop();

                }
              },
              child: Text('OK'),
            ),

          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final ThemeData mode=Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(

          child: Text("Swap",style: TextStyle(fontWeight: FontWeight.bold),),
        ),
          actions: [

            InkWell(

              onTap:(){
                wallet_openPopup(context);
              },

              child: Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: Icon(CupertinoIcons.creditcard,color: CupertinoColors.black,),
              ),
            ),
          ]// like this!
      ),
      body: Center(
        child: FutureBuilder<double?>(
          future: getTestnetBalance(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Error: ${snapshot.error}',textAlign:TextAlign.center),
                );
              }

               balance = snapshot.data!>0?snapshot.data!:balance;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,




                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [

                            Stack(
                              children: [




                                Column(
                                  children: [

                                    Container(
                                      padding: EdgeInsets.all(kDefaultPadding),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: InkWell(

                                        onTap:(){

                                          _openPopup(context);
                                        },

                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,

                                                  children: [
                                                    Text(
                                                        "You pay" ,textAlign: TextAlign.left,style:GoogleFonts.lato(

                                                        fontSize:16,fontWeight: FontWeight.w600)

                                                    ),
                                                    SizedBox(height: 7),

                                                    Text(
                                                        _solAmount ,textAlign: TextAlign.left,style:GoogleFonts.lato(
                                                        fontSize: 25)


                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(child:SizedBox(width:10)),
                                              Expanded(
                                                child: Column(

                                                  children: [
                                                    Text(
                                                        "Balance: "+balance.toString() ,textAlign: TextAlign.left,style:GoogleFonts.lato(

                                                        fontSize: 14,fontWeight: FontWeight.w600)

                                                    ),
                                                    SizedBox(height: 7),

                                                    Container(
                                                      width: 100,
                                                      height:50,
                                                      decoration:  BoxDecoration(
                                                        borderRadius: BorderRadius.circular(25),
                                                        border: Border.all(
                                                          color: mode.brightness==Brightness.dark? Colors.white:Colors.black87,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                                        children: [
                                                          CircleAvatar(backgroundImage:  AssetImage('assets/images/solana_logo.png'), maxRadius: 10,),
                                                          Text(
                                                            'SOL',
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          Icon(Icons.keyboard_arrow_down),


                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),





                                            ],
                                          ),
                                        ),
                                      ),
                                    ).addNeumorphism(
                                      blurRadius: mode.brightness==Brightness.dark?0: 15,
                                      borderRadius: mode.brightness==Brightness.dark?9: 15,
                                      offset: mode.brightness==Brightness.dark? Offset(0, 0):Offset(2, 2),
                                    ),

                                    SizedBox(height: kDefaultPadding),

                                    Container(
                                      padding: EdgeInsets.all(kDefaultPadding),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(

                                                children: [
                                                  Text(
                                                      "You get" ,textAlign: TextAlign.left,style:GoogleFonts.lato(

                                                      fontSize:16,fontWeight: FontWeight.w600)

                                                  ),
                                                  SizedBox(height: 7),

                                                  Text(
                                                      _usdtEquivalent ,textAlign: TextAlign.left,style:GoogleFonts.lato(
                                                      fontSize: 25)


                                                  )
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                                child:SizedBox(width:10)),

                                            Expanded(
                                              child: Column(

                                                children: [
                                                  Text(
                                                      '\$'+_usdtEquivalent ,textAlign: TextAlign.left,style:GoogleFonts.lato(

                                                      fontSize: 14,fontWeight: FontWeight.w600)

                                                  ),
                                                  SizedBox(height: 7),

                                                  Container(
                                                    width: 100,
                                                    height:50,
                                                    decoration:  BoxDecoration(
                                                      borderRadius: BorderRadius.circular(25),
                                                      border: Border.all(
                                                        color: mode.brightness==Brightness.dark? Colors.white:Colors.black87,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        crossAxisAlignment:CrossAxisAlignment.center,


                                                      children: [
                                                        CircleAvatar(backgroundImage:  AssetImage('assets/images/usdticon.png'), maxRadius: 10,),

                                                        Text(
                                                          'USDT',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),

                                                        Icon(Icons.keyboard_arrow_down),

                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),





                                          ],
                                        ),
                                      ),
                                    ).addNeumorphism(
                                      blurRadius: mode.brightness==Brightness.dark?0: 15,
                                      borderRadius: mode.brightness==Brightness.dark?9: 15,
                                      offset: mode.brightness==Brightness.dark? Offset(0, 0):Offset(2, 2),
                                    ),
                                  ],
                                ),




                                Positioned.fill(

                                  child: Align(
                                    alignment: Alignment.center,
                                    child: CircleAvatar(backgroundColor: CupertinoColors.black,
                                      radius: 25,
                                      child: Icon(
                                        Icons.swap_vert, color: Colors.white,),),
                                  ),
                                ),

                                //   Positioned(right: 12, bottom: 12, child:Text(DateFormat('EEE, M/d/y').format(message.timestamp.toDate())),)


                              ],
                            ),

                            SizedBox(height: kDefaultPadding),


                            double.parse(_solAmount)>0? Column(
                                children:[

                                  //Divider(color:Colors.black54,thickness:.2),

                                  SizedBox(height:8),


                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children:[

                                      Text("Rate"),
                                      Text('1 SOL = 145 USDT')
                                    ]),
                                  ),

                                  SizedBox(height:15),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children:[

                                          Text("Network fee"),
                                          Text('\$0.25'),

                                        ]),
                                  ),
                                  SizedBox(height:15),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children:[

                                          Text("Price impact"),
                                          Text('2.5%'),

                                        ]),
                                  ),

                                ]): SizedBox(
                              height: 50,
                              child: ListView.builder(

                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: percentages.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                                      decoration:  BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: Colors.black12

                                      ),
                                      child: Center(
                                        child: InkWell(

                                          onTap:(){
                                            calculatePercentage(double.parse(percentages[index].replaceAll("%","")), balance);
                                          },
                                          child: Text(
                                              percentages[index],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 15.3,fontWeight: FontWeight.w500,color: Colors.black)

                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )


                          ],
                        ),
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: ()   {

                      double.parse(_solAmount)>0?  showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context2) {
                            return SingleChildScrollView(
                              child: Container(
                                color:Colors.white,
                                padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    SizedBox(height: 3,),

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children: [

                                          SizedBox(
                                            width:40,
                                            child: IconButton(
                                              onPressed: () {
                                                Navigator.pop(context2);
                                              },
                                              icon: Icon(Icons.arrow_back),
                                            ),
                                          ),
                                          CustomText(
                                            color: Colors.black,
                                            size:16,
                                            text: "Confirm Swap",
                                          ),

                                          Container(width:40)
                                        ],
                                      ),
                                    ),



                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Stack(
                                      children: [




                                        Column(
                                          children: [

                                            Container(
                                              padding: EdgeInsets.all(kDefaultPadding),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,

                                                        children: [
                                                          Text(
                                                              "Swapping" ,textAlign: TextAlign.left,style:GoogleFonts.lato(

                                                              fontSize:16,fontWeight: FontWeight.w600)

                                                          ),
                                                          SizedBox(height: 7),

                                                          Text(
                                                              _solAmount ,textAlign: TextAlign.left,style:GoogleFonts.lato(
                                                              fontSize: 25)


                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child:SizedBox(width:10)),
                                                    Expanded(
                                                      child: Column(

                                                        children: [
                                                          Text(
                                                              " " ,textAlign: TextAlign.left,style:GoogleFonts.lato(

                                                              fontSize: 14,fontWeight: FontWeight.w600)

                                                          ),
                                                          SizedBox(height: 7),

                                                          Container(
                                                            width: 100,
                                                            height:50,

                                                            decoration:  BoxDecoration(
                                                              borderRadius: BorderRadius.circular(25),
                                                              border: Border.all(
                                                                color: mode.brightness==Brightness.dark? Colors.white:Colors.black87,
                                                              ),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,

                                                              children: [
                                                                CircleAvatar(backgroundImage:  AssetImage('assets/images/solana_logo.png'), maxRadius: 10,),

                                                                SizedBox(width:2),
                                                                Text(
                                                                  'SOL',
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),

                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),





                                                  ],
                                                ),
                                              ),
                                            ).addNeumorphism(
                                              blurRadius: mode.brightness==Brightness.dark?0: 15,
                                              borderRadius: mode.brightness==Brightness.dark?9: 15,
                                              offset: mode.brightness==Brightness.dark? Offset(0, 0):Offset(2, 2),
                                            ),

                                            SizedBox(height: kDefaultPadding),

                                            Container(
                                              padding: EdgeInsets.all(kDefaultPadding),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Column(

                                                        children: [
                                                          Text(
                                                              "To get" ,textAlign: TextAlign.left,style:GoogleFonts.lato(

                                                              fontSize:16,fontWeight: FontWeight.w600)

                                                          ),
                                                          SizedBox(height: 7),

                                                          Text(
                                                              _usdtEquivalent ,textAlign: TextAlign.left,style:GoogleFonts.lato(
                                                              fontSize: 25)


                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child:SizedBox(width:10)),

                                                    Expanded(
                                                      child: Column(

                                                        children: [
                                                          Text(
                                                              '\$'+_usdtEquivalent ,textAlign: TextAlign.left,style:GoogleFonts.lato(

                                                              fontSize: 14,fontWeight: FontWeight.w600)

                                                          ),
                                                          SizedBox(height: 7),

                                                          Container(
                                                            width: 100,
                                                            height:50,
                                                            decoration:  BoxDecoration(
                                                              borderRadius: BorderRadius.circular(25),
                                                              border: Border.all(
                                                                color: mode.brightness==Brightness.dark? Colors.white:Colors.black87,
                                                              ),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,

                                                              children: [
                                                                CircleAvatar(backgroundImage:  AssetImage('assets/images/usdticon.png'), maxRadius: 10,),

                                                                SizedBox(width:2),
                                                                Text(
                                                                  'USDT',
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),


                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),





                                                  ],
                                                ),
                                              ),
                                            ).addNeumorphism(
                                              blurRadius: mode.brightness==Brightness.dark?0: 15,
                                              borderRadius: mode.brightness==Brightness.dark?9: 15,
                                              offset: mode.brightness==Brightness.dark? Offset(0, 0):Offset(2, 2),
                                            ),
                                          ],
                                        ),




                                        Positioned.fill(

                                          child: Align(
                                            alignment: Alignment.center,
                                            child: CircleAvatar(backgroundColor: CupertinoColors.black,
                                              radius: 25,
                                              child: Icon(
                                                Icons.swap_vert, color: Colors.white,),),
                                          ),
                                        ),

                                        //   Positioned(right: 12, bottom: 12, child:Text(DateFormat('EEE, M/d/y').format(message.timestamp.toDate())),)


                                      ],
                                    ),
                                  ),
                                    SizedBox(height: kDefaultPadding),
                                    Column(
                                        children:[

                                          Divider(color:Colors.black54,thickness:.2),

                                          SizedBox(height:8),


                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                children:[

                                                  Text("Rate"),
                                                  Text('1 SOL = 145 USDT')
                                                ]),
                                          ),

                                          SizedBox(height:5),

                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                children:[

                                                  Text("Network fee"),
                                                  Text('\$0.25'),

                                                ]),
                                          ),
                                          SizedBox(height:5),

                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                children:[

                                                  Text("Price impact"),
                                                  Text('2.5%'),

                                                ]),
                                          ),

                                        ]),

                                    SizedBox(height: 15,),

                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: kDefaultPadding/2, vertical: kDefaultPadding/2),
                                      child: InkWell(
                                        onTap:() async {


                                          String x=_solAmount;
                                          String y=_usdtEquivalent;

                                          if(balance>double.parse(_solAmount)) {



                                            Navigator.pop(context2);

                                            setState(() {
                                             balance=balance-double.parse(_solAmount);
                                             _solAmount="0.0";
                                             _usdtEquivalent="0.0";
                                            });

                                            PersistentNavBarNavigator
                                                .pushNewScreen(
                                              context,
                                              screen: SuccesScreen(sol:x,usdt:y),
                                              withNavBar: true,
                                              // OPTIONAL VALUE. True by default.
                                              pageTransitionAnimation: PageTransitionAnimation
                                                  .cupertino,
                                            );





                                            //THE REAL PROGRAM IS COMMENTED BELOW



                                            /*

                                            if (double.parse(_solAmount).floor() != double.parse(_solAmount)) {
                                              throw Exception("SOL amount must be a whole number");
                                            }

                                            final solAmountAsInt = double.parse(_solAmount).floor(); // Convert to integer (whole SOL units)


                                            final solAmountBytes = intToBytesLE(solAmountAsInt);



                                            final instruction = TransactionInstruction(
                                              programId: programId,
                                              data: solAmountBytes, keys: [],
                                            );



                                            final transaction = web3.Transaction.v0(
                                                payer: web3.Pubkey.fromString(SOLADRESS),
                                                recentBlockhash: blockhash.blockhash,
                                                instructions: [
                                                  instruction
                                                ]
                                            );

                                            //A dummy private key
                                            int PRIVATE_KEY=49898938598595454;

                                            final keypair = await Keypair.fromSeckey(Uint8List(PRIVATE_KEY));


                                            transaction.sign([keypair]);

                                            // Send the transaction to the cluster and wait for it to be confirmed.
                                            print('Send and confirm transaction...\n');
                                            await connection.sendAndConfirmTransaction(
                                              transaction,
                                            );



                                            final temp_balance = await connection.getBalance(web3.Pubkey.fromString(SOLADRESS));

                                            setState((){
                                              balance=temp_balance.toDouble()/ LAMPORTS_PER_SOL;

                                            });


                                             */

                                          }else{
                                            snack("The SOL amount you entered exceeds your balance", context);
                                          }
                                        },
                                        child: Container(

                                          decoration: BoxDecoration(color: active,
                                              borderRadius: BorderRadius.circular(20)),
                                          alignment: Alignment.center,
                                          width: double.maxFinite,
                                          padding: EdgeInsets.symmetric(vertical: 16),
                                          child: CustomText(
                                            color: Colors.white,
                                            text: "Confirm Swap",
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10)

                                  ],
                                ),
                              ),
                            );
                          }):snack("Enter the amount of SOL you want to swap", context);





                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: kDefaultPadding/2, vertical: kDefaultPadding/2),
                      child: Container(

                        decoration: BoxDecoration(color:double.parse(_solAmount)>0? active:Colors.grey,
                            borderRadius: BorderRadius.circular(20)),
                        alignment: Alignment.center,
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: CustomText(
                          color: double.parse(_solAmount)>0? Colors.white:Colors.black87,
                          text: "Review Swap",
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,




                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [

                            Stack(
                              children: [




                                Column(
                                  children: [

                                    Container(
                                      padding: EdgeInsets.all(kDefaultPadding),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: InkWell(

                                        onTap:(){

                                          _openPopup(context);
                                        },

                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,

                                                  children: [
                                                    Text(
                                                        "You pay" ,textAlign: TextAlign.left,style:GoogleFonts.lato(

                                                        fontSize:16,fontWeight: FontWeight.w600)

                                                    ),
                                                    SizedBox(height: 7),

                                                    Text(
                                                        "---" ,textAlign: TextAlign.left,style:GoogleFonts.lato(
                                                        fontSize: 25)


                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                  child:SizedBox(width:10)),
                                              Expanded(
                                                child: Column(

                                                  children: [
                                                    Text(
                                                        "Balance: "+"---" ,textAlign: TextAlign.left,style:GoogleFonts.lato(

                                                        fontSize: 14,fontWeight: FontWeight.w600)

                                                    ),
                                                    SizedBox(height: 7),

                                                    Container(
                                                      width: 100,
                                                      height:50,
                                                      decoration:  BoxDecoration(
                                                        borderRadius: BorderRadius.circular(25),
                                                        border: Border.all(
                                                          color: mode.brightness==Brightness.dark? Colors.white:Colors.black87,
                                                        ),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                                        children: [
                                                          CircleAvatar(backgroundImage:  AssetImage('assets/images/solana_logo.png'), maxRadius: 10,),
                                                          Text(
                                                            'SOL',
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          Icon(Icons.keyboard_arrow_down),


                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),





                                            ],
                                          ),
                                        ),
                                      ),
                                    ).addNeumorphism(
                                      blurRadius: mode.brightness==Brightness.dark?0: 15,
                                      borderRadius: mode.brightness==Brightness.dark?9: 15,
                                      offset: mode.brightness==Brightness.dark? Offset(0, 0):Offset(2, 2),
                                    ),

                                    SizedBox(height: kDefaultPadding),

                                    Container(
                                      padding: EdgeInsets.all(kDefaultPadding),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(

                                                children: [
                                                  Text(
                                                      "You get" ,textAlign: TextAlign.left,style:GoogleFonts.lato(

                                                      fontSize:16,fontWeight: FontWeight.w600)

                                                  ),
                                                  SizedBox(height: 7),

                                                  Text(
                                                      "---" ,textAlign: TextAlign.left,style:GoogleFonts.lato(
                                                      fontSize: 25)


                                                  )
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                                child:SizedBox(width:10)),

                                            Expanded(
                                              child: Column(

                                                children: [
                                                  Text(
                                                      '\$'+_usdtEquivalent ,textAlign: TextAlign.left,style:GoogleFonts.lato(

                                                      fontSize: 14,fontWeight: FontWeight.w600)

                                                  ),
                                                  SizedBox(height: 7),

                                                  Container(
                                                    width: 100,
                                                    height:50,
                                                    decoration:  BoxDecoration(
                                                      borderRadius: BorderRadius.circular(25),
                                                      border: Border.all(
                                                        color: mode.brightness==Brightness.dark? Colors.white:Colors.black87,
                                                      ),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      crossAxisAlignment:CrossAxisAlignment.center,


                                                      children: [
                                                        CircleAvatar(backgroundImage:  AssetImage('assets/images/usdticon.png'), maxRadius: 10,),

                                                        Text(
                                                          'USDT',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),

                                                        Icon(Icons.keyboard_arrow_down),

                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),





                                          ],
                                        ),
                                      ),
                                    ).addNeumorphism(
                                      blurRadius: mode.brightness==Brightness.dark?0: 15,
                                      borderRadius: mode.brightness==Brightness.dark?9: 15,
                                      offset: mode.brightness==Brightness.dark? Offset(0, 0):Offset(2, 2),
                                    ),
                                  ],
                                ),




                                Positioned.fill(

                                  child: Align(
                                    alignment: Alignment.center,
                                    child: CircleAvatar(backgroundColor: CupertinoColors.black,
                                      radius: 25,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: CircularProgressIndicator(color:Colors.white),
                                      ),),
                                  ),
                                ),

                                //   Positioned(right: 12, bottom: 12, child:Text(DateFormat('EEE, M/d/y').format(message.timestamp.toDate())),)


                              ],
                            ),

                            SizedBox(height: kDefaultPadding),


                            double.parse(_solAmount)>0? Column(
                                children:[

                                  //Divider(color:Colors.black54,thickness:.2),

                                  SizedBox(height:8),


                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children:[

                                          Text("Rate"),
                                          Text('1 SOL = 145 USDT')
                                        ]),
                                  ),

                                  SizedBox(height:15),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children:[

                                          Text("Network fee"),
                                          Text('\$0.25'),

                                        ]),
                                  ),
                                  SizedBox(height:15),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children:[

                                          Text("Price impact"),
                                          Text('2.5%'),

                                        ]),
                                  ),

                                ]): SizedBox(
                              height: 50,
                              child: ListView.builder(

                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: percentages.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                                      decoration:  BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: Colors.black12

                                      ),
                                      child: Center(
                                        child: InkWell(

                                          onTap:(){
                                            calculatePercentage(double.parse(percentages[index].replaceAll("%","")), balance);
                                          },
                                          child: Text(
                                              percentages[index],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 15.3,fontWeight: FontWeight.w500,color: Colors.black)

                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )


                          ],
                        ),
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: ()   {

                      double.parse(_solAmount)>0?  showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context2) {
                            return SingleChildScrollView(
                              child: Container(
                                color:Colors.white,
                                padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    SizedBox(height: 3,),

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                        children: [

                                          SizedBox(
                                            width:40,
                                            child: IconButton(
                                              onPressed: () {
                                                Navigator.pop(context2);
                                              },
                                              icon: Icon(Icons.arrow_back),
                                            ),
                                          ),
                                          CustomText(
                                            color: Colors.black,
                                            size:16,
                                            text: "Confirm Swap",
                                          ),

                                          Container(width:40)
                                        ],
                                      ),
                                    ),



                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Stack(
                                        children: [




                                          Column(
                                            children: [

                                              Container(
                                                padding: EdgeInsets.all(kDefaultPadding),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                                child: InkWell(

                                                  onTap:(){

                                                    _openPopup(context);
                                                  },

                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.start,

                                                            children: [
                                                              Text(
                                                                  "You are about to swap" ,textAlign: TextAlign.left,style:GoogleFonts.lato(

                                                                  fontSize:16,fontWeight: FontWeight.w600)

                                                              ),
                                                              SizedBox(height: 7),

                                                              Text(
                                                                  _solAmount ,textAlign: TextAlign.left,style:GoogleFonts.lato(
                                                                  fontSize: 25)


                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                            child:SizedBox(width:10)),
                                                        Expanded(
                                                          child: Column(

                                                            children: [
                                                              Text(
                                                                  " "+balance.toString() ,textAlign: TextAlign.left,style:GoogleFonts.lato(

                                                                  fontSize: 14,fontWeight: FontWeight.w600)

                                                              ),
                                                              SizedBox(height: 7),

                                                              Container(
                                                                width:100,
                                                                padding: EdgeInsets.symmetric(
                                                                    horizontal: 5, vertical: 0),
                                                                decoration:  BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(15),
                                                                  border: Border.all(
                                                                    color: mode.brightness==Brightness.dark? Colors.white:Colors.black87,
                                                                  ),
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    CircleAvatar(backgroundImage:  AssetImage('assets/images/solana_logo.png'), maxRadius: 10,),

                                                                    Text(
                                                                      'SOL',
                                                                      style: TextStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),

                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),





                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ).addNeumorphism(
                                                blurRadius: mode.brightness==Brightness.dark?0: 15,
                                                borderRadius: mode.brightness==Brightness.dark?9: 15,
                                                offset: mode.brightness==Brightness.dark? Offset(0, 0):Offset(2, 2),
                                              ),

                                              SizedBox(height: kDefaultPadding),

                                              Container(
                                                padding: EdgeInsets.all(kDefaultPadding),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Column(

                                                          children: [
                                                            Text(
                                                                "To get" ,textAlign: TextAlign.left,style:GoogleFonts.lato(

                                                                fontSize:16,fontWeight: FontWeight.w600)

                                                            ),
                                                            SizedBox(height: 7),

                                                            Text(
                                                                _usdtEquivalent ,textAlign: TextAlign.left,style:GoogleFonts.lato(
                                                                fontSize: 25)


                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                          child:SizedBox(width:10)),

                                                      Expanded(
                                                        child: Column(

                                                          children: [
                                                            Text(
                                                                '\$'+_usdtEquivalent ,textAlign: TextAlign.left,style:GoogleFonts.lato(

                                                                fontSize: 14,fontWeight: FontWeight.w600)

                                                            ),
                                                            SizedBox(height: 7),

                                                            Container(
                                                              width:100,
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal: 5, vertical: 0),
                                                              decoration:  BoxDecoration(
                                                                borderRadius: BorderRadius.circular(15),
                                                                border: Border.all(
                                                                  color: mode.brightness==Brightness.dark? Colors.white:Colors.black87,
                                                                ),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,

                                                                children: [
                                                                  CircleAvatar(backgroundImage:  AssetImage('assets/images/usdticon.png'), maxRadius: 10,),

                                                                  Text(
                                                                    'USDT',
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),


                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),





                                                    ],
                                                  ),
                                                ),
                                              ).addNeumorphism(
                                                blurRadius: mode.brightness==Brightness.dark?0: 15,
                                                borderRadius: mode.brightness==Brightness.dark?9: 15,
                                                offset: mode.brightness==Brightness.dark? Offset(0, 0):Offset(2, 2),
                                              ),
                                            ],
                                          ),




                                          Positioned.fill(

                                            child: Align(
                                              alignment: Alignment.center,
                                              child: CircleAvatar(backgroundColor: CupertinoColors.black,
                                                radius: 25,
                                                child: Icon(
                                                  Icons.swap_vert, color: Colors.white,),),
                                            ),
                                          ),

                                          //   Positioned(right: 12, bottom: 12, child:Text(DateFormat('EEE, M/d/y').format(message.timestamp.toDate())),)


                                        ],
                                      ),
                                    ),
                                    SizedBox(height: kDefaultPadding),
                                    Column(
                                        children:[

                                          Divider(color:Colors.black54,thickness:.2),

                                          SizedBox(height:8),


                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                children:[

                                                  Text("Rate"),
                                                  Text('1 SOL = 145 USDT')
                                                ]),
                                          ),

                                          SizedBox(height:5),

                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                children:[

                                                  Text("Network fee"),
                                                  Text('\$0.25'),

                                                ]),
                                          ),
                                          SizedBox(height:5),

                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                children:[

                                                  Text("Price impact"),
                                                  Text('2.5%'),

                                                ]),
                                          ),

                                        ]),

                                    SizedBox(height: 15,),

                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: kDefaultPadding/2, vertical: kDefaultPadding/2),
                                      child: InkWell(
                                        onTap:(){
                                          Navigator.pop(context2);


                                          if(balance>double.parse(_solAmount)) {
                                            PersistentNavBarNavigator
                                                .pushNewScreen(
                                              context,
                                              screen: SuccesScreen(sol:_solAmount,usdt:_usdtEquivalent),
                                              withNavBar: true,
                                              // OPTIONAL VALUE. True by default.
                                              pageTransitionAnimation: PageTransitionAnimation
                                                  .cupertino,
                                            );
                                          }else{
                                            snack("The SOL amount you entered exceeds your balance", context);
                                          }
                                        },
                                        child: Container(

                                          decoration: BoxDecoration(color: active,
                                              borderRadius: BorderRadius.circular(20)),
                                          alignment: Alignment.center,
                                          width: double.maxFinite,
                                          padding: EdgeInsets.symmetric(vertical: 16),
                                          child: CustomText(
                                            color: Colors.white,
                                            text: "Confirm Swap",
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10)

                                  ],
                                ),
                              ),
                            );
                          }):snack("Enter the amount of SOL you want to swap", context);





                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: kDefaultPadding/2, vertical: kDefaultPadding/2),
                      child: Container(

                        decoration: BoxDecoration(color:double.parse(_solAmount)>0? active:Colors.grey,
                            borderRadius: BorderRadius.circular(20)),
                        alignment: Alignment.center,
                        width: double.maxFinite,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: CustomText(
                          color: double.parse(_solAmount)>0? Colors.white:Colors.black87,
                          text: "Review Swap",
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),





















    );
  }
}
