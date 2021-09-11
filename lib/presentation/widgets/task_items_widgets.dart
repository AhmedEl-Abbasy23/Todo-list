import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/business_logic/cubit/home_cubit.dart';

// Firebase task item.

Widget firebaseTaskItem(QuerySnapshot snapshot) {
  return snapshot.size > 0
      ? ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: snapshot.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.docs[index];
            return Dismissible(
              key: Key(doc.id),
              background: Container(color: Colors.red),
              onDismissed: (direction) {
                // delete the doc from the database
                HomeCubit.get(context).deleteTaskFromFirebase(doc.id);
              },
              child: Card(
                margin: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 35.0,
                        backgroundColor: Colors.white,
                        child: Text(
                          doc['time'],
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15.0),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doc['title'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 3.0),
                            Text(
                              doc['date'],
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          })
      : noTasks();
}

// Sqflite local database.
Widget tasksBuilder({required tasks}) => tasks.length > 0
    ? ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.grey[400],
          ),
        ),
        itemCount: tasks.length,
      )
    : noTasks();

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 35.0,
                backgroundColor: Colors.white,
                child: Text(
                  model['time'],
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 15.0),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model['title'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3.0),
                    Text(
                      model['date'],
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onDismissed: (direction) {
        HomeCubit.get(context).deleteFromDatabase(id: model['id']);
      },
    );
// Shared widget
Widget noTasks() => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.menu,
            color: Colors.grey,
            size: 50.0,
          ),
          Text(
            'No tasks yet, try to add some tasks.',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ],
      ),
    );
