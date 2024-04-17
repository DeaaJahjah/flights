import 'package:flights/core/widgets/filled_button.dart';
import 'package:flights/features/client/widgets/feild.dart';
import 'package:flights/features/client/widgets/text.dart';
import 'package:flights/utils/r.dart';
import 'package:flutter/material.dart';

class RouteScreen extends StatefulWidget {
  const RouteScreen({super.key, required this.tabController});
  final TabController tabController;

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _travelerController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  List<String> trips = ["ذهاب", "ذهاب و اياب"];
  int selectTrip = 0;
  String selectedClass = classes[0];

  final List<DropdownMenuItem> _classes = [
    DropdownMenuItem(
      value: classes[0],
      child: const Text('سياحية'),
    ),
    DropdownMenuItem(
      value: classes[1],
      child: const Text('أعمال'),
    )
  ];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _fromController.dispose();
    _toController.dispose();
    _dateController.dispose();
    _travelerController.dispose();
    _classController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Theme.of(context).canvasColor))),
              child: Row(
                children: [
                  for (int i = 0; i < trips.length; i++) ...[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectTrip = i;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  right:
                                      BorderSide(color: i == 2 ? Colors.transparent : Theme.of(context).canvasColor))),
                          alignment: Alignment.center,
                          child: TextUtil(
                            text: trips[i],
                            weight: true,
                            size: 14,
                            color: selectTrip == i ? Theme.of(context).indicatorColor : Theme.of(context).canvasColor,
                          ),
                        ),
                      ),
                    )
                  ]
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Field(
              controller: _fromController,
              hinttext: "من",
              icon: Icons.flight_takeoff,
            ),
            const SizedBox(
              height: 30,
            ),
            Field(
              controller: _toController,
              hinttext: "إلى",
              icon: Icons.flight_land,
            ),
            const SizedBox(
              height: 30,
            ),
            Field(
              controller: _dateController,
              hinttext: "تاريخ المغادرة",
              icon: Icons.calendar_month,
              readOnly: true,
              onTap: () async {
                // final date = await showDatePicker(
                //   context: context,
                //   firstDate: DateTime(2023),
                //   lastDate: DateTime(2025),
                // );
                // if (date == null) {
                //   _dateController.text = '';
                // }
                // _dateController.text = '${date!.year}-${date.month}-${date.day}';

                showTimePicker(context: context, initialTime: TimeOfDay.now());
              },
            ),
            const SizedBox(
              height: 30,
            ),
            Field(
              controller: _travelerController,
              hinttext: "عدد المسافرين",
              icon: Icons.group,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  Row(
                    children: [
                      Icon(Icons.flight_class_outlined, color: R.secondaryColor),
                      const SizedBox(width: 10),
                      const Text('الدرجة', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(width: 20),
                  DropdownButton(
                      hint: const Text('الدرجة'),
                      value: selectedClass,
                      style: TextStyle(color: R.secondaryColor, fontFamily: fontFamily),
                      items: _classes,
                      dropdownColor: R.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                      onChanged: (v) {
                        setState(() {
                          selectedClass = v;
                          print(selectedClass);
                        });
                      }),
                ],
              ),
            ),
            // Field(
            //   controller: _classController,
            //   hinttext: "الفئة",
            //   icon: Icons.airline_seat_recline_extra,
            // ),
            const SizedBox(
              height: 30,
            ),
            CustomFilledButton(
              onPressed: () {
                widget.tabController.animateTo(1);
              },
              text: 'التالي',
            )
          ],
        ),
      ),
    );
  }
}
