import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/business_logic/cubit/home_cubit.dart';
import 'package:todo_list/presentation/widgets/create_task_widget.dart';
import 'package:todo_list/presentation/widgets/task_items_widgets.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key, required this.connectionStatus}) : super(key: key);

  final bool connectionStatus;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..createDatabase(),
      child: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          HomeCubit cubit = HomeCubit.get(context);
          return SafeArea(
            child: Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Colors.purple,
                title: const Text('Tasks'),
              ),
              body: connectionStatus
                  ? StreamBuilder<QuerySnapshot>(
                      stream: cubit.getTaskFromFirebase(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                              child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ));
                        }

                        return firebaseTaskItem(snapshot.data!);
                      },
                    )
                  : tasksBuilder(tasks: cubit.tasks),
              //tasksBuilder(tasks: cubit.tasks),
              floatingActionButton: FloatingActionButton(
                child: Icon(cubit.fabIcon, color: Colors.white),
                backgroundColor: Theme.of(context).primaryColor,
                onPressed: () async {
                  if (cubit.isBottomSheetShown) {
                    if (formKey.currentState!.validate()) {
                      cubit.insertToDatabase(
                        title: _titleController.text,
                        date: _dateController.text,
                        time: _timeController.text,
                      );
                      // To empty (TextFormFields) after insert.
                      _titleController.clear();
                      _dateController.clear();
                      _timeController.clear();
                    }
                  } else {
                    scaffoldKey.currentState!
                        .showBottomSheet(
                          (context) => createTask(
                            context: context,
                            formKey: formKey,
                            titleController: _titleController,
                            timeController: _timeController,
                            dateController: _dateController,
                          ),
                          elevation: 25.0,
                        )
                        .closed
                        .then((value) {
                      cubit.changeBottomSheetState(
                        isShow: false,
                        icon: Icons.edit,
                      );
                    });
                    // else => if bottom sheet is shown.
                    cubit.changeBottomSheetState(
                      isShow: true,
                      icon: Icons.add,
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
