import 'dart:io';

import 'package:flutter/material.dart';
import 'package:savemynationpartner/globals.dart';
import 'package:savemynationpartner/netcheckdialogue.dart';

checkingnet(BuildContext context) async {
 try{
                final result = await InternetAddress.lookup('google.com');
                     if(result.isNotEmpty && result[0].rawAddress.isNotEmpty){
                       checknet ="connected";
                     }
                     }on SocketException catch(_){
                     print("Not connected");
                     checknet ="notconnected";
                    
                   }
                   if(checknet == 'notconnected'){
                    shownet(context);
                 // checkingnet(context);
                   }
}