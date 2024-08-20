import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthFunc extends StatelessWidget {   // Widget pour fonction d'authentification
  const AuthFunc( { super.key,  required this.loggedIn,  required this.signOut,  } ) ;  // 3 paramètres
  final bool loggedIn;    //  Booléen indiquant si l'utilisateur est connecté ou non
  final void Function() signOut; // Fonction de déconnexion

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding (
          padding: const EdgeInsets.only(left: 24, bottom: 8),
          child: ElevatedButton (             // Bouton affichant RSVP ou Déconnection
              onPressed: () { !loggedIn     ?    context.push('/sign-in')    :     signOut();        },
                                           // Si non connecté , naviguer vers  /sign-in ; sinon lancer sign-out
              child: !loggedIn   ? const Text('RSVP')     :     const Text('Logout')  ),  ),

        Visibility (                              //  Widget permettant de se connecter directement si visible
          visible: loggedIn,              // Affiche le bouton seulement si utilisateur connecté
          child: Padding (
            padding: const EdgeInsets.only(left: 24, bottom: 8),
            child: ElevatedButton (
                onPressed: () { context.push( '/profile' );     },
                // Navigation vers la route  '/profile'
                child: const Text('Profil') ),
          ),         )      ],     );     }     }
