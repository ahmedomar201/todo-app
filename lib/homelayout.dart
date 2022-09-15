import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/cubit.dart';
import 'package:todo_app/states.dart';
class HomeLayout extends StatelessWidget
{
  var scaffoldKey=GlobalKey<ScaffoldState>();
  var formKey=GlobalKey<FormState>();
  var titleController=TextEditingController();
  var timeController=TextEditingController();
  var dateController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:(context)=>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppsStates>(
        listener:(context,state)
        {
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (context,state)
        {
          AppCubit cubit = AppCubit.get(context);
         return Scaffold(
            key:scaffoldKey,
            appBar: AppBar(
              title: Text(
                  cubit.titles[cubit.currentIndex]),
            ),
            body:ConditionalBuilder(
              condition:state is! AppGetDatabaseLoadingState,
              builder:(context)=>cubit.screens[cubit.currentIndex] ,
              fallback:(context)=>Center(child: CircularProgressIndicator()) ,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                if(cubit.isBottomShowDown){
                  if(formKey.currentState.validate()){
                    AppCubit.get(context).insertDatabase(
                        title:titleController.text,
                        time: timeController.text,
                        date: dateController.text);

                    // insertDatabase(
                    //   date:dateController.text ,
                    //   time:timeController.text ,
                    //   title:titleController.text,
                    // ).then((value)
                    // {
                    //   getDataFromDatabase(database).then((value)
                    //   {
                    //     Navigator.pop(context);
                    //     // setState(() {
                    //     //   isBottomShowDown=false;
                    //     //   fabIcon=Icons.edit;
                    //     //   tasks=value;
                    //     //   print(tasks);
                    //     // });
                    //   });
                    //
                    // });
                  }
                }
                else{
                  scaffoldKey.currentState.showBottomSheet((context) =>
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          color: Colors.white,
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextFormField(
                                  controller: titleController,
                                  keyboardType:TextInputType.text,
                                  validator: (String value) {
                                    if(value.isEmpty){
                                      return 'title cannot be empty';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Task Title',
                                    prefixIcon: Icon(
                                        Icons.title
                                    ),
                                  ),

                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  controller:timeController,
                                  keyboardType:TextInputType.datetime,
                                  validator: (String value) {
                                    if(value.isEmpty){
                                      return 'time must be empty';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Task time',
                                    prefixIcon: Icon(
                                        Icons.watch_later_outlined
                                    ),
                                  ),
                                  onTap:(){
                                    showTimePicker(context: context,
                                      initialTime:TimeOfDay.now(),
                                    ).then((value)
                                    {
                                     timeController.text=value.format(context).toString();
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  controller: dateController,
                                  keyboardType:TextInputType.datetime,
                                  validator: (String value) {
                                    if(value.isEmpty){
                                      return 'date must be empty';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Task date',
                                    prefixIcon: Icon(
                                        Icons.calendar_today
                                    ),
                                  ),
                                  onTap:(){
                                    showDatePicker(
                                        context: context,
                                        initialDate:DateTime.now(),
                                        firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('3022-08-07'),
                                    ).then((value)
                                    {
                                      dateController.text=DateFormat.yMMMEd().format(value);
                                    });
                                  },
                                ),

                              ],
                            ),
                          ),
                        ),
                      )
                  ).closed.then((value)
                  {
                    cubit.changeBottomSheetState(isShow:false ,icon:Icons.edit );
                  });
                  cubit.changeBottomSheetState(isShow:true ,icon:Icons.add );
                }
              },
              child:Icon(
                 cubit.fabIcon) ,
            ),
            bottomNavigationBar:BottomNavigationBar(
              type:BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index){
                cubit.changeIndex(index);
                // setState(() {
                //   currentIndex=index;
                // });
              },
              items:cubit.bottomItems,
            ) ,
          );

        } ,

      ),
    );

  }
  //Future<String> getName()async {
  // return "ahmed omar";
  // }

  }



