import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hyaw_mahider/services/auth-service.dart';
import 'package:flutx/flutx.dart';
import 'package:hyaw_mahider/theme/app_theme.dart';
import 'package:hyaw_mahider/homes/homes_screen.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible = false;
  late CustomTheme customTheme;
  late ThemeData theme;
  late AuthService authService;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
    authService = AuthService();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 3 / 10,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.background,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(96)),
                  ),
                ),
                Positioned(
                  top: 30,
                  left: 10,
                  child: BackButton(
                    color: theme.colorScheme.onBackground,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 40,
                  child: FxText.headlineSmall("LOGIN", fontWeight: 600),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: FxContainer.bordered(
              padding: const EdgeInsets.only(
                  top: 12, left: 20, right: 20, bottom: 12),
              child: FormBuilder(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    FormBuilderTextField(
                      name: 'email',
                      controller: _emailController,
                      style: TextStyle(
                        letterSpacing: 0.1,
                        color: theme.colorScheme.onBackground,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: "Email",
                        hintStyle: TextStyle(
                          letterSpacing: 0.1,
                          color: theme.colorScheme.onBackground,
                          fontWeight: FontWeight.w500,
                        ),
                        prefixIcon: const Icon(MdiIcons.emailOutline),
                      ),
                      validator: FormBuilderValidators.required(),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: FormBuilderTextField(
                        name: 'password',
                        controller: _passwordController,
                        style: TextStyle(
                          letterSpacing: 0.1,
                          color: theme.colorScheme.onBackground,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: TextStyle(
                            letterSpacing: 0.1,
                            color: theme.colorScheme.onBackground,
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: const Icon(MdiIcons.lockOutline),
                          suffixIcon: IconButton(
                            icon: Icon(_passwordVisible
                                ? MdiIcons.eyeOutline
                                : MdiIcons.eyeOffOutline),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_passwordVisible,
                        validator: FormBuilderValidators.required(),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      alignment: Alignment.centerRight,
                      child: FxText.bodySmall("Forgot Password ?",
                          fontWeight: 500),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: FxButton(
                        elevation: 0,
                        borderRadiusAll: 4,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            bool loggedIn = await authService.login(
                              _emailController.text,
                              _passwordController.text,
                            );

                            if (loggedIn) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomesScreen()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Login failed. Please check your credentials.')),
                              );
                            }
                          }
                        },
                        child: FxText.labelMedium(
                          "LOGIN",
                          fontWeight: 600,
                          color: theme.colorScheme.onPrimary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 24),
            child: Center(
              child: FxText.bodyMedium("OR", fontWeight: 500),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FxContainer.rounded(
                  width: 52,
                  height: 52,
                  paddingAll: 0,
                  color: theme.colorScheme.primary,
                  child: Icon(
                    MdiIcons.facebook,
                    color: theme.colorScheme.onPrimary,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 20),
                FxContainer.rounded(
                  width: 52,
                  height: 52,
                  paddingAll: 0,
                  color: theme.colorScheme.primary,
                  child: Icon(
                    MdiIcons.google,
                    color: theme.colorScheme.onPrimary,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
