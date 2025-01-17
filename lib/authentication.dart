import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthFunc extends StatelessWidget {
  const AuthFunc({super.key, required this.loggedIn, required this.signOut});

  final bool loggedIn;
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Padding(
          padding: const EdgeInsets.all(8),
          child: ElevatedButton(
              onPressed: () {
                !loggedIn ? context.push('/sign-in') : signOut();
             },
              child: !loggedIn ? const Text('RSVP') : const Text('Sortie'))),
      Visibility(

          visible: loggedIn,
          child: Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                  onPressed: () {
                    context.push('/profile');
                  },
                  child: const Text('Profile'))))
    ]);
  }
}
