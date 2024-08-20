import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'  hide EmailAuthProvider, PhoneAuthProvider ;                       // Authentication
                        // Lot d'outils dont 2 cachés pour qu'ils n'écrasent pas d'autres importations
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
                // firebase_ui_auth : Package fournissant une interface pour se connecter
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';  // Connexion à FireStore
import 'guest_book_message.dart';
import 'dart:async';

class ApplicationState extends ChangeNotifier {                   // ChangeNotifier permet d'ajouter des listeners
  ApplicationState() {  init ();  }                                                        // Instanciation

  bool _loggedIn = false ;                                             // Booléen : connecté ou pas
  bool get loggedIn => _loggedIn ;                            // Fonction de vérification de la connexion

  Future <void> init() async {                                      //  Fonction d'initialisation
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);             // FireBase pour toute plateforme

    FirebaseUIAuth.configureProviders( [EmailAuthProvider()] );

    FirebaseAuth.instance.userChanges().listen( (user) {                // Écoute d'un évènement
      if (user != null) {                                                     // S'il y a un utilisateur
        _loggedIn = true ;                                               // la connection est true
        _guestBookSubscription = FirebaseFirestore.instance              // Abonnement
            .collection('guestbook')                                     // Collection choisie
            .orderBy('timestamp', descending: true)                      // Critère de rangement
            .snapshots()                                                 // Instantanés
            .listen((snapshot) {                                         // Ecoute des instantanés
          _guestBookMessages = [];                                       // Liste d'abord vide
          for (final document in snapshot.docs) {                        // Remplissage de la liste
            _guestBookMessages.add(GuestBookMessage(
              name: document.data()['name'] as String,                   // Appel des champs choisis
              message: document.data()['text'] as String,
            )); }
          notifyListeners();                                              // Prévenir les listeners
        });
      } else {
        _loggedIn = false ;                                     // pas de connexion
        _guestBookMessages = [];                                // Liste de messages vide
        _guestBookSubscription?.cancel(); }                     // Désabonnement
      notifyListeners();                                      // Notification envoyée aux listeners
    });
  }

  Future<DocumentReference> addMessageToGuestBook(String message) {  // Ecrire vers FireStore
    if (!_loggedIn) {throw Exception('Doit être enregistré pour voir les messages'); }      // Si pas enregistré
    return FirebaseFirestore.instance                           // Appel à FireStore
        .collection('guestbook')                                // Choix de la collection
        .add(<String, dynamic>{                                 // Ajouts 
      'text': message,                                          // du Texte
      'timestamp': DateTime.now().millisecondsSinceEpoch,       // Horodatage
      'name': FirebaseAuth.instance.currentUser!.displayName,   // Nom Utilisateur
      'userId': FirebaseAuth.instance.currentUser!.uid,});      // Id Utilisateur
  }
  
  // Lecture des messages dans FireStore
  StreamSubscription<QuerySnapshot>? _guestBookSubscription;    // Abonnement 
  List<GuestBookMessage> _guestBookMessages = [];               // Liste des messages ( d'abord vide )
  List<GuestBookMessage> get guestBookMessages => _guestBookMessages; // Liste des messages ( getter )

}
