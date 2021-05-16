import 'package:abdaallah2/shared/Cubit/Cubit.dart';
import 'package:abdaallah2/shared/Cubit/States.dart';
import 'package:abdaallah2/shared/component/componentButton.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArchiveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        // ignore: missing_required_param
        return ConditionalBuilder(
          condition: cubit.archivedtask.length > 0,
          builder: (context) => ListView.separated(
            itemBuilder: (context, index) =>
                buildTasksItem(cubit.archivedtask[index], context),
            separatorBuilder: (context, index) => Padding(
              padding: EdgeInsetsDirectional.only(start: 24),
              child: Container(
                color: Colors.grey,
                height: 1,
                width: double.infinity,
              ),
            ),
            itemCount: cubit.newtask.length,
          ),
        );
      },
    );
  }
}
