import 'package:flutter/material.dart';
import 'package:flutter_todo_list/app/core/ui/theme_extension.dart';

class TodoListLogo extends StatelessWidget {
  const TodoListLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/todo-list.png', height: 200),
        Text("Todo List", style: context.textTheme.headlineSmall),
      ],
    );
  }
}
