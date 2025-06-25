import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/cubit/states.dart';
import 'package:todo_app/shared/components/constants.dart';

import '../modules/archive_tasks.dart';
import '../modules/done_tasks.dart';
import '../modules/new_Tasks.dart';


class AppCubit extends Cubit<AppStates> {
  AppCubit() :super(InitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentindex = 0;
  IconData fabicon = Icons.edit;
  bool bottomsheet = false;
  Database? database;
  List<Map> newtasks = [];
  List<Map> donetasks = [];
  List<Map> archivetasks = [];
  List<Widget> screens =
  [
    NewTasks(),
    DoneTasks(),
    ArchiveTasks(),
  ];
  List<String> titles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeindex({
    required int index,
  }) {
    currentindex = index;
    emit(changeIndexState());
  }

  void changeBottomSheet({
    required IconData icon,
    required bool bottomsheet,
  }) {
    fabicon = icon;
    this.bottomsheet = bottomsheet;
    emit(changeBottomSheetState());
  }

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        database.execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT , time TEXT , date TEXT , status TEXT)'
        ).then((value) {
          print('Database Created Successfully');
        }).catchError((error) {
          print('Error $error when created database');
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database);
      },
    ).then((value) {
      database = value;
      emit(createDatabaseState());
    });
  }

  insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async
  {
    await database?.transaction((txn) =>
        txn.rawInsert(
            'INSERT INTO tasks (title,time,date,status) VALUES ("$title","$time","$date","new")'
        ).then((value) {
          print("$value inserted Successfully");
          emit(insertDatabaseState());
          getDataFromDatabase(database);
        }
        ).catchError((error) {
          print('Error $error when created database');
        }
        ));
    return null;
  }

  void getDataFromDatabase(database) {
    emit(getDatabaseLoadingState());
    newtasks.clear();
    donetasks.clear();
    archivetasks.clear();

    database!.rawQuery('SELECT * FROM tasks').then((value) {

      value.forEach((element)
      {
        if(element['status']=='new')
          newtasks.add(element);
        else if (element['status']=='done')
            donetasks.add(element);
        else
          archivetasks.add(element);

      });

      emit(getDatabaseState());

    });
  }

  void updateDatabase({
    required String status,
    required int id,
})
  {
    database!.rawUpdate(
    'UPDATE tasks SET status =? WHERE id=?',
      [status,id],
    ).then((value)
    {
      getDataFromDatabase(database);
      emit(updateDatabaseState());
    });
  }

  void deleteDataFromDatabase ({
    required int id,
})
  {
    database!.rawDelete(
        'DELETE FROM tasks WHERE id=?',[id],
    ).then((value)
    {
      getDataFromDatabase(database);
      emit(deleteDatabaseState());
    });
  }
}