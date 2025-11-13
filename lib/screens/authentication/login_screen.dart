import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milk_content_analysis/bloc/loginBloc/login_bloc.dart';
import 'package:milk_content_analysis/bloc/loginBloc/login_event.dart';
import '../../bloc/loginBloc/login_state.dart';
import '../../constants/constants.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  // final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _passwordVisible = false;
  final TextEditingController _usernameController = TextEditingController();
  // Focus nodes to manage keyboard focus

  final FocusNode _usernameFocusNode = FocusNode();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<LoginBloc>(context).add(
        LoginButtonPressed(
          username: _usernameController.text,
          password: _passwordController.text,
        ),
      );
    }
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
                  child: BlocListener<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        Navigator.pushReplacementNamed(context, '/home');
                      } else if (state is LoginFailure) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.error)));
                      }
                    },

                    child: BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
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
                                // color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            // ),
                            const SizedBox(height: 20),
                            Text(
                              'Welcome Back!',
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Sign in to continue to Godam',
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 30),
                            TextFormField(
                              controller: _usernameController,
                              focusNode: _usernameFocusNode,
                              decoration: const InputDecoration(
                                labelText: 'Username or Email',
                                hintText: 'Enter your username or email',
                                prefixIcon: Icon(Icons.person_2),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your usermane or email';
                                }
                                // if (!RegExp(
                                //   r'^[^@]+@[^@]+\.[^@]+',
                                // ).hasMatch(value)) {
                                //   return 'Please enter a valid email address';
                                // }
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
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
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
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) {
                                _login();
                              },
                            ),
                            const SizedBox(height: 10),
                            Column(
                              children: [
                                state is LoginLoading
                                    ? const CircularProgressIndicator()
                                    : SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: _login,
                                          child: const Text('Login'),
                                        ),
                                    )
                              ]
                            ),

                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Forgot password functionality not implemented yet.',
                                      ),
                                    ),
                                  );
                                },
                                child: const Text('Forgot Password?'),
                              ),
                            ),

                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't have an account?"),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/signup');
                                  },
                                  child: const Text('Sign Up'),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
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
