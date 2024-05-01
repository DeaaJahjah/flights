import 'package:flights/core/enums/enums.dart';
import 'package:flights/core/widgets/custom_progress.dart';
import 'package:flights/core/widgets/custom_snackbar.dart';
import 'package:flights/core/widgets/filled_button.dart';
import 'package:flights/features/client/providers/ticket_provider.dart';
import 'package:flights/features/client/widgets/feild.dart';
import 'package:flights/features/client/widgets/text.dart';
import 'package:flights/features/flights/providers/fllights_providers.dart';
import 'package:flights/utils/r.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  final TextEditingController _returnDateController = TextEditingController();

  final TextEditingController _travelerController = TextEditingController(text: '1');
  final TextEditingController _classController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<String> trips = ["ذهاب", "ذهاب و اياب"];
  int selectTrip = 0;
  String selectedClass = classes[0];

  DateTime? returnDate;
  DateTime? leavingDate;

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
    // _fromController.dispose();
    // _toController.dispose();
    // _dateController.dispose();
    // _travelerController.dispose();
    // _classController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Form(
          key: _formKey,
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
                            if (trips[i] == 'ذهاب') {
                              returnDate = null;
                              _returnDateController.text = '';
                            }
                            setState(() {
                              selectTrip = i;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                        color: i == 2 ? Colors.transparent : Theme.of(context).canvasColor))),
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
                  leavingDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2025),
                  );
                  if (leavingDate == null) {
                    _dateController.text = '';
                  } else {
                    _dateController.text = '${leavingDate!.year}-${leavingDate!.month}-${leavingDate!.day}';
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              if (selectTrip == 1) ...[
                Field(
                  controller: _returnDateController,
                  hinttext: "تاريخ العودة",
                  icon: Icons.calendar_month,
                  readOnly: true,
                  onTap: () async {
                    returnDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2023),
                      lastDate: DateTime(2025),
                    );
                    if (returnDate == null) {
                      _returnDateController.text = '';
                      returnDate = null;
                    } else {
                      _returnDateController.text = '${returnDate!.year}-${returnDate!.month}-${returnDate!.day}';
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
              Row(
                children: [
                  Row(
                    children: [
                      Icon(Icons.group, color: R.secondaryColor),
                      const SizedBox(width: 10),
                      const Text('عدد المسافرين', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  const SizedBox(width: 20),
                  DropdownButton(
                      style: TextStyle(color: R.secondaryColor, fontFamily: fontFamily),
                      dropdownColor: R.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                      value: int.parse(_travelerController.text),
                      onChanged: (v) {
                        setState(() {
                          // selectedClass = v
                          _travelerController.text = v.toString();
                        });
                      },
                      items: List.generate(
                          10,
                          (index) => DropdownMenuItem(
                                value: index + 1,
                                child: Text('${index + 1}'),
                              ))),
                ],
              ),
              // Field(
              //   controller: _travelerController,
              //   hinttext: "عدد المسافرين",
              //   icon: Icons.group,
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
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
              const SizedBox(
                height: 30,
              ),
              context.watch<FlightsProvider>().dataState == DataState.loading
                  ? const CustomProgress()
                  : CustomFilledButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          showErrorSnackBar(context, 'الرجاء ادخال الحقول');
                          return;
                        }
                        context.read<FlightsProvider>().filterdListByDate = [];
                        context.read<FlightsProvider>().returnedFilterdListByDate = [];

                        context.read<FlightsProvider>().filterFlights(
                              from: _fromController.text,
                              to: _toController.text,
                              flightClass: _classController.text,
                              leavingDate: leavingDate,
                              returnDate: returnDate,
                              travelerNumber: int.parse(_travelerController.text),
                            );

                        context.read<TicketProvider>().flightClass = selectedClass;
                        context.read<TicketProvider>().selectedFlights = [];
                        context.read<TicketProvider>().returnSelectedSeat = [];
                        context.read<TicketProvider>().leavingSelectedSeat = [];

                        context
                            .read<TicketProvider>()
                            .updateInfo(leavingDate, returnDate, int.parse(_travelerController.text));

                        // context.read<TicketProvider>().ticket. = selectedClass;

                        widget.tabController.animateTo(1);
                      },
                      text: 'التالي',
                    )
            ],
          ),
        ),
      ),
    );
  }
}
