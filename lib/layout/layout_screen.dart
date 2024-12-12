import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/cubit/cubit.dart';
import 'package:todo_app/cubit/states.dart';
import 'package:todo_app/shared/components/components.dart';

class LayoutScreen extends StatelessWidget {

  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();
  TextEditingController titleController=TextEditingController();
  TextEditingController timeController=TextEditingController();
  TextEditingController dateController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          titleController.clear();
          timeController.clear();
          dateController.clear();

        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              backgroundColor: Colors.blue,
              // leading: cubit.bottomsheet ? IconButton(onPressed: (){
              //   Navigator.pop(context);
              //   cubit.changeBottomSheet(
              //     icon: Icons.edit,
              //     bottomsheet: false,
              //   );
              // }, icon: Icon(
              //   Icons.arrow_back,
              //   color: Colors.white,
              // )
              // ): null,
              title: Text(
                'Tasks',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
                shape: CircleBorder(),
                backgroundColor: Colors.blue,
                child: Icon(
                  cubit.fabicon,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (cubit.bottomsheet) {
                    if(formkey.currentState!.validate())
                    {
                      Navigator.pop(context);
                      cubit.changeBottomSheet(
                        icon: Icons.edit,
                        bottomsheet: false,
                      );
                    }
                  }
                  else {
                    scaffoldkey.currentState!.showBottomSheet(
                          (context) =>Form(
                        key: formkey,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defultTextFormField(
                                controller: titleController,
                                type: TextInputType.text,
                                validate:(value)
                                {
                                  if(value ==null||value.isEmpty)
                                  {
                                    return 'Value must not be Empty';
                                  }
                                  return null;
                                },
                                label: 'Task name',
                                icon: Icon(
                                  Icons.title,
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              defultTextFormField(
                                  controller: timeController,
                                  type: TextInputType.numberWithOptions(),
                                  validate:(value)
                                  {
                                    if(value ==null||value.isEmpty)
                                    {
                                      return 'Title must not be Empty';
                                    }
                                    return null;
                                  },
                                  label: 'Task time',
                                  icon: Icon(
                                    Icons.watch_later_outlined,
                                  ),
                                  ontap: ()
                                  {
                                    showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timeController.text=value!.format(context);
                                    });
                                  }
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              defultTextFormField(
                                  controller: dateController,
                                  type: TextInputType.numberWithOptions(),
                                  validate:(value)
                                  {
                                    if(value ==null||value.isEmpty)
                                    {
                                      return 'Title must not be Empty';
                                    }
                                    return null;
                                  },
                                  label: 'Task date',
                                  icon: Icon(
                                    Icons.history_outlined,
                                  ),
                                  ontap: ()
                                  {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2025-10-14'),
                                    ).then((value)
                                    {
                                      dateController.text=DateFormat.yMMMMd().format(value!);
                                    });
                                  }
                              ),
                            ],
                          ),
                        ),
                      ),
                      elevation: 15.0,

                    ) .closed.then((value) {
                      cubit.changeBottomSheet(
                        icon: Icons.edit,
                        bottomsheet: false,
                      );
                    });
                    cubit.changeBottomSheet(
                        icon: Icons.add,
                        bottomsheet: true);
                  }
                }
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentindex,
              onTap: (index) {
                cubit.changeindex(index: index);
              }
              ,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu_outlined),
                  label: 'New Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_box_outlined),
                  label: 'Done Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archive Tasks',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
