
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/states.dart';
import 'archived tasks.dart';
import 'done tasks.dart';
import 'new tasks.dart';

class AppCubit extends Cubit<AppsStates> {
  AppCubit() :super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);
  List<BottomNavigationBarItem>bottomItems=
  [
    BottomNavigationBarItem(
        icon:Icon(
            Icons.menu
        ),
        label:"tasks"),
    BottomNavigationBarItem(
        icon:Icon(
            Icons.check_circle
        ),
        label:"done"),
    BottomNavigationBarItem(
        icon:Icon(
            Icons.archive_outlined
        ),
        label:"archived"),
  ];

  List<Widget>screens =
  [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String>titles = [
    "tasks",
    "done tasks",
    "archived tasks"
  ];

  int currentIndex = 0;
  Database database;
  IconData fabIcon=Icons.edit;
  bool  isBottomShowDown=false;
  Map model;
  List<Map>newTasks=[];
  List<Map>doneTasks=[];
  List<Map>archivedTasks=[];


  void changeBottomSheetState({
    @required bool isShow,
    @required IconData icon,
  })
  {
    isBottomShowDown= isShow;
    fabIcon= icon;
    emit(AppChangeBottomSheetState());

  }
  void changeIndex(index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());

  }

  void createDatabase(){
       openDatabase(
        "todo.dp",
        version:1,
        onCreate: (database,version){
          print("create database");
          database.execute("Create table tasks(ID INTEGER PRIMARY KEY,time TEXT,status TEXT,date TEXT,title TEXT )").
          then((value){
            print("create Table");
          }).catchError((error){
            print("create is error${error.toString()}");
          });
        },
        onOpen:(database){
          getDataFromDatabase(database);
          print("database opened");
        }
    ).then((value)
       {
         database=value;
         emit(AppCreateDatabaseState());
       });
  }

  Future insertDatabase({
    @required String title,
    @required String time,
    @required String date,
  })async{
    return await database.transaction((txn){
      return txn.rawInsert(
          "insert into Tasks(time,status,date,title)VAlUES('$time','new','$date','$title')").
      then((value){
        print(" $value insert is successfully");
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);

      }).catchError((error){
        print("insert is error${error.toString()}");
      });

    });
  }


  void getDataFromDatabase(database)
  {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
     emit(AppGetDatabaseLoadingState());
     database.rawQuery('SELECT * FROM tasks').then((value)
     {

       value.forEach((element)
       {
         if(element["status"]=="new")
           newTasks.add(element);
         else if (element["status"]=="done")
           doneTasks.add(element);
             else archivedTasks.add(element);
       });
       emit(AppGetDatabaseState());

     });
  }

  void updateDatabase({
    @required int id,
    @required String status}) {
    database.rawUpdate(
        'UPDATE tasks SET status= ? WHERE id = ?',
        ['$status', id]

    ).then((value){print('Update');
    emit(AppUpdateDatabaseState());
    getDataFromDatabase(database);
    });
  }

  void deleteDatabase({ @required int id}) {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]

    ).then((value){
      print('deleted');
      emit(AppDeleteDatabaseState());
      getDataFromDatabase(database);
    });
  }
}