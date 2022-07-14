import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'cubit.dart';
Widget buildTaskItem(Map model,context)=>Dismissible(
  key:Key(model["id"].toString()),
  onDismissed:(direction)
  {
    AppCubit.get(context).deleteDatabase(id:model["id"] );
  } ,
  child: Padding(
    padding: const EdgeInsets.all(20),
    child: Row(
        children:[
          CircleAvatar(
            radius:40 ,
            child: Text(
                "${model["time"]}"),
          ),
          SizedBox(
            width:10,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${model["title"]}",
                  style: TextStyle(
                    fontWeight:FontWeight.bold,
                    fontSize: 18,
                  ),),
                Text(
                  "${model["date"]}",
                  style: TextStyle(
                      color: Colors.grey
                  ),),
              ],
            ),

          ),
          SizedBox(
            width:10,
          ),
          IconButton(icon:Icon(Icons.done,
            color: Colors.green,),
              onPressed:()
              {
                AppCubit.get(context).updateDatabase(
                    status: "done",
                    id:model["id"] );
              }
          ),
          IconButton(icon:Icon(Icons.archive_outlined,
              color: Colors.black45),
              onPressed:()
              {
                AppCubit.get(context).updateDatabase(
                    status: "archive ",
                    id:model["id"] );
              }
          ),
        ]
    ),
  ),
);


Widget tasksBuilder({
  @required List<Map>tasks,context
})=>ConditionalBuilder(
  condition:tasks.length>0 ,
  builder:(context)=>ListView.separated(
      itemBuilder:(context,index)=>buildTaskItem(tasks[index],context),
      separatorBuilder: (context,index)=>Padding(
        padding: const EdgeInsetsDirectional.only(
          start: 20,
        ),
        child: Container(
          width: double.infinity,
          height: 1,
          color:Colors.grey[300] ,
        ),
      ),
      itemCount:tasks.length),
  fallback:(context)=>Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 100,
          color: Colors.black,
        ),
        Text("no tasks yet, please add tasks",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),)
      ],
    ),
  ) ,

);