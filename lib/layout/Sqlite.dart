import 'package:abdaallah2/shared/Cubit/Cubit.dart';
import 'package:abdaallah2/shared/Cubit/States.dart';
import 'package:abdaallah2/shared/component/componentButton.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class SqliteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, states) => {
                if (states is AppInsertDataBaseState)
                  {
                    Navigator.pop(context),
                  }
              },
          builder: (context, states) {
            AppCubit cubit = AppCubit.get(context);

            return Scaffold(
              key: cubit.scaffoldKey,
              appBar: AppBar(
                title: Text(
                  "Todo",
                  style: TextStyle(fontSize: 22),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (cubit.isShowBottomFloating) {
                    if (cubit.formKey.currentState.validate()) {
                      cubit.insertToDatabase(
                        title: cubit.titlecontroller.text,
                        time: cubit.timecontroller.text,
                        date: cubit.timecontroller.text,
                      );
                      // cubit.changeFloatingsheetStates(
                      //     isShown: false, icon: Icons.add);
                    }
                  } else {
                    cubit.scaffoldKey.currentState
                        .showBottomSheet((context) {
                          return Padding(
                            padding: EdgeInsets.all(10),
                            child: Form(
                              key: cubit.formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultTextField(
                                    context: context,
                                    onchanege: (value) {
                                      print(value);
                                    },
                                    onsave: (value) {
                                      print(value);
                                    },
                                    ontap: () {},
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        print("enter the Title");
                                      }
                                    },
                                    controller: cubit.titlecontroller,
                                    label: "Title",
                                    hint: "Enter the title",
                                    icon: Icons.title,
                                    isShown: false,
                                    istrue: false,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  defaultTextField(
                                    context: context,
                                    onchanege: (value) {
                                      print(value);
                                    },
                                    onsave: (value) {
                                      print(value);
                                    },
                                    ontap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate:
                                                  DateTime.parse('2022-10-01'))
                                          .then((value) {
                                        cubit.datacontroller.text =
                                            DateFormat.yMMMd().format(value);
                                      }).catchError((onError) {
                                        print("${onError.toString}");
                                      });
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        print("enter the date");
                                      }
                                    },
                                    controller: cubit.datacontroller,
                                    label: "Date",
                                    hint: "Enter the date",
                                    icon: Icons.date_range_sharp,
                                    isShown: false,
                                    istrue: false,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  defaultTextField(
                                    context: context,
                                    onchanege: (value) {
                                      print(value);
                                    },
                                    onsave: (value) {
                                      print(value);
                                    },
                                    ontap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        cubit.timecontroller.text =
                                            value.format(context).toString();
                                      }).catchError((onError) {
                                        print("${onError.toString}");
                                      });
                                    },
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        print("enter the time");
                                      }
                                    },
                                    controller: cubit.timecontroller,
                                    label: "Time",
                                    hint: "Enter the time",
                                    icon: Icons.time_to_leave,
                                    isShown: false,
                                    istrue: false,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                        .closed
                        .then((value) {
                          cubit.changeFloatingsheetStates(
                              isShown: false, icon: Icons.edit);
                        });
                    cubit.changeFloatingsheetStates(
                      isShown: true,
                      icon: Icons.add,
                    );
                  }
                },
                child: Center(
                  child: Icon(cubit.iconfab),
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                  currentIndex: cubit.index,
                  onTap: (value) {
                    cubit.changeScreen(value);
                  },
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home), label: "home"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.done), label: "Done"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.archive), label: "archive"),
                  ]),
              // body: cubit.screen[cubit.index],
              body: ConditionalBuilder(
                condition: states is! AppGetDataBaseLoadingState,
                builder: (context) => cubit.screen[cubit.index],
                fallback: (context) =>
                    Center(child: CircularProgressIndicator()),
              ),
            );
          }),
    );
  }
}
