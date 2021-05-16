import 'package:abdaallah2/layout/BottomNavagation/Home.dart';
import 'package:abdaallah2/layout/BottomNavagation/archive.dart';
import 'package:abdaallah2/layout/BottomNavagation/done.dart';
import 'package:abdaallah2/shared/Cubit/States.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitionalStates());

  static AppCubit get(context) => BlocProvider.of(context);
//// Bottom Navagation ////////
  int index = 0;
  var screen = [HomeBottomScreen(), DoneScreen(), ArchiveScreen()];

  void changeScreen(int currentindex) {
    index = currentindex;
    emit(AppChangeIndexBottomNavStates());
  }

  ///////////////// floating action ///////////////
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  bool isShowBottomFloating = false;
  IconData iconfab = Icons.add;

  void changeFloatingsheetStates({bool isShown, IconData icon}) {
    isShowBottomFloating = isShown;
    iconfab = icon;
    emit(AppChangeFloatingsheetStates());
  }

  var titlecontroller = TextEditingController();
  var datacontroller = TextEditingController();
  var timecontroller = TextEditingController();
  /////////////////////

  void createDatabase() {
    openDatabase("Todo.db", version: 1, onCreate: (database, version) {
      print("database Create");

      database
          .execute(
              'CREATE TABLE test (id INTEGER PRIMARY KEY, title TEXT , date TEXT , time TEXT , status TEXT )')
          .then((value) {
        print("table Create");
      }).catchError(
        (onError) {
          print(" Error ${onError.toString()}");
        },
      );
    }, onOpen: (database) {
      getDataFromDataBase(database);
      // .then((value) {
      //   //   setState(() {
      //   newtask = value;
      //   print(newtask);
      //   emit(AppGetDataBaseState());
      //   //   });
      //   print(test);
      // });
      print("Database Open");
    }).then((value) {
      database = value;
      emit(AppCreateDataBaseState());
    });
  }

//////////////////////////Sqlite//////////
  List<Map> test = [];
  List<Map> newtask = [];
  List<Map> donetask = [];
  List<Map> archivedtask = [];
  Database database;

  insertToDatabase({
    String title,
    String date,
    String time,
  }) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO test (title ,date , time ,status ) VALUES("$title" , "$date" , "$time" , "new")')
          .then((value) {
        print("Sucessufel");
        emit(AppInsertDataBaseState());
        getDataFromDataBase(database);
      }).catchError((onError) {
        print("error ${onError.toString()}");
      });
      return null;
    });
  }

  void getDataFromDataBase(database) {
    emit(AppGetDataBaseLoadingState());
    database.rawQuery('SELECT * FROM test').then((value) {
      value.forEach((element) {
        print(element['status']);

        if (element['status'] == 'new')
          newtask.add(element);
        else if (element['status'] == 'done')
          donetask.add(element);
        else
          archivedtask.add(element);
      });
      emit(AppGetDataBaseState());
    });
  }
  // Future<List<Map>> getDataFromDataBase(database) async {
  //   emit(AppGetDataBaseLoadingState());
  //   return await database.rawQuery('SELECT * FROM test');
  // }

  void updateDataBase({String status, int id}) async {
    database.rawUpdate('UPDATE test SET status = ? WHERE id = ?',
        ['updated $status', id]).then((value) {
      getDataFromDataBase(database);
      emit(AppUpDateDataBaseState());
    });
  }

  void deleteData({
    @required int id,
  }) async {
    database.rawDelete('DELETE FROM test WHERE id = ?', [id]).then((value) {
      getDataFromDataBase(database);
      emit(AppDeleteDatabaseState());
    });
  }
}
