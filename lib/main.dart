import 'package:firebase_ui_auth/firebase_ui_auth.dart';   // Ecran d'authentification attrayant
import 'package:go_router/go_router.dart';           // Routage
import 'package:provider/provider.dart';                // Gestion de l'App state par ChangeNotifierProvider
import 'app_state.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';

void main ()  {
  WidgetsFlutterBinding.ensureInitialized() ;   // Widgets correctement configurés
  runApp ( ChangeNotifierProvider(
    create:  (context)=> ApplicationState() ,
    builder: (  (context, child) => const App() )  , ) , ) ;    }
// Connection à un notificateur de changement ; création d'un état d'App puis d'un constructeur

final _router = GoRouter (                        // Création du Routeur
  routes: [  GoRoute (                                 // 1ère route : Ecran d'accueil
    path: '/',
    builder: (context, state) => const HomeScreen(),

    routes: [ GoRoute (                                   // 2e route : Ecran de connexion
      path: 'sign-in',
      builder: (context, state) {
        return SignInScreen (                     // Panneau d'écran fourni
          actions: [
            ForgotPasswordAction(((context, email) {
              final uri = Uri(
                path: '/sign-in/forgot-password',
                queryParameters: <String, String?>{
                  'email': email,  },    );
              context.push(uri.toString());
            })),
            AuthStateChangeAction(((context, state) {
              if (state is SignedIn || state is UserCreated) {
                var user = (state is SignedIn)
                    ? state.user
                    : (state as UserCreated).credential.user;
                if (user == null) {  return; }
                if (state is UserCreated) {
                  user.updateDisplayName(user.email?.split('@')[0]);  }
                if (!user.emailVerified) {
                  user.sendEmailVerification();
                  const snackBar = SnackBar(
                      content: Text(
                          'Please check your email to verify your email address'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);    }
                context.pushReplacement('/');    }     })),
          ],
        );
      },
      routes: [  GoRoute (                             // 3e route : Ecran de renvoi du mot de passe
        path: 'forgot-password',
        builder: (context, state) {
          final arguments = state.uri.queryParameters;
          return ForgotPasswordScreen(
            email: arguments['email'],
            headerMaxExtent: 200,
          );
        },            ),
      ],         ),
      GoRoute(
        path: 'profile',
        builder: (context, state) {
          return ProfileScreen(                                   // Ecran Profil fourni
            providers: const [],
            actions: [
              SignedOutAction((context) {
                context.pushReplacement('/');
              }),
            ],
          );
        },
      ),
    ],
  ),
  ],
);





class App extends StatelessWidget {
  const App ( { super.key } ) ;
  @override
  Widget build ( BuildContext context ) {
    return  MaterialApp.router (
        debugShowCheckedModeBanner : false ,
        title : 'Wedding'  ,
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        routerConfig: _router )  ;  }   // Connexion au routeur
}

