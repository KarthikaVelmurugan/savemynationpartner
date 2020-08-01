
import 'package:flutter/services.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:savemynationpartner/fluttertoastmsg.dart';
import 'package:savemynationpartner/registerform1.dart';
import 'package:savemynationpartner/shared.dart';
import 'package:savemynationpartner/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'loginui.dart';

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}
 
class _FirstScreenState extends State<FirstScreen> {
  bool  _validaten =false;
  bool _validatem=false;
  String _platformImei = 'Unknown';
   String uniqueId = "Unknown";
  FocusNode namefocusnode,mobilefocusnode;
  String sname,mobno;
  var toastText;
  @override
  void initState() {
    super.initState();
    initPlatformState();
    namefocusnode = FocusNode();
    mobilefocusnode = FocusNode();
    

   
    setState(() {
      if (name == null) {
     toast(context,"Sorry!You are not signin properly! try again!");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    });
  }
 Future<void> initPlatformState() async {
   SharedPreferences prefs= await SharedPreferences.getInstance();
    String platformImei='unknown';
    String saveimei='unknown';
    
    String idunique='unknown';
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformImei =
          await ImeiPlugin.getImei(shouldShowRequestPermissionRationale: false); 
      idunique = await ImeiPlugin.getId();
    }on PlatformException {
      platformImei = "Failed to get platform version";
      toast(context, "This App requires phone/call management!!\nKindly allow it");
      initPlatformState();
      }
      

   
    if (!mounted) return;

    setState(() {
      print(idunique);
      _platformImei = platformImei;
      uniqueId = idunique;
      saveimei = uniqueId;
      prefs.setString('imei',saveimei);
      print(_platformImei);
      
    });
  }
@override
void dispose(){
  namefocusnode.dispose();
  mobilefocusnode.dispose();
  super.dispose();
}

  
  @override
  Widget build(BuildContext context) {
   


    if (name == null) {
     toast(context,"Sorry!You are not signin properly! try again!");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    }
    MediaQueryData queryData = MediaQuery.of(context);
    double wt = queryData.size.width;
     
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Save My Nation Partner",
      color: color,
      home:Scaffold(
            body :SingleChildScrollView(
              child:Container(
                height: queryData.size.height,
                color:color,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(height: wt/20),
                      Container(
                        child:SafeArea(child:Image(
                          image: AssetImage(
                            'assets/v6.png',
                          ),
                          height: queryData.size.height/4,
                          width: wt,
                        ),
                      ),),
                      SizedBox(height: wt/5),
                      Container(
                        child:Column(
                          children:<Widget>[
                      Text(
                        'Hello $name !',
                        style: TextStyle(
                            fontSize: wt / 12,
                            fontFamily: "Poppins",
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),

                      SizedBox(height:5),


                     
                     
                       
                      ]),),
                       Container(
                         child:Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children:<Widget>[
                       Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0),
                child: TextFormField(
                  
                  cursorColor: Colors.white,
                  focusNode: namefocusnode,
                onFieldSubmitted: (String value){
                  namefocusnode.unfocus();
                  mobilefocusnode.requestFocus();
                },
                onChanged: (value){
                  sname = value;
                },
                style: fieldstyle,
                decoration: id.copyWith(labelText: 'Name',labelStyle: labelstyle,errorText: _validaten ? 'Name must contains atleast 4 characters' : null,errorStyle: errorstyle,
                 ),
              ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:20.0),
                child: TextFormField(  
                  focusNode: mobilefocusnode,           
                    cursorColor: Colors.white,     
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  onFieldSubmitted: (String val){
                    mobilefocusnode.unfocus();
                  },
                onChanged: (value){
                  mobno = value;
                  
                },
                style: fieldstyle,
                decoration: id.copyWith(labelText: 'Mobile Number',labelStyle: labelstyle,errorText: _validatem ==true ? 'Invalid Mobile Number' : null,errorStyle: errorstyle),
              ),
              ),])),

                  Padding(
                    padding:EdgeInsets.all(8.0),

               child: RaisedButton(
                  
                        onPressed: () async {
                          
                 
                       
                          setState(() {
                           
                          var f= 0;
                         _validaten =false;
                         _validatem=false;

                                                
                   if(sname==null || sname.length<4){
                     
                      _validaten = true;
                    
                      f = 1;
                      
                    }
                   if(mobno==null || (mobno.length<10)) {
                      _validatem = true;
                     
                    
                      f =1;
                    }
                    if(f==0)
                    {
                      toast(context,"Your $name and Mobile $mobno saved!");
                     storeData();          
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>RegistrationForm1()
                    ),
                  );
                 
                  
                          }  });
                          
                        },

                        color: kPrimaryColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 30),
                          child: Text(
                            'Next',
                            style:btnstyle
                          ),
                        ),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),

                        ),
                      )
                   ) ],
                  ),
                ),
              ),
            
     ) ));
  }
  storeData() async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){

    prefs.setString('sname', name);
    prefs.setString('email', email);
    prefs.setString('url', imageUrl);
    prefs.setString('name', sname);
      prefs.setString('mobno', mobno);
    });
    
        
  }
}