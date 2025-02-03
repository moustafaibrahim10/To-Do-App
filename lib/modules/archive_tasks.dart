import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/states.dart';

import '../cubit/cubit.dart';
import '../shared/components/components.dart';

class ArchiveTasks extends StatelessWidget {
  const ArchiveTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state) {},
      builder: (context,state)
      {
        var tasks=AppCubit.get(context).archivetasks;
        return defultTaskScren(tasks: tasks);
      },
    );
  }
}
