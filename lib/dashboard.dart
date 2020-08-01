import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:savemynationpartner/condata.dart';
import 'package:savemynationpartner/globals.dart';
import 'package:savemynationpartner/loading.dart';
import 'package:savemynationpartner/netcheckdialogue.dart';
import 'package:savemynationpartner/shared.dart';
import 'package:savemynationpartner/showLocationdialogue.dart';
import 'package:savemynationpartner/view.dart';
import 'package:savemynationpartner/widget/my_header.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'constants.dart';



class DashBoard extends StatefulWidget {
  @override
  _DashBoard createState() => _DashBoard();
}
class _DashBoard extends State<DashBoard> {
  final controller = ScrollController();
final Location location = Location();
bool _serviceEnabled;
PermissionStatus _permissionGranted;
LocationData _locationData;

var val = 0;
  var refreshtext='';
  double km;
  int km1;
 String img='';
 //final Distance distance = new Distance();
  
  double offset = 0;
  bool isReplay = false;
  bool fCard = false;
  Future<List> a;
  List lis = [];
  int foodconcerns =0;
  int groceryconcerns =0;
  int medicalconcerns=0;

  @override
  void initState() {
   
    super.initState();
    controller.addListener(onScroll);
  
    getLocation();
    if(val == 0){
     refreshtext = "Refresh";
    }
    
  }
  void getLocation() async {
_serviceEnabled = await location.serviceEnabled();
if (!_serviceEnabled) {
  _serviceEnabled = await location.requestService();
  if (!_serviceEnabled) {
    return;
  }
}
_permissionGranted = await location.hasPermission();
if (_permissionGranted == PermissionStatus.denied) {
  _permissionGranted = await location.requestPermission();
  if (_permissionGranted != PermissionStatus.granted) {
    
    return;
  }
  if(_permissionGranted == PermissionStatus.granted) {
   
     
    return;
  }
}

_locationData = await location.getLocation();
print(_locationData.latitude);
SharedPreferences prefs = await SharedPreferences.getInstance();
prefs.setString('latitude', _locationData.latitude.toString());
prefs.setString('longitude', _locationData.longitude.toString());




}
 
   Future<List<ConData>> fun() async {
     lis.clear();
     foodconcerns =0;
     groceryconcerns=0;
     medicalconcerns=0;
     print("Fun function result\n");
     print(_permissionGranted);
     print(checknet);
   setState(() {
     loading = true;
   }); 
   getLocation();

  try{
                final result = await InternetAddress.lookup('google.com');
                     if(result.isNotEmpty && result[0].rawAddress.isNotEmpty){
                       checknet ="connected";
                     }
                     }on SocketException catch(_){
                     print("Not connected");
                     checknet ="notconnected";
                    
                   }
                
                 if(checknet == "connected"){

                     if(_permissionGranted == PermissionStatus.granted){
                     
                      
   
   

    a = fetchData();
    await a.then((value) {
      for (int i = 0; i < value.length; i++) {
        ConData s = new ConData(
          name: value[i]['name'],
          mobile:value[i]['mobile'],
          address: value[i]['address'],
          district: value[i]['district'],
          state: value[i]['state'],
          type: value[i]['type'],
          comments:value[i]['comments'],
          devicelatitude:value[i]['device_latitude'],
          devicelongitude:value[i]['device_longitude'],
        );
        lis.add(s);
       
        print(s.type);
        print(lis.length);
        
        if(s.type == 'Food'){
          foodconcerns=foodconcerns+1;
        }
        else if(s.type == 'Grocery'){
          groceryconcerns=groceryconcerns+1;
        }
        else if(s.type == 'Medicine'){
          medicalconcerns=medicalconcerns+1;
        }
       
        
      }
       print(lis.length);
    setState(() {
      loading=false;
    });
    });}
  else{
      showLocation(context);
      
      getLocation();
     
    }}
    else{
    print("111");
      shownet(context);
      
    }
    }
   
   
  
  
chooseImg(String s){
    if(s== 'Food')
    return 'assets/food.png';
    else if(s == 'Medicine')
    return 'assets/doclogo.png';
    else if(s== 'Grocery')
    return 'assets/grocery.jpeg';
    else
    return 'assets/food.png';
  }
  @override
  void dispose() {
    
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  String selectedValue = 'hi';
  String searchStatusMobile;

  var f = 0;
  
  

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            elevation: 5,
            contentPadding: EdgeInsets.all(20),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () => SystemNavigator.pop(),//Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
              SizedBox(width: 16),
            ],
          ),
        ) ??
        false;
  }

 

  LinearGradient lg1 = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Colors.green[700], Colors.green[400], Colors.green[700]],
  );
   Widget getWidget(double ht, double wt, LinearGradient lg, int i, String tit) {
    return 
      Center(child:Container(
        height: wt / 4.2,
        width: wt / 4.1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black87, width: 1.5),
          //gradient: lg,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
           
            SizedBox(height:wt/100),
            Text(tit,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: wt / 35,
                    fontFamily: 'Poppins')),
          ],
        ),)
        //color: Colors.orange,
      
    );
  }

  @override
  Widget build(BuildContext context) {
     MediaQueryData queryData = MediaQuery.of(context);
    double ht = queryData.size.height;
    double wt = queryData.size.width;
       ListTile makeListTile(ConData con) => ListTile(
         title: Row(
              
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width:10,
                ),
                CircleAvatar(
                  
               backgroundImage: AssetImage(chooseImg(con.type)),
                radius: 30,
                backgroundColor: Color.fromRGBO(0, 74, 173, 1),
              ),
              SizedBox(width:8),
               Expanded(child:Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children:<Widget>[
                   SizedBox(height: 10,),
                 con.name.length<10 ?Text(con.name,style: TextStyle(fontSize: wt/25,fontWeight: FontWeight.w900),)
                 :Text(con.name.replaceRange(10, con.name.length, '....'),style: TextStyle(fontSize: wt/25,fontWeight: FontWeight.w900),),
                Text(con.type,style:TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: wt/30)),
               Text(con.address+","+con.district+".",style: TextStyle
               (fontWeight: FontWeight.w500,
               color: Colors.grey,
               fontSize: wt/40),),
                
               /*Row(
                  children:<Widget>[
                  
                  Icon(Icons.location_on,color:Colors.blue,size: 20,),
                  Text(km1.toString()+"Km",style:TextStyle(fontSize: wt/45,
                  fontWeight: FontWeight.bold,color: Colors.blue))]),
               
               
              
                 ]*/
                  ] ),),
            IconButton(
              icon: Icon(Icons.arrow_right,
              size:40,color:Colors.black,
            ),
            onPressed: () async{
              print("concerns latitude:${con.devicelatitude}");
              print("concerns longititude:${con.devicelongitude}");
              Fluttertoast.showToast(msg:'You can view '+con.name+'Location and Profile',toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,timeInSecForIosWeb: 1,backgroundColor: Colors.white,
                      textColor: Colors.blue,fontSize: wt/28);
           Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>
                    ViewPage(con.name,con.mobile,con.address,con.district,con.state,con.type,con.comments,con.devicelatitude,con.devicelongitude)));
  
                                        
           
            },
            )
               ]) );
     Container makeCard(ConData con) => Container(
         decoration: bd3,
          
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),
         
           
            child:makeListTile(con),
          
     );

      final makeBody = ListView.builder(
      
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width / 25,
          horizontal: MediaQuery.of(context).size.width / 30),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: lis.length,
      itemBuilder: (BuildContext context, int index) {
        return makeCard(lis[index]);
      },
    );
    
  
   
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        
        body: SingleChildScrollView(
          controller: controller,
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              MyHeader(
                image: "assets/icons/Drcorona.svg",
                textTop: "All you need",
                textBottom: "stay at home.",
                offset: offset,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                       
                          RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Dashboard\n",
                                style: kTitleTextstyle,
                              ),
                            ],
                          ),
                        ),
                       
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 30,
                            color: kShadowColor,
                          ),
                        ]
                      ),
                      child: Column(
                        crossAxisAlignment:CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child:RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Total Concerns : ${lis.length}\n",
                                style: kTitleTextstyle,
                              ),
                            ],
                          ),
                        ),
                          ),
                         Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                             // getWidget(ht, wt, lg1, 6, 'TotalConcerns: 20'),
                             getWidget(ht, wt, lg1, 1,
                                  'Grocery : '+groceryconcerns.toString()),
                            getWidget(ht, wt, lg1, 3, 'Medicine : '+medicalconcerns.toString()),
                              getWidget(ht, wt, lg1, 4, 'Food : '+foodconcerns.toString()),
                            ],
                          ),
                          SizedBox(
                            height: wt / 20,
                          ),
                          /*Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              getWidget(ht, wt, lg1, 3, 'Medical :20'),
                              getWidget(ht, wt, lg1, 4, 'Food :20'),
                       
                            ],
                          ),*/
                        ],
                      ),
                    ),
                    SizedBox(height: wt / 15),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Concerns Details\n",
                                style: kTitleTextstyle,
                              ),
                            ],
                          ),
                        ),
                         Column(
                           children:<Widget>[
                           IconButton(
                          onPressed: () async{
                            
                            setState(() {
                              val=1;
                              print('refresh status');
                              print(refresh);
                             
                             fun();
                          

                             
                            });
                          },
                          icon:Icon(Icons.refresh,size:30,color: Colors.black,),
                          ),
                          SizedBox(child: Text(val == 0 ? refreshtext:'',style:TextStyle(
                            fontSize: wt / 25,
                            fontFamily: "Poppins",
                            color: Colors.black,
                            fontWeight: FontWeight.bold 
                          ,),
                            ) ) ])
                      ],
                    ),
                   
    
                     loading
            ? Loading():makeBody,
             SizedBox(height: wt / 15),

                   
                  ],
                ),
              ),
             
            ],
          ),

        ),
      ),
    );

 
  }
  Future<List> fetchData() async {
    
  try{
  // var time1 = DateTime.now().millisecondsSinceEpoch;
  // var time;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("details\n\n");
    print(prefs.getString('longitude'));
     print(prefs.getString('latitude'));
      print(prefs.getString('mobno'));
       print(prefs.getString('stoken'));
     
  String listurl = 'https://api.savemynation.com/api/partner/savepartner/getlistofneeds';
Map data={
'mobile': prefs.getString('mobno'),
'homeLatitude':prefs.getString('latitude'),
'homeLongitude':prefs.getString('longitude'),
'deviceToken':prefs.getString('stoken'),
};
print("before url");
var response = await http.post(listurl,
  
  headers: {"Content-Type":"application/x-www-form-urlencoded"},
  body: data,
  encoding: Encoding.getByName("gzip"));
  print("before url1");
    print(response.body);
   setState(() {
      refresh = false;
      
   });
    print("Time");
     // time = DateTime.now().millisecondsSinceEpoch - time1;
       //print(DateTime.now().millisecondsSinceEpoch - time1);
       
    
       var reBody = json.decode(response.body)['messages'];
     
      
      return reBody;
  }
   
    catch(e)
    {
     
    
      print("Exception");
      setState(() {
        loading=false;
      });
     
                 if(checknet == "notconnected"){
                  
                   shownet(context);
                 }
                
                     if(_permissionGranted !=PermissionStatus.granted){
                      
                showLocation(context);
                 getLocation();
                     }
                
                 
     
      throw Exception('Failed to Load..');
    }
  
   
   
  }
 
  
}


