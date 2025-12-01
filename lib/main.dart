import 'package:acacia/firebase_options.dart' show DefaultFirebaseOptions;
import 'package:acacia/tela_principal.dart';
import 'package:acacia/cadastro/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;

const SUPABASE_URL = 'https://uovqebbnuehlnddehoyx.supabase.co';
const SUPABASE_ANON_KEY =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVvdnFlYmJudWVobG5kZGVob3l4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQyNzgxOTEsImV4cCI6MjA3OTg1NDE5MX0.PPgEcDu2G6pz5GKawjs4P2UWXnuyk33qGbIMJUEf_bU';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: SUPABASE_URL,
    anonKey: SUPABASE_ANON_KEY,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  // Página que inicia tudo
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Acácia App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.yellow),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.hasData ? const TelaPrincipal() : const Login();
        },
      ),
    );
  }
} 