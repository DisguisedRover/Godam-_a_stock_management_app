import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milk_content_analysis/bloc/signupBloc/signup_bloc.dart';
import 'package:milk_content_analysis/bloc/signupBloc/signup_event.dart';
import 'package:milk_content_analysis/bloc/signupBloc/signup_state.dart';
import '../../constants/constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _confirmPasswordFocusNode = FocusNode();
  bool _confirmPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;
  final FocusNode _emailFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();

  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _passwordVisible = false;
  String? _usernameError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _validateAndSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _emailError = null;
        _usernameError = null;
      });
      if (mounted) {
        _signUp();
      }
    }
  }

  void _signUp() async {
   BlocProvider.of<SignupBloc>(context).add(
    SignupButtonPressed(
      username: _nameController.text, 
      email: _emailController.text, 
      password: _passwordController.text, 
      confirmPassword: _confirmPasswordController.text,
      )
   );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Form(
                  key: _formKey,
                  child: BlocListener<SignupBloc, SignupState>(
                      listener: (context, state){
                        if (state is SignupSuccess){
                          Navigator.pushReplacementNamed(context, '/home');
                        } else if (state is SignupFailure){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error),));
                        }
                      },
                      child: BlocBuilder<SignupBloc, SignupState>(
                      builder: (context, state) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          // Logo Placeholder
                          // CircleAvatar(
                          //   radius: 50,
                          //   backgroundColor: Theme.of(
                          //     context,
                          //   ).colorScheme.primary,
                          //   child:
                          Image.asset(
                              appLogo,
                              width: 60,
                              height: 60,
                            ),
                          // ),
                          const SizedBox(height: 20),
                          Text(
                            'Create Account',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Sign up to get started with Milk Content Analyzer',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: _nameController,
                            focusNode: _nameFocusNode,
                            decoration: InputDecoration(
                              labelText: 'User Name',
                              hintText: 'Enter your user name',
                              errorText: _usernameError,
                              prefixIcon: Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Please enter your user name';
                              if (value.length < 3)
                                return 'Username too short (min 3 chars)';
                              if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                                return 'Only letters, numbers and underscore allowed';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              FocusScope.of(
                                context,
                              ).requestFocus(_emailFocusNode);
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter your email',
                              errorText: _emailError,
                              prefixIcon: Icon(Icons.email),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(
                                r'^[^@]+@[^@]+\.[^@]+',
                              ).hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              FocusScope.of(
                                context,
                              ).requestFocus(_passwordFocusNode);
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                              ),
                            ),
                            obscureText: !_passwordVisible,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Please enter a password';
                              if (value.length < 8)
                                return 'Password must be at least 8 characters';
                              if (!value.contains(RegExp(r'[A-Z]'))) {
                                return 'Include at least one uppercase letter';
                              }
                              if (!value.contains(RegExp(r'[0-9]'))) {
                                return 'Include at least one number';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              FocusScope.of(
                                context,
                              ).requestFocus(_confirmPasswordFocusNode);
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _confirmPasswordController,
                            focusNode: _confirmPasswordFocusNode,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              hintText: 'Re-enter your password',
                              prefixIcon: const Icon(Icons.lock_reset),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _confirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _confirmPasswordVisible =
                                        !_confirmPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            obscureText: !_confirmPasswordVisible,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) {
                              _validateAndSignUp();
                            },
                          ),
                          const SizedBox(height: 10),
                          Column(
                            children: [
                              state is SignupLoading
                                  ? const CircularProgressIndicator()
                                  : SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        onPressed: _validateAndSignUp,
                                        child: const Text('Sign Up'),
                                    )
                                  )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account?"),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Login'),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                      )   
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
