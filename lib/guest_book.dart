import 'dart:async';
import 'package:flutter/material.dart';
//import 'widgets.dart';                              // Si besoin d'importer des icônes
import 'guest_book_message.dart';


class GuestBook extends StatefulWidget {
  const GuestBook(                                  // Constructeur
      {required this.addMessage,required this.messages, super.key});       
      // addMessage : le message écrit  , messages : la liste des messages dans FireStore
  
  final FutureOr <void> Function(String message) addMessage;
  final List<GuestBookMessage> messages;
  
  @override
  State<GuestBook> createState() => _GuestBookState(); }   

class _GuestBookState extends State<GuestBook> {        // Etat
                                                                           // Variables initiales
  final _formKey = GlobalKey<FormState> (debugLabel: '_GuestBookState');   // Clef de Formulaire 
  final _controller = TextEditingController();                             // Contrôleur
  
  @override
  Widget build(BuildContext context) {
     return Column (
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
      Padding (
          padding: const EdgeInsets.all(8),
          child: Form (
              key: _formKey,
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                      controller: _controller,
                      decoration: const InputDecoration(hintText: 'Ecrivez ici !'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {                // Erreur si pas de message
                          return 'Enter your message to continue';
                        }
                        return null;
                      },
                    )),
                const SizedBox(width: 8),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await widget.addMessage(_controller.text);
                        _controller.clear();
                      }
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.send),
                        SizedBox(width: 4),
                        Text('ENVOI'), ], ))
                          ]))),
      const SizedBox (height: 8),
      for (var message in widget.messages)               // Affichage des messages contenus dans FireStore
        Text('${message.name}: ${message.message}'),
      const SizedBox(height: 8), ]);
  }}
