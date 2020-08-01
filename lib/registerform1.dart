import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:savemynationpartner/checknetconnectivity.dart';
import 'package:savemynationpartner/constants.dart';
import 'package:savemynationpartner/fluttertoastmsg.dart';
import 'package:savemynationpartner/globals.dart';
import 'package:savemynationpartner/netcheckdialogue.dart';
import 'package:savemynationpartner/registrationform2.dart';
import 'package:savemynationpartner/shared.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class RegistrationForm1 extends StatefulWidget {
  @override
  _RegistrationForm1 createState() =>_RegistrationForm1 ();
}

class _RegistrationForm1  extends State<RegistrationForm1> {
   String errD = '';
  bool _validateA = false;
  String errS = '';

  String _dropDownDistrictValue,_dropDownStateValue;
  String address, district, state;
  FocusNode addfocus,statefocus,disfocus;

  final String url = "https://api.savemynation.com/api/v1/savemynation/state";
  final String durl = "https://api.savemynation.com/api/v1/savemynation/district";
  var serverip = TextEditingController(text: '192.168.1.40');
  List<String> sdata = List();
  List<String> disdata = List();  
   Future<String> getSWData() async {  
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body)['state']; 
    print(resBody);   
    List<String> tags = resBody != null ? List.from(resBody) : null;
    setState(() {
    sdata = tags;  
    });    
    return "Sucess";

  }

Future<http.Response> postDTRequest() async{
  Map data = {'state' : state};
  print("ok");
  var response = await http.post(durl,
  headers: {'Content-Type':"application/x-www-form-urlencoded"},body: data,
  encoding: Encoding.getByName("gzip"));
  var reBody = json.decode(response.body)['district'];
  print(reBody);
    List<String> dtags = reBody != null ? List.from(reBody) :null;
  setState(() {
    disdata = dtags;
  });
  return response;
}


  @override
  void initState() {
    super.initState();
    checkingnet(context);
    if(checknet == 'connected'){
    this.getSWData();
    }
    else{
      shownet(context);
    }
    addfocus = FocusNode();
    disfocus = FocusNode();
    statefocus = FocusNode();
    
    }
    @override
void dispose(){
  addfocus.dispose();
  disfocus.dispose();
  statefocus.dispose();

  super.dispose();
}


  @override 
  Widget build(BuildContext context){
     MediaQueryData queryData = MediaQuery.of(context);
    double ht = queryData.size.height;
    double wt = queryData.size.width;
     return MaterialApp(
       debugShowCheckedModeBanner: false,
       title: "Save My Nation Partner",
       color: color,
       home:Scaffold(
      body:SingleChildScrollView(
        child:Container(
       padding: EdgeInsets.all(8.0),
       color:color,
        height: ht,
        child: SingleChildScrollView(
        
            child: Column(
              
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: ht/2.5,
                child: SafeArea(child:Image.asset('assets/v6.png',height: ht/4,width:wt/1.2 ,  ), ),     
             ), SizedBox(
                height: ht/40,
              ),

                      Text(
                        'Location Details',
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
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:<Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0),
                child: TextFormField(
                     focusNode: addfocus,
                  cursorColor: Colors.white,
                  autofocus: false,
                  autovalidate: true,
                maxLines: 2,
               textInputAction: TextInputAction.done,
                  onEditingComplete: (){
                    addfocus.unfocus();
                    statefocus.requestFocus();
                  },
                  keyboardType: TextInputType.multiline,
                onChanged: (value){
                  address = value;
                },
                style: fieldstyle,
                decoration: id.copyWith(labelText: 'Address',labelStyle:labelstyle,errorText: _validateA ? 'Address must contains atleast 6 characters' : null,errorStyle: errorstyle),
              ),
              ),            
              
              SizedBox(height: wt/20,),
               Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0),
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      border: Border.all(color: Colors.white70,width: 2)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton(
                      underline: SizedBox(),
                      focusNode: statefocus,
                      hint: _dropDownStateValue == null
                          ? Text('State',style:  labelstyle)
                          : Text(
                        _dropDownStateValue,
                       style: TextStyle(color: Colors.white),),
                       
                      
                      isExpanded: true,
                      
                      iconSize: 30.0,
                      style: fieldstyle,
                      isDense: false,                      
                      items: sdata.map(
                            (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(val,
                            style:dropstyle,
                            
                ),
                          );
                        },
                      ).toList(),
                      
                      onChanged: (val) {
                        setState(
                              () {
                            _dropDownStateValue = val;
                            state = val;
                            statefocus.unfocus();
                          disfocus.requestFocus();
                            this.postDTRequest();
                          },
                        );
                      },
                      
                    ),
                  ),
                ),
              ),
              SizedBox(height: wt/60,),
               Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0),
                child: Text(errS,
              textAlign: TextAlign.start,              
              style: errorstyle),),
              SizedBox(height: wt/40,),
               Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    border: Border.all(color: Colors.white70,width: 2)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton(
                      focusNode: disfocus,
                      underline: SizedBox(),

                      hint: _dropDownDistrictValue == null
                          ? Text('District',
                          style: labelstyle,)
                          : Text(
                        _dropDownDistrictValue,
                       style: TextStyle(color: Colors.white),
                      ),
                      isExpanded: true,
                      iconSize: 30.0,
                      style: fieldstyle,
                      items: disdata.map(
                            (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(val,
                            style:dropstyle),
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(
                              () {
                            _dropDownDistrictValue = val;
                            district = val;
                            disfocus.unfocus();
                            
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: wt/40,),
                Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0),
                child:Text(errD,
              textAlign: TextAlign.start,              
              style: errorstyle),
              )])),
              
              SizedBox(height: 4,),
             Padding(
               padding:EdgeInsets.all(8.0),
               child: RaisedButton(
                  color: kPrimaryColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 30),
                          child: Text(
                            'Next',
                            style: btnstyle,
                          ),
                        ),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),

                        ),
                onPressed: () async{
                 
               
               
                  setState(() {
                     var f1=0;
                    _validateA =false;
                    errS='';
                    errD='';
                     if(address==null || address.length <6){
                    
                      _validateA = true;
                     
                      f1=1;
                     }
                   if(_dropDownStateValue == null) {
                       
                     
                        errS = 'Please Enter your State.';
                     
                      f1=1;
                                   
                      
                    }         
                       if(_dropDownDistrictValue == null) {
                   
                    
                         errD = 'Please Enter your district.';    
                    
                      f1=1;
                                        
                                      
                    }
                   if(f1==0){
                     toast(context,"Your Address $address \n district $district \n state $state \n saved successfully!!");
                         storeData();
                       Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterForm2()),
                  );
                  
                   } }); 
                  
                 
                  
                   
                 
                                                               
                
                    
                
                     
                                       
                   
                      
                  
                   
                   

                }
               
               ))]))))));
                    }
           storeData() async {
    print(district+state+address);
     SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('address', address);
      prefs.setString('state', state);
      prefs.setString('district', district);
      
      
      
    });
   
  }    
  }
