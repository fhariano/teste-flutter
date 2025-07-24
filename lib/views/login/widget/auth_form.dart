// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter_social_button/flutter_social_button.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/user_service.dart';

import '../../../data/models/user_model.dart';

enum AuthMode { Signup, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  AuthFormState createState() => AuthFormState();
}

class AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  AuthMode _authMode = AuthMode.Login;
  final UserModel _authData = UserModel();

  AnimationController? _controller;
  Animation<double>? _opacityAnimation;
  Animation<Offset>? _slideAnimation;

  bool _isLogin() => _authMode == AuthMode.Login;
  late bool _isSelected;
  // bool _isSignup() => _authMode == AuthMode.Signup;
  // Defining the focus node
  late FocusNode focusNode1 = FocusNode();
  late FocusNode focusNode2 = FocusNode();
  late FocusNode focusNode3 = FocusNode();
  late FocusNode focusNode4 = FocusNode();
  late FocusNode focusNode5 = FocusNode();
  late FocusNode focusNode6 = FocusNode();

  late UserService userService;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller!, curve: Curves.linear));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller!, curve: Curves.linear));

    userService = Provider.of<UserService>(context, listen: false);
    userService.initRememberedCredentials(cpfController, passwordController);
    _loadCheckboxValue();
  }

  Future<void> _loadCheckboxValue() async {
    setState(() {
      _isSelected = userService.rememberMe; // Recover the saved value
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of(context, listen: false);
    final deviceSize = MediaQuery.of(context).size;

    void switchAuthMode() {
      setState(() {
        if (_isLogin()) {
          _authMode = AuthMode.Signup;
          _controller?.forward();
          focusNode1.requestFocus();
        } else {
          _authMode = AuthMode.Login;
          _controller?.reverse();
          focusNode4.requestFocus();
        }
      });
    }

    void showErrorDialog(String msg) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            'Aviso!',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        ),
      );
    }

    Future<void> submit() async {
      final isValid = _formKey.currentState?.validate() ?? false;

      if (!isValid) {
        return;
      }

      setState(() => _isLoading = true);

      _formKey.currentState?.save();

      late Map<String, String> result;
      try {
        if (_isLogin()) {
          // LOGIN
          result = await authService.tryLoginwithCpfFromFirestore(
            _authData.cpf!,
            _authData.password!,
          );
          if (result["msg"] == "error") {
            showErrorDialog("CPF não cadastrado ou senha inválida!");
          } else {
            userService.toggleRememberMe(_isSelected);
            userService.saveCredentialsIfNeeded(
              _authData.cpf!,
              _authData.password!,
            );
          }
        } else {
          // SIGNUP
          result = await authService.tryRegister(_authData);
          if (result["msg"] == "error") {
            showErrorDialog("CPF não cadastrado ou senha inválida!");
          } else if (result["msg"] == "exists") {
            showErrorDialog("CPF já utilizado por outro usuário!");
          } else {
            showErrorDialog(result["msg"].toString());
          }
        }
      } on FirebaseAuthException catch (error) {
        showErrorDialog(error.code);
      } catch (error) {
        showErrorDialog('Ocorreu um erro inesperado!');
      }

      setState(() => _isLoading = false);
    }

    bool isWeb = Theme.of(context).platform == TargetPlatform.windows;

    return SingleChildScrollView(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
          padding: const EdgeInsets.all(16),
          // height: _isLogin() ? 340 : 680,
          // height: _heightAnimation?.value.height ?? (_isLogin() ? 310 : 400),
          width: deviceSize.width * (isWeb ? 0.25 : 0.75),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AnimatedContainer(
                  constraints: BoxConstraints(
                    minHeight: _isLogin() ? 0 : 140,
                    maxHeight: _isLogin() ? 0 : 260,
                  ),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear,
                  child: FadeTransition(
                    opacity: _opacityAnimation!,
                    child: SlideTransition(
                      position: _slideAnimation!,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              // width: deviceSize.width * 0.25,
                              child: TextFormField(
                                controller: nameController,
                                focusNode: focusNode1,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: 'Nome',
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    // borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                onSaved: (name) =>
                                    _authData.displayName = name ?? '',
                                validator: _isLogin()
                                    ? null
                                    : (name) {
                                        if (name!.trim().isEmpty) {
                                          return 'Informe um nome válido!';
                                        }
                                        return null;
                                      },
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              // width: deviceSize.width * 0.25,
                              child: TextFormField(
                                controller: lastnameController,
                                textInputAction: TextInputAction.next,
                                focusNode: focusNode2,
                                decoration: InputDecoration(
                                  labelText: 'Sobrenome',
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    // borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                                onSaved: (lastname) => _authData.displayName =
                                    ('${_authData.displayName} $lastname'),
                                validator: _isLogin()
                                    ? null
                                    : (lastname) {
                                        if (lastname!.trim().isEmpty) {
                                          return 'Informe um sobrenome válido!';
                                        }
                                        return null;
                                      },
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              // width: deviceSize.width * 0.25,
                              child: TextFormField(
                                controller: emailController,
                                textInputAction: TextInputAction.next,
                                focusNode: focusNode3,
                                decoration: InputDecoration(
                                  labelText: 'E-mail',
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    // borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                onSaved: (email) =>
                                    _authData.email = email ?? '',
                                validator: _isLogin()
                                    ? null
                                    : (email) {
                                        if (email!.trim().isEmpty ||
                                            !email.contains('@')) {
                                          return 'Informe um e-mail válido!';
                                        }
                                        return null;
                                      },
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  // width: deviceSize.width * 0.25,
                  child: TextFormField(
                    controller: cpfController,
                    autofocus: true,
                    focusNode: focusNode4,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'CPF',
                      hintText: '000.000.000-00',
                      isDense: true,
                      border: OutlineInputBorder(
                        // borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CpfInputFormatter(),
                    ],
                    onSaved: (cpf) => _authData.cpf =
                        cpf?.replaceAll(RegExp(r'[^0-9]'), '') ?? '',
                    validator: (cpf) {
                      if (cpf!.trim().isEmpty || !CPFValidator.isValid(cpf)) {
                        return 'Informe um cpf válido!';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  // width: deviceSize.width * 0.25,
                  child: TextFormField(
                    focusNode: focusNode5,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      isDense: true,
                      border: OutlineInputBorder(
                        // borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                    controller: passwordController,
                    textInputAction: _isLogin()
                        ? TextInputAction.done
                        : TextInputAction.next,
                    onSaved: (password) => _authData.password = password ?? '',
                    validator: (password) {
                      if (password!.isEmpty || password.length < 5) {
                        return 'Informe uma senha válida!';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 8),
                AnimatedContainer(
                  constraints: BoxConstraints(
                    minHeight: _isLogin() ? 0 : 60,
                    maxHeight: _isLogin() ? 0 : 120,
                  ),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.linear,
                  child: FadeTransition(
                    opacity: _opacityAnimation!,
                    child: SlideTransition(
                      position: _slideAnimation!,
                      child: SizedBox(
                        // width: deviceSize.width * 0.25,
                        child: TextFormField(
                          focusNode: focusNode6,
                          decoration: InputDecoration(
                            labelText: 'Confirmar Senha',
                            isDense: true,
                            border: OutlineInputBorder(
                              // borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.emailAddress,
                          obscureText: true,
                          validator: _isLogin()
                              ? null
                              : (password) {
                                  if (password != passwordController.text) {
                                    return 'Senhas informadas não conferem!';
                                  }
                                  return null;
                                },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: submit,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                      backgroundColor: Theme.of(context).secondaryHeaderColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 8,
                      ),
                    ),
                    child: Text(
                      _authMode == AuthMode.Login ? 'ENTRAR' : 'REGISTRAR',
                    ),
                  ),
                ?_isLogin()
                    ? Row(
                        children: [
                          Checkbox(
                            value: _isSelected,
                            onChanged: (bool? newValue) {
                              _isSelected = newValue!;
                              setState(() {
                                if (cpfController.text.isNotEmpty &&
                                    passwordController.text.isNotEmpty) {}
                              });
                            },
                          ),
                          Flexible(
                            flex: 1,
                            child: Text(
                              'Lembrar Sempre',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () async {
                                  if (cpfController.text.isEmpty) {
                                    showErrorDialog("Informe o CPF válido!");
                                  } else {
                                    Map<String, String> result =
                                        await authService.trySendResetPassword(
                                          cpfController.text.replaceAll(
                                            RegExp(r'[^0-9]'),
                                            '',
                                          ),
                                        );
                                    if (result["msg"]!.contains('error')) {
                                      showErrorDialog(result["msg"]!);
                                    } else if (result["msg"] == "notExist") {
                                      showErrorDialog("CPF não cadastrado!");
                                    } else {
                                      showErrorDialog(
                                        "Mensagem de reset de senha enviada para o email cadastrado!\nVerifique também na pasta de SPAM!",
                                      );
                                    }
                                  }
                                },
                                child: const Text(
                                  'Esqueci minha senha',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : null,
                // const SizedBox(height: 8),
                TextButton(
                  onPressed: switchAuthMode,
                  child: SizedBox(
                    width: 150,
                    child: Text(
                      _isLogin()
                          ? 'NÃO TEM CONTA? CADASTRE-SE!'
                          : 'JÁ TEM UMA CONTA? FAÇA LOGIN!',
                      maxLines: 2,
                      overflow: TextOverflow.clip,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FlutterSocialButton(
                        onTap: () {},
                        buttonType: ButtonType.google,
                        mini: true,
                        iconColor: Colors.white,
                        iconSize: 14,
                      ),
                      FlutterSocialButton(
                        onTap: () {},
                        buttonType: ButtonType.twitter,
                        mini: true,
                        iconColor: Colors.white,
                        iconSize: 14,
                      ),
                      FlutterSocialButton(
                        onTap: () {},
                        buttonType: ButtonType.instagram,
                        mini: true,
                        iconColor: Colors.white,
                        iconSize: 14,
                      ),
                      FlutterSocialButton(
                        onTap: () {},
                        buttonType: ButtonType.facebook,
                        mini: true,
                        iconColor: Colors.white,
                        iconSize: 14,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
