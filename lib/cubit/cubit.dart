import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() :super(InitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentindex = 0;
  IconData fabicon = Icons.edit;
  bool bottomsheet = false;

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

  void createDatebase()
  {

  }
}