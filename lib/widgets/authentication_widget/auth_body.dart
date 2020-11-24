import 'package:BlogApp/screens/authentication_screen/reset_screen.dart';
import 'package:BlogApp/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';

class AuthBody extends StatefulWidget {
  AuthBody(this.submitFn, this.isLoading);
  final bool isLoading;
  final void Function(
    String username,
    String email,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  @override
  _AuthBodyState createState() => _AuthBodyState();
}

class _AuthBodyState extends State<AuthBody> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController =
      TextEditingController();
  var _isLogin = true;

  void _submitForm() {
    final _isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_isValid) {
      _formKey.currentState.save();

      widget.submitFn(
        _userNameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Container(
      padding: EdgeInsets.all(_isPortrait ? 20.0 : 50.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Text(
              _isLogin ? 'Welcome back' : 'Register',
              style: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          Container(
            width: _isLogin ? 250 : 300,
            height: _isLogin ? 300 : 250,
            child: SvgPicture.asset(_isLogin
                ? 'asset/images/sign_in.svg'
                : 'asset/images/sign_up.svg'),
          ),
          Container(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin)
                    TextFormField(
                      controller: _userNameController,
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      enableSuggestions: false,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your name';
                        } else if (value.length < 4) {
                          return 'Username must be atleast 4 letters long';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: _emailController,
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your Email address';
                      } else if (!value.contains('@')) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter password';
                      } else if (value.trim().length < 7) {
                        return 'Password must be atleast 7 characters';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: Icon(Icons.vpn_key),
                    ),
                  ),
                  SizedBox(
                    height: _isLogin ? 0.0 : 20.0,
                  ),
                  if (!_isLogin)
                    TextFormField(
                      controller: _retypePasswordController,
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Re-enter password';
                        } else if (value.trim() !=
                            _passwordController.text.trim()) {
                          return 'Password did\'t match, Please re-enter password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Re-type Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        prefixIcon: Icon(Icons.vpn_key),
                      ),
                    ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: ResetPassword(),
                            type: PageTransitionType.rightToLeftWithFade,
                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: (widget.isLoading)
                        ? circularProgress()
                        : RaisedButton(
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            onPressed: _submitForm,
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.all(15.0),
                              alignment: Alignment.center,
                              child: Text(
                                _isLogin ? 'SIGN IN' : 'SIGN UP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_isLogin
                            ? "Don't have an account?"
                            : "Already have an account?"),
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(
                            _isLogin ? 'Register here' : 'Sign In',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
