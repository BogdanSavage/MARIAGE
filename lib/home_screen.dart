import 'package:flutter/material.dart';
import 'package:wedding/guest_book.dart';
import 'package:wedding/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'authentication.dart';
// import 'guest_book.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen ( {super.key} ) ;

  @override
  Widget build ( BuildContext context ) {
    return Scaffold (
      appBar: AppBar (  title:  const Text ( ' NOTRE MARIAGE' )    ,
                        centerTitle: true,      ) ,
      body:  Center (child: Column(
      children: <Widget> [
        Image.asset('assets/wedding.png' , height: 110,),
        const SizedBox( height: 6 ,) ,
        const IconAndText (Icons.location_city_outlined, 'Roeux') ,
        const SizedBox( height: 6 ,) ,
        const IconAndText ( Icons.calendar_today,'15 Avril'  ) ,

        Consumer<ApplicationState>(
          builder: (context,appState, _) => AuthFunc(
              loggedIn: appState.loggedIn,
              signOut: () { FirebaseAuth.instance.signOut() ;} ),),

        const SizedBox( height: 10 ,) ,
        const Text (' Nous nous marions , rejoignez-nous ! ' , style: TextStyle(fontSize: 18),) ,

        Consumer<ApplicationState>(
          builder: (context, appState, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (appState.loggedIn) ...[   // ... est un SPREAD opérateur dans DART
                          const Text('   Ecrivez-nous un message:'),
                          GuestBook( addMessage: (message) => appState.addMessageToGuestBook(message),
                                      messages: appState.guestBookMessages,),
                           
                                      ]
                      ]),), ],) ,),)  ;
        //child: ),);
        // Image.network('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg')
         }  }

         // Le Message est envoyé dans FireBase / CloudFirestore