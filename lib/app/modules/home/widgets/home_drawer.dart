import 'package:flutter/material.dart';
import 'package:flutter_todo_list/app/core/auth/todo_list_auth_provider.dart';
import 'package:flutter_todo_list/app/core/ui/theme_extension.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _authProvider = context.read<TodoListAuthProvider>();
    final _name = _authProvider.user?.displayName ?? "Sem nome";
    final _avatar = _authProvider.user?.photoURL ?? "";
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: context.primaryColor.withAlpha(70),
            ),
            child: Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(_avatar)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(_name, style: context.textTheme.headlineSmall),
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
