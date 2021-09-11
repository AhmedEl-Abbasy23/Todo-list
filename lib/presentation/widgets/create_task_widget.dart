import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/presentation/widgets/text_form_field_widget.dart';

Widget createTask({
  required context,
  required formKey,
  required titleController,
  required timeController,
  required dateController,
}) =>
    Container(
      width: MediaQuery.of(context).size.width,
      height: 350.0,
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(15.0),
          topLeft: Radius.circular(15.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90.0,
            height: 3.0,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          const SizedBox(height: 20.0),
          Expanded(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  defaultTextFormFiled(
                    context: context,
                    controller: titleController,
                    label: 'Title',
                    prefix: Icons.title,
                    onTap: () {},
                    validate: (value) {
                      if (value.isEmpty) {
                        return 'Please enter task title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  defaultTextFormFiled(
                    context: context,
                    controller: dateController,
                    inputType: TextInputType.datetime,
                    label: 'Date',
                    prefix: Icons.date_range,
                    onTap: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2050),
                      ).then(
                            (value) => {
                          dateController.text =
                              DateFormat.yMMMd().format(value!)
                        },
                      );
                    },
                    validate: (value) {
                      if (value.isEmpty) {
                        return 'Please enter task date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  defaultTextFormFiled(
                    context: context,
                    controller: timeController,
                    inputType: TextInputType.datetime,
                    label: 'Time',
                    prefix: Icons.watch_later_outlined,
                    onTap: () {
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      ).then((value) {
                        timeController.text = value!.format(context).toString();
                      });
                    },
                    validate: (value) {
                      if (value.isEmpty) {
                        return 'Please enter task time';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
