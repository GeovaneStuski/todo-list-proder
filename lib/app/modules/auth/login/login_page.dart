import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_todo_list/app/core/notifier/default_listner_notifier.dart';
import 'package:flutter_todo_list/app/core/widget/todo_list_logo.dart';
import 'package:flutter_todo_list/app/core/widget/todo_list_field.dart';
import 'package:flutter_todo_list/app/modules/auth/login/login_controller.dart';
import 'package:flutter_todo_list/app/modules/auth/login/widgets/forgot_password_dialog.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailEc = TextEditingController();
  final _passwordEc = TextEditingController();
  late LoginController _controller;

  @override
  void initState() {
    final controller = context.read<LoginController>();
    DefaultListnerNotifier(defaultNotifier: controller).listener(
      context: context,
      successCallback: (notifier, listenerInstance) {
        listenerInstance.dispose();
        // Navigator.of(context).pushNamed('/splash');
      },
    );

    _controller = controller;

    super.initState();
  }

  @override
  void dispose() {
    _emailEc.dispose();
    _passwordEc.dispose();
    super.dispose();
  }

  void _login() {
    final isFormValid = _formKey.currentState?.validate() ?? false;

    if (isFormValid) {
      final email = _emailEc.text;
      final password = _passwordEc.text;
      _controller.login(email, password);
    }
  }

  void _forgotPassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ForgotPasswordDialog(
        loginController: context.read<LoginController>(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<LoginController>(context);
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: constraints.maxWidth,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10),
                      TodoListLogo(),
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(
                          horizontal: 40,
                          vertical: 20,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TodoListField(
                                label: "E-mail",
                                controller: _emailEc,
                                validator: Validatorless.multiple([
                                  Validatorless.required("E-mail obrigatório"),
                                  Validatorless.email("E-mail inválido"),
                                ]),
                              ),
                              SizedBox(height: 20),
                              TodoListField(
                                label: "Senha",
                                obscureText: true,
                                controller: _passwordEc,
                                validator: Validatorless.multiple([
                                  Validatorless.required("Senha obrigatório"),
                                  Validatorless.min(6, "Senha muito curta"),
                                ]),
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () => _forgotPassword(context),
                                    child: Text("Esqueceu a senha?"),
                                  ),
                                  ElevatedButton(
                                    onPressed: _login,
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(20),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text("Login"),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffF0F3F7),
                            border: Border(
                              top: BorderSide(
                                width: 2,
                                color: Colors.grey.withAlpha(50),
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              SignInButton(
                                Buttons.Google,
                                text: "Continue com o Google",
                                padding: const EdgeInsets.all(5),
                                shape: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                onPressed: () => _controller.loginWithGoogle(),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Não tem conta?"),
                                  TextButton(
                                    onPressed: () => Navigator.of(
                                      context,
                                    ).pushNamed("/register"),

                                    child: Text("Cadastre-se"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
