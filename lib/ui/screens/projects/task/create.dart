import 'package:flutter/material.dart';
import 'package:progress_app/shared/constants.dart';
import 'package:progress_app/shared/header.dart';
import 'package:progress_app/shared/input_field.dart';
import 'package:progress_app/shared/primary_button.dart';
import 'package:progress_app/shared/title_with_more_btn.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({Key? key}) : super(key: key);

  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  String priority = "Normal";
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  /// The method for [DateRangePickerSelectionChanged] callback, which will be
  /// called whenever a selection changed on the date picker widget.
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: 'Create Task'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: const [
                  TitleWithCustomUnderline(title: 'Add Task'),
                ],
              ),
              InputField("Task Title", TextEditingController()),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Description",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: kDefaultPadding * .5),
                    TextField(
                      controller: TextEditingController(),
                      minLines: 5,
                      maxLines: null,
                      decoration: progressTextInputDecoration,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Priority",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: kDefaultPadding * .5),
                    DropdownButton(
                      isExpanded: true,
                      value: priority,
                      icon: const Icon(Icons.arrow_drop_down),
                      onChanged: (String? value) {
                        setState(() {
                          priority = value!;
                        });
                      },
                      items: <String>["Low", "Normal", "High"]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                            value: value, child: Text(value));
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Start Date - Due Date",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: kDefaultPadding * .5),
                    MaterialButton(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        padding: const EdgeInsets.all(kDefaultPadding * 0.75),
                        color: Colors.grey.shade100,
                        minWidth: double.infinity,
                        child: const Text(
                          "Picker Date",
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () => showModalBottomSheet<void>(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25.0))),
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: MediaQuery.of(context).viewInsets,
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                      kDefaultPadding * .5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        "Start Date - Due Date",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SfDateRangePicker(
                                        showActionButtons: true,
                                        enablePastDates: false,
                                        showTodayButton: true,
                                        selectionMode:
                                            DateRangePickerSelectionMode.range,
                                            onSelectionChanged: _onSelectionChanged,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })),
                  ],
                ),
              ),
              PrimaryButton(text: "Save", press: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
