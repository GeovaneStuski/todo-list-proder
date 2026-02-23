import 'package:flutter_todo_list/app/core/modules/todo_list_module.dart';
import 'package:flutter_todo_list/app/modules/home/home_page.dart';

class HomeModule extends TodoListModule {
  HomeModule() : super(bindings: null, routers: {"/home": (_) => HomePage()});
}
