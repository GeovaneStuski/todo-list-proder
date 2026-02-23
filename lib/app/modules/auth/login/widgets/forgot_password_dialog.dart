import 'package:flutter/material.dart';
import 'package:flutter_todo_list/app/core/ui/messages.dart';
import 'package:flutter_todo_list/app/core/widget/todo_list_field.dart';
import 'package:flutter_todo_list/app/exception/auth_exception.dart';
import 'package:flutter_todo_list/app/modules/auth/login/login_controller.dart';
import 'package:validatorless/validatorless.dart';

class ForgotPasswordDialog extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailEc = TextEditingController();
  final LoginController _loginController;

  ForgotPasswordDialog({super.key, required LoginController loginController})
    : _loginController = loginController;

  void _forgotPassord(BuildContext context) {
    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (isFormValid) {
      try {
        final email = _emailEc.text;
        _loginController.forgotPassword(email);
        Messages.of(
          context,
        ).showSuccess("Um E-mail foi enviado para você com as instruções!!");
        Navigator.of(context).pop();
      } on AuthException catch (e) {
        Messages.of(context).showError(e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Text(
              "Recuperar minha senha",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            Text(
              "Vamos mandar um e-mail para você com as informações de como recuperar sua senha.",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            Form(
              key: _formKey,
              child: TodoListField(
                label: "E-mail",
                controller: _emailEc,
                validator: Validatorless.multiple([
                  Validatorless.required("E-mail é obrigatório"),
                  Validatorless.email("E-mail inválido"),
                ]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Fechar"),
                ),
                ElevatedButton(
                  onPressed: () => _forgotPassord(context),
                  child: Text("Recuperar senha"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
