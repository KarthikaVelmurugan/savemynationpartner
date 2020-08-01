
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:savemynationpartner/condata.dart';
import 'package:savemynationpartner/globals.dart';
import 'package:savemynationpartner/loading.dart';
import 'package:savemynationpartner/shared.dart';
import 'package:savemynationpartner/view.dart';

class Grocery extends StatefulWidget{
  List grocery =[];
  Grocery({this.grocery});
  @override 
 _Grocery createState() =>_Grocery(); 
}
class _Grocery extends State<Grocery>{
 
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
                  
               backgroundImage: AssetImage('assets/grocery.jpeg'),
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
      itemCount: widget.grocery.length,
      itemBuilder: (BuildContext context, int index) {
        return makeCard(widget.grocery[index]);
      },
    );
    
  
   
    return Scaffold(
      
        
        body: 
                     loading
            ? Center(child:Loading()):makeBody,
      
    
    );

 
  }
   

}
