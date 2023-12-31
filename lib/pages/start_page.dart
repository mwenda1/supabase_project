import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  bool _signInLoading = false;
  bool _signUpLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Sign up functionality
  // Syntax : supabse.auth.signUp(email, password)

  // Sign in functionality
  // Syntax : supabse.auth.signIn(email, password)

  @override
  void dispose() {
    supabase.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold is a layout for the major Material Components.
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.network("https://seeklogo.com/images/S/supabase-logo-DCC676FFE2-seeklogo.com.png",height: 150,),
                const SizedBox(height: 25,),
                //Email Field
                TextFormField(
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "Field is required";
                    }
                    return null;
                  },
                  controller: _emailController,
                  decoration: const InputDecoration(label: Text("Email")),
                  keyboardType: TextInputType.emailAddress,
                ),

                // Password Field
                TextFormField(
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "Field is required";
                    }
                    return null;
                  },
                  controller: _passwordController,
                  decoration: const InputDecoration(label: Text("Password")),
                  obscureText: true,
                ),
                const SizedBox(height: 25,),
                _signInLoading ? const Center(child: CircularProgressIndicator(), ): ElevatedButton(onPressed: ()async{
                  final isValid = _formKey.currentState!.validate();
                  if (isValid != true) {
                    return;
                  }
                  setState(() {
                    _signInLoading = true;
                  });
                  try{
                    await supabase.auth.signInWithPassword(email: _emailController.text, password: _passwordController.text);
                  }catch(e){
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sign In !  Please try again"), backgroundColor: Colors.red,));
                    setState(() {
                        _signInLoading = false;
                      });
                  }
                }, child: const Text("Sign in")),
                const Divider(),
                _signUpLoading ? const Center(child: CircularProgressIndicator(),): OutlinedButton(onPressed: ()async{
                  final isValid = _formKey.currentState!.validate();
                  if (isValid != true) {
                    return;
                  }
                  setState(() {
                    _signUpLoading = true;
                  });
                  try{
                    await supabase.auth.signUp(email: _emailController.text, password: _passwordController.text);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Success !  Confirmation Email Sent"), backgroundColor: Colors.green,));
                    setState(() {
                      _signUpLoading = false;
                    });
                  }catch(e){
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error !  Please try again"), backgroundColor: Colors.red,));
                    setState(() {
                        _signUpLoading = false;
                      });
                  }
                }, 
                child: const Text("Sign up"))

              ]),
          ),
          ),
        ),     
      ),
    );
  }
}

