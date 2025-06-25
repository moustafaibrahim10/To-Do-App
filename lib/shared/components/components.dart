import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/cubit/cubit.dart';

Widget defultTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String? Function(String?)? validate,
  required String label,
  required Widget icon,
  void Function()? ontap,

}) => TextFormField(
  controller: controller,
  keyboardType: type,
  validator: validate,
  onTap: ontap,
  decoration: InputDecoration(
    labelText: label,
    prefixIcon: icon,
    border: OutlineInputBorder(),
  ),
);


Widget defultTaskitem (Map model,context) => Dismissible(
 key: Key(model['id'].toString()),
  child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 40.0,
          backgroundColor: Colors.teal,
          child: Text(
            '${model['time']}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${model['title']}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${model['date']}',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        IconButton(
            onPressed: ()
            {
              AppCubit.get(context).updateDatabase(
                  status: 'done',
                  id: model['id']);
            },
            icon: Icon(
              Icons.check_box,
              color: Colors.green,
            )),
        IconButton(
            onPressed: ()
            {
              AppCubit.get(context).updateDatabase(
                  status: 'archive',
                  id: model['id']);
            },
            icon: Icon(
              Icons.archive_sharp,
              color: Colors.black45,
            )),

      ],
    ),
  ),
  onDismissed: (direction)
  {
    AppCubit.get(context).deleteDataFromDatabase(id: model['id']);
  },
) ;


Widget defultTaskScren(
{
  required List<Map> tasks
}
) =>ConditionalBuilder(
    condition: tasks.length>0,
    builder: (context) => ListView.separated(
      itemBuilder: (context,index) => defultTaskitem(tasks[index],context),
      separatorBuilder: (context,index) => Container(
        width: double.infinity,
        height: 1.0 ,
        color: Colors.grey[200],
      ),
      itemCount: tasks.length,
    ),
    fallback: (context) =>
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.menu,
                color: Colors.grey,
                size: 100,
              ),
              Text(
                '        No tasks yet \n Please add some tasks',
                style: TextStyle(
                  fontSize: 20.0,
                ),),
            ],
          ),
        ));
