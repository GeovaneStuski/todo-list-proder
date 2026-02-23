import 'package:flutter/material.dart';
import 'package:flutter_todo_list/app/core/notifier/default_listner_notifier.dart';
import 'package:flutter_todo_list/app/core/ui/messages.dart';
import 'package:flutter_todo_list/app/core/ui/theme_extension.dart';
import 'package:flutter_todo_list/app/core/widget/todo_list_field.dart';
import 'package:flutter_todo_list/app/core/widget/todo_list_logo.dart';
import 'package:flutter_todo_list/app/modules/auth/register/register_controller.dart';
import 'package:provider/provider.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailEc = TextEditingController();
  final TextEditingController _passwordEc = TextEditingController();
  final TextEditingController _confirmPasswordEc = TextEditingController();
  late RegisterController _controller;

  @override
  void initState() {
    super.initState();

    final controller = context.read<RegisterController>();

    DefaultListnerNotifier(defaultNotifier: controller).listener(
      context: context,
      successCallback: (notifier, listenerInstance) {
        listenerInstance.dispose();
        Navigator.of(context).pop();
        Messages.of(context).showSuccess("Cadastrado com sucesso!!");
      },
    );

    _controller = controller;
  }

  @override
  void dispose() {
    _emailEc.dispose();
    _passwordEc.dispose();
    _confirmPasswordEc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.black,
        elevation: 2,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Todo List",
              style: TextStyle(fontSize: 12, color: context.primaryColor),
            ),
            Text(
              "Cadastro",
              style: TextStyle(fontSize: 15, color: context.primaryColor),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: ClipOval(
            child: Container(
              color: context.primaryColor.withAlpha(20),
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back_ios_outlined,
                size: 20,
                color: context.primaryColor,
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 200,
            child: FittedBox(fit: BoxFit.fitHeight, child: TodoListLogo()),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
                  SizedBox(height: 20),
                  TodoListField(
                    label: "Confimar senha",
                    obscureText: true,
                    controller: _confirmPasswordEc,
                    validator: Validatorless.multiple([
                      Validatorless.required("Confirmar senha obrigatório"),
                      Validatorless.compare(
                        _passwordEc,
                        "As senhas digitadas não batem!",
                      ),
                    ]),
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        final isFormValid =
                            _formKey.currentState?.validate() ?? false;

                        if (isFormValid) {
                          final email = _emailEc.text;
                          final password = _passwordEc.text;
                          context.read<RegisterController>().registerUser(
                            email,
                            password,
                          );
                        }
                      },
                      child: Text("Salvar"),
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
