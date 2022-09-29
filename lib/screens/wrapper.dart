
import 'package:provider/provider.dart';
import 'package:crud_app/screens/home/home.dart';
import 'package:flutter/material.dart';

import '../models/FirebaseUser.dart';
import 'authenticate/handler.dart';

class Wrapper extends StatelessWidget{
  
  @override
  Widget build(BuildContext context) {
    
    final user =  Provider.of<FirebaseUser?>(context);
     if(user == null)
     {
       return Handler();
     }else
     {
       return HomePage();
     }

  }
} 