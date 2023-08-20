import 'package:flutter/material.dart';
import "package:supabase_flutter/supabase_flutter.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:supabase_project/pages/home.dart";
import "package:supabase_project/pages/start_page.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load dotenv
  await dotenv.load();
  // Initialize Supabase

  String supabaseUrl = dotenv.env["SUPABASE_URL"] ?? "";
  String supabaseKey = dotenv.env["SUPABASE_KEY"] ?? "";
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Supabase Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthPage(),
    );
  }
}

class AuthPage  extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  User? _user;

  @override
  void initState() {
    super.initState();
    getAuth();
  }

  // To get current user
  Future<void> getAuth()async{
    final User? user = supabase.auth.currentUser;
    setState(() {
      _user = user;
    });
    supabase.auth.onAuthStateChange.listen((event) { 
      setState(() {
        _user = event.session?.user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _user == null ? const StartPage() : HomePage();
  }
}
