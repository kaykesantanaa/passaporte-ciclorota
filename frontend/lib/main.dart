import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// 1. IMPORTAR O FIREBASE AUTH
import 'package:firebase_auth/firebase_auth.dart'; 
import 'firebase_options.dart';

// (As 5 linhas de inicialização que fizemos antes)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Passaporte Ciclorota', // Mudei o título
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      // 2. EM VEZ DE 'home', VAMOS USAR UM STREAMBUILDER
      home: StreamBuilder<User?>(
        // 3. "OUVINDO" AS MUDANÇAS DE AUTENTICAÇÃO
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          
          // Se estiver carregando (verificando o login)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // 4. SE snapshot TEM DADOS (data), O USUÁRIO ESTÁ LOGADO
          if (snapshot.hasData) {
            // Mande-o para a tela principal do app
            return const HomePage(); // <-- (Criaremos esta tela)
          }

          // 5. SE NÃO TEM DADOS, O USUÁRIO ESTÁ DESLOGADO
          // Mande-o para a tela de login
          return const LoginPage(); // <-- (Criaremos esta tela)
        },
      ),
    );
  }
}


// --- CRIE ESSAS NOVAS TELAS (Pode ser em arquivos separados) ---

// TELA DE LOGIN (Exemplo simples)
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          // AQUI VOCÊ CHAMARIA A FUNÇÃO DE LOGIN
          // Ex: FirebaseAuth.instance.signInWithGoogle()
          onPressed: () { 
            // Lógica de login (ex: Google, Email/Senha)
          },
          child: const Text('Fazer Login com Google'),
        ),
      ),
    );
  }
}

// TELA PRINCIPAL (A sua antiga MyHomePage)
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Pega o usuário que está logado
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Bem-vindo, ${user?.displayName ?? "Usuário"}'), // Mostra o nome do usuário
        actions: [
          // Botão de Sair
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
      body: const Center(
        child: Text('Você está logado!'),
      ),
    );
  }
}