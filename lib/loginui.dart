

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:savemynationpartner/checknetconnectivity.dart';
import 'package:savemynationpartner/firstscreen.dart';
import 'package:savemynationpartner/fluttertoastmsg.dart';
import 'package:savemynationpartner/globals.dart';

import 'package:savemynationpartner/shared.dart';
import 'package:savemynationpartner/sign_in.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}


class _LoginState extends State<Login> {


  final Location location = Location();

 getSignIn() async{
    await signInWithGoogle().whenComplete(() async {
    
          if(name==null) {
            Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
              //check user do googlesignin properly or not
            return Login();
              },
            ),
          );
          }
          else {
            //user signed properly
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return FirstScreen();
              },
            ),
          );  
          }
         
          
        });
 }

  

@override
void initState(){
  super.initState();

  
}
  @override
  Widget build(BuildContext context) {
   
    checkingnet(context);

   
    MediaQueryData queryData = MediaQuery.of(context);
    double ht = queryData.size.height;
    double wt = queryData.size.width;
   
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
   
    title: 'Save My Nation Partner',
    color: color,
      home: WillPopScope(
        onWillPop:_onBackPressed,
                child:MaterialApp(
                  title: "Save My Nation Partner",
                  debugShowCheckedModeBanner: false,
                  color:color,
                  home:Scaffold(
                body: 
                  Container(
                  height: ht,
                  width: queryData.size.width,
                 color: color,
                  
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(8.0),
                        height: ht/1.4,
                        width: queryData.size.width,
                        child: Image.asset('assets/v6.png',height: ht/1.4,),  ),            
                      
                      Padding(
                        padding: EdgeInsets.all(wt/10),
                        child:Container(                               
                        child:
                            _signInButton()
                          
                        ) 
                       ) ],
                  ),
                ),
              ),
      )  ));
          }
           Future<bool> _onBackPressed() {
  return showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      
      title: new Text('Are you sure?'),
      content: new Text('Do you want to exit an App'),
      actions: <Widget>[
        new GestureDetector(
          onTap: () => Navigator.of(context).pop(false),
          child: Text("NO"),
        ),
        SizedBox(height: 16),
        new GestureDetector(
          onTap: () { 
            toast(context,"Thank You For Your Collaboration!!");
            Navigator.of(context).pop(true);},
          child: Text("YES"),
        ),
      ],
    ),
  ) ??
      false;
}



        
          
          Widget _signInButton() {
            return OutlineButton(
              onPressed: () async {
               
                checkingnet(context);
               
                if(checknet == 'connected'){
                signInWithGoogle().whenComplete(() {
                  if(name==null) {
                    toast(context,"Sorry!You are not signin properly! try again!");
                    Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) {
                        return Login();
                      },
                    ),
                  );
                  }
                  else {
                    toast(context,"Successfully signin your google account!");
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return FirstScreen();
                      },
                    ),
                  );  
                 
                  
                }
                
                });}
                 
                 
              },
        
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              highlightElevation: 0,      
              borderSide: BorderSide(color: Colors.white70,width: 2),
              child: Padding(        
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: 
                      Text(
                    'Sign in with Google',
                    style:btnstyle
                  ),
                   ),
              ),
            );
          }
         
        
        
        
        }
        