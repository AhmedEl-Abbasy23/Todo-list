import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sqflite/sqflite.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  // App logic.
  // Change floating action button icon.
  IconData fabIcon = Icons.edit;
  bool isBottomSheetShown = false;

  void changeBottomSheetState({required bool isShow, required IconData icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(ChangeBottomSheetState());
  }

  late Database database;
  List<Map> tasks = [];

  void createDatabase() {
    openDatabase('todo.db', version: 1,
        // 1.create Database.
        onCreate: (database, version) {
      print('Database created');
      // 2.create Table.
      database
          .execute(
        "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT)",
      )
          .then((value) {
        print('Table created');
      }).catchError((error) {
        print('Error is: ${error.toString()}');
      });
    },
        // 3.open Database.
        onOpen: (database) {
      getFromDatabase(database);
      print('Database opened');
    }).then((value) {
      database = value;
      emit(CreateLocalDatabaseState());
    });
  }

// 1. Post to database.
  insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
        'INSERT INTO tasks(title, date, time) VALUES("$title", "$date", "$time")',
      )
          .then((value) async {
        emit(InsertToLocalDatabaseState());
        print('$value Inserted successfully');
        bool result = await InternetConnectionChecker().hasConnection;
        if (result) {
          addTaskToFirebase(time: time, date: date, title: title);
        }
        print(result.toString());
        getFromDatabase(database);
      }).catchError((error) {
        print('Error is: ${error.toString()}');
      });
    });
  }

// 2. Get from database.
  void getFromDatabase(database) async {
    // To avoid duplicate data when get.
    tasks = [];

    emit(GetFromLocalDatabaseLoadingState());
    // Getting Database.
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        tasks.add(element);
      });

      emit(GetFromLocalDatabaseSuccessState());
      print('Database gotten');
    });
  }

// 3. Delete from database.
  void deleteFromDatabase({
    required int id,
    // required docId,
  }) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getFromDatabase(database);
      emit(DeleteFromLocalDatabaseState());
      // deleteTaskFromFirebase(docId);
      print('Item on Database Deleted');
    });
  }

  // From app to firebase.

  addTaskToFirebase({
    required String title,
    required String time,
    required String date,
  }) async {
    await FirebaseFirestore.instance.collection('Tasks').add({
      'title': title,
      'time': time,
      'date': date,
    }).then((value) {
      emit((AddTaskToFirebaseSuccessState()));
    }).catchError((error) {
      emit((AddTaskToFirebaseErrorState()));
      print(error.toString());
    });
  }

  Stream<QuerySnapshot<Object?>> getTaskFromFirebase() {
    return FirebaseFirestore.instance.collection("Tasks").snapshots();
  }

  deleteTaskFromFirebase(docId) {
    return FirebaseFirestore.instance.collection("Tasks").doc(docId).delete();
  }
}
