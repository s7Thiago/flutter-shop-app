import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../exceptions/auth_exception.dart';

enum AuthMode { SignUp, Login }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _form = GlobalKey();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.Login;
  final _passwordController = TextEditingController();

  AnimationController _controller;
  Animation<double> _opacityAnimation;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    _slideAnimation = Tween(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('An error has ocurred'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_form.currentState.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _form.currentState.save();

    Auth auth = Provider.of(context, listen: false);

    try {
      if (_authMode == AuthMode.Login) {
        // Login logics
        await auth.login(_authData['email'], _authData['password']);
      } else {
        // Register logics
        await auth.signUp(_authData['email'], _authData['password']);
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('An unexpected error has ocurred!');
    }

    setState(() {
      _isLoading = false;
    });

    return Future.value();
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
        width: deviceSize.width * .75,
        // height: _heightAnimation.value.height,
        height: _authMode == AuthMode.Login ? 320 : 370,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Informe um e-mail válido!';
                  }
                  return null;
                },
                onSaved: (value) => _authData['email'] = value,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                controller: _passwordController,
                validator: (value) {
                  if (value.isEmpty || value.length < 5) {
                    return 'Informe uma senha válida!';
                  }
                  return null;
                },
                onSaved: (value) => _authData['password'] = value,
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.linear,
                constraints: BoxConstraints(
                  minHeight: _authMode == AuthMode.SignUp ? 60 : 0,
                  maxHeight: _authMode == AuthMode.SignUp ? 120 : 0,
                ),
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: TextFormField(
                      decoration:
                          InputDecoration(labelText: 'Confirm Password'),
                      obscureText: true,
                      validator: _authMode == AuthMode.SignUp
                          ? (value) {
                              if (value != _passwordController.text) {
                                return 'As senhas não são iguais!';
                              }
                              return null;
                            }
                          : null,
                      onSaved: (value) => _authData['password'] = value,
                    ),
                  ),
                ),
              ),
              Spacer(),
              if (_isLoading)
                CircularProgressIndicator()
              else
                // ignore: deprecated_member_use
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: Theme.of(context).primaryColor,
                  textColor: Theme.of(context).primaryTextTheme.button.color,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                  child:
                      Text(_authMode == AuthMode.Login ? 'Enter' : 'Register'),
                  onPressed: _submit,
                ),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(
                  'SWITCH TO ${_authMode == AuthMode.Login ? 'REGISTER' : 'LOGIN'}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
