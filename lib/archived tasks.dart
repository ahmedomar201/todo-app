import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/states.dart';
import 'package:todo_app/tasks.dart';
import 'cubit.dart';
class ArchivedTasksScreen  extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppsStates>(
        listener:(context,state) {},
        builder:(context,state){
          var tasks= AppCubit.get(context).archivedTasks;
          return tasksBuilder(tasks: tasks);
        }
    );
  }
}
