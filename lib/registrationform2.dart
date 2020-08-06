import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:imei_plugin/imei_plugin.dart';
import 'package:location/location.dart';
import 'package:savemynationpartner/checknetconnectivity.dart';
import 'package:savemynationpartner/dashboard.dart';
import 'package:savemynationpartner/constants.dart';
import 'package:savemynationpartner/fluttertoastmsg.dart';
import 'package:savemynationpartner/globals.dart';
import 'package:savemynationpartner/homepage.dart';
import 'package:savemynationpartner/netcheckdialogue.dart';



import 'package:savemynationpartner/shared.dart';
import 'package:savemynationpartner/showLocationdialogue.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RegisterForm2 extends StatefulWidget {
  @override
  _RegisterForm2 createState() => _RegisterForm2();
}


class _RegisterForm2 extends State<RegisterForm2> {
  
  //For subscription to the ConnectivityResult stream
 
  
   FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
final Location location = Location();
bool _serviceEnabled;
PermissionStatus _permissionGranted;
LocationData _locationData;
  String professional='',contribution='';
  String _dropDownValue,_dropDownValueC ;
  FocusNode focusprof,contrifocus;
  bool validateP =false;
  bool validateC = false;
  String _platformImei = 'Unknown';
  String uniqueId = "Unknown";
  var sessionToken='';
 String lat,long;
  String errP = '';
  String errC='';
  String firebaseToken;
   getLocation() async {

     _permissionGranted = await location.hasPermission();
 print("Permission status:");
print(_permissionGranted);
//toast(context, "Permission Status :$_permissionGranted");
if (_permissionGranted == PermissionStatus.denied) {
  _permissionGranted = await location.requestPermission();
  if (_permissionGranted != PermissionStatus.granted) {
 
    return;
  }
  if(_permissionGranted == PermissionStatus.granted) {
    
    return;
  }


}
print("permisision status:");
print(_permissionGranted);
//toast(context, "Permission Status :$_permissionGranted");
if(_permissionGranted == PermissionStatus.granted){
_serviceEnabled = await location.serviceEnabled();
print("SeevicEnabled:");
print(_serviceEnabled);
//toast(context,"Service enabled status: $_serviceEnabled");
if (!_serviceEnabled) {
  _serviceEnabled = await location.requestService();
  if (!_serviceEnabled) {
    //showLocation(context);
     print("after request press nothanks!!");
  print(_serviceEnabled);
  if(_serviceEnabled == false){
    showLocation(context);
    print("showlocationok:");
    print(showlocationok);
  
   
  }
 
    return;
  }
 
  
 
}

}
else{
  toast(context,"This app requires Location services!! \n Kindly Allow it!");
  getLocation();
}

_locationData = await location.getLocation();
print(_locationData.latitude);
SharedPreferences prefs = await SharedPreferences.getInstance();
prefs.setString('latitude', _locationData.latitude.toString());
prefs.setString('longitude', _locationData.longitude.toString());

return;
}
 

  
Future<http.Response> _postRequest() async {

      SharedPreferences prefs = await SharedPreferences.getInstance();
    print("\n\nMy contribution is:" + prefs.getString('contribution'));
    Map data = {
      'name' :prefs.getString('name'),
    'mobile':prefs.getString('mobno'),
      'address' :prefs.getString('address'),
      'state' : prefs.getString('state'),
      'district': prefs.getString('district'),
      'professional': prefs.getString('professional'),
      'device_latitude':prefs.getString('latitude'),
      'device_longitude':prefs.getString('longitude'),
      'email': prefs.getString('email'),
      'profileUrl' : prefs.getString('url'),
      'deviceType':'mobile',
      'firebaseToken':firebaseToken,
      'contribution':prefs.getString('contribution'),
      'imei':prefs.getString('imei'),
    };
    //encode Map to JSON
    //String body = json.encode(data);
    var sendResponse = await http.post(
        'https://api.savemynation.com/api/partner/savepartner/registervolunteer',
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: data,
        encoding: Encoding.getByName("gzip"));
        print('result');
        sessionToken = json.decode(sendResponse.body)['deviceToken'];
        print(sessionToken);
       //toast(context,"Sessiontoken : $sessionToken");
        prefs.setString('stoken', sessionToken);
     
       
        print(firebaseToken);
        //toast(context,"Firebasetoen is :$firebaseToken");
        
    setState(() {
      print(sendResponse.body);
    });
    return sendResponse;
  }
 

   firebaseCloudMessaging() async {
      String token = await _firebaseMessaging.getToken();
     
      firebaseToken = token;
    }
@override
void initState(){
  super.initState();
  // initPlatformState();
   firebaseCloudMessaging();
  
  
focusprof = FocusNode();
contrifocus = FocusNode();
}
@override
void dispose(){
  
  focusprof.dispose();
  contrifocus.dispose();
  super.dispose();
}


  @override 
  Widget build(BuildContext context){

    MediaQueryData queryData = MediaQuery.of(context);
    double ht = queryData.size.height;
    double wt = queryData.size.width;
   
   if(checknet == 'connected'){
     getLocation();
   }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Save My Nation Partner",
      color:color,
      home:Scaffold(
      body:Container(
        padding: EdgeInsets.all(8.0),
        color:color,
        height: ht,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(

                height: ht/2.5,
                child: SafeArea(child:Image.asset('assets/v6.png',height: ht/4,width:wt/1.2 ,),),
               ), SizedBox(height: ht/10,),
               Text(
                        'Additional Details',
                        style: TextStyle(
                            fontSize: wt / 20,
                            fontFamily: "Poppins",
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                height: ht/40,
              ),
              Container(
                 padding: EdgeInsets.all(8.0),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:<Widget>[
            
               Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      border: Border.all(color: Colors.white70,width: 2)
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: DropdownButton(
                      underline: SizedBox(),
                      focusNode: focusprof,
                      hint: _dropDownValue == null
                          ? Text('Select your Professional',
                          style:TextStyle(
                   fontSize: 14,
                            fontFamily: "Poppins",
                            color: Colors.white70,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w500
                ),)
                          : Text(
                        _dropDownValue,
                        style: TextStyle(
                   fontSize: 14,
                            fontFamily: "Poppins",
                            color: Colors.white,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w500
                ),
                      ),
                      isExpanded: true,
                      iconSize: 30.0,
                      style: TextStyle(
                   fontSize: 14,
                            fontFamily: "Poppins",
                            color: Colors.white,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w500
                ),
                      items: ['Medical Professional', 'Working Professional', 'Business Professional', 'Student', 'other'].map(
                            (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(val,style:dropstyle,),
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(
                              () {
                            _dropDownValue = val;
                            professional = val;
                          focusprof.unfocus();
                          contrifocus.requestFocus();
                          },
                        );
                      },
                    ),
                  ),),),
                 SizedBox(height: 10,),
                Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0),
                child:Text(errP,
              textAlign: TextAlign.start,              
              style:errorstyle),),
              SizedBox(height: ht/30,),
                   Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      border: Border.all(color: Colors.white70,width: 2)
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: DropdownButton(
                      underline: SizedBox(),
                      focusNode: contrifocus,
                      hint: _dropDownValueC == null
                          ? Text('Select your Contribution',
                           style: TextStyle(
                   fontSize: 14,
                            fontFamily: "Poppins",
                            color: Colors.white70,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w300
                ),
                          )
                          : Text(
                        _dropDownValueC,
                        style: TextStyle(
                   fontSize: 14,
                            fontFamily: "Poppins",
                            color: Colors.white,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w500
                ),
                      ),
                      isExpanded: true,
                      iconSize: 30.0,
                      style: fieldstyle,
                      items: ['Call Center', 'Contact Tracking', 'Sanitation and Disinfection', 'Transportation', 'Web/Mobile App Development','Other'].map(
                            (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(val,style: dropstyle,),
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(
                              () {
                            _dropDownValueC = val;
                          contribution = val;
                          
                          contrifocus.unfocus();
                          },
                        );
                      },
                    ),
                  ),),),
                   SizedBox(height: wt/60,),
               Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0),
                child: Text(errC,
              textAlign: TextAlign.start,              
              style: errorstyle,),),
                  ])),
                
              SizedBox(height: ht/30,),
               Padding(
                padding:EdgeInsets.all(8.0),
                child:RaisedButton(
                   color: kPrimaryColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 30),
                          child: Text(
                            'Submit',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),

                        ),

                  onPressed: () async {
                       
                   errP='';
                   errC='';
                 
                  _locationData = await location.getLocation();
print(_locationData.latitude);
SharedPreferences prefs = await SharedPreferences.getInstance();
prefs.setString('latitude', _locationData.latitude.toString());
prefs.setString('longitude', _locationData.longitude.toString());
             /*   lat = prefs.getString('latitude').toString();
long = prefs.getString('longitude').toString();
toast(context,"Latitude:$lat\n Longitude:$long");*/
                       
                      
/*if(_permissionGranted == PermissionStatus.granted){
                     _locationData = await location.getLocation();
print(_locationData.latitude);
SharedPreferences prefs = await SharedPreferences.getInstance();
prefs.setString('latitude', _locationData.latitude.toString());
prefs.setString('longitude', _locationData.longitude.toString());*/
                    
                        setState(() {
                      var f2=0;
                      validateP=false;
                      validateC=false;
                      
                     
                     if(_dropDownValue == null){
                      
                          errP = "Please Select Your Professional";
                          
                          f2=1;
                    
                      }
                       if(_dropDownValueC==null){
                        setState(() {
                          f2=1;
                         
                          errC = "Please Select your contribution";
                        });
                        
                      }
                      if(f2==0){

                        checkingnet(context);
                         if(checknet == 'connected'){
                      
                           if(_permissionGranted == PermissionStatus.granted){

                          storeData();
                        _postRequest().whenComplete(() async{
                           SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool('first_time', false);
                      print('bool value changed');
                       toast(context,"Successfully registered!!!");
                        Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) =>HomePage())
                      ); });
                      }
                      else{

                        getLocation();
                      }
                     
                     
                      }
                      if(checknet == 'notconnected'){
                        shownet(context);
                      }                     
                        }});
                        
                      
                  
                   
                
                     
                     

                        
                 
                  
               })

              ) ],
          ),
        ),
      ),
     ) );



  }
  storeData() async {

print("My professional:"+professional);
print("My contribution:"+contribution);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {

      prefs.setString('professional',professional);
      prefs.setString('contribution',contribution);
    });
  }
}