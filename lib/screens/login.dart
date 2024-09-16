import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:try2win/business/app_firestore.dart';
import 'package:try2win/providers/customer_notifier.dart';
import 'package:try2win/providers/seller_view_notifier.dart';

final _firebase = FirebaseAuth.instance;

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _formEmail = GlobalKey<FormFieldState>();

  final TextEditingController _pass = TextEditingController();

  var _isLogin = true;
  String _enteredEamil = '';
  String _enteredPassword = '';
  String _confirmPassword = '_';

  void _submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    ref.read(customerProvider.notifier).resetCustomer();
    ref.read(isSellerViewProvider.notifier).setSellerView(true);
    try {
      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredEamil,
          password: _enteredPassword,
        );
      } else if (_enteredPassword == _confirmPassword) {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEamil,
          password: _enteredPassword,
        );
        if (userCredentials.user != null) {
          await AppFirestore().createCustomerByUser(userCredentials.user!);
        }
      } else {
        throw FirebaseAuthException(
          code: 'confirm-password-different',
          message: 'Confirm Password is not the same!',
        );
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {}
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).clearSnackBars();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    int imageNum = DateTime.now().second % 2;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                width: 200,
                child: Image.asset('assets/images/signin$imageNum.jpg'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            key: _formEmail,
                            decoration: const InputDecoration(
                              labelText: 'Email Address',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredEamil = value!;
                            },
                          ),
                          TextFormField(
                            controller: _pass,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                            ),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Password must be at least 6 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          if (!_isLogin)
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Confirm Password',
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value != _pass.text) {
                                  return 'Confirmed Password is not equal to Password';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _confirmPassword = value!;
                              },
                            ),
                          if (!_isLogin)
                            const SizedBox(
                              height: 12,
                            ),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            child: Text(_isLogin ? 'Login' : 'Signup'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: Text(_isLogin
                                    ? 'Create an account'
                                    : 'I already have an account.'),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  if (_formEmail.currentState!.validate()) {
                                    _formEmail.currentState!.save();
                                    _firebase.sendPasswordResetEmail(
                                        email: _enteredEamil);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: const Duration(
                                          seconds: 2,
                                        ),
                                        content: Text(
                                          'Email sent at $_enteredEamil',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: const Text('Forgot password'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
