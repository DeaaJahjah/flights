import 'package:flights/core/enums/enums.dart';
import 'package:flights/core/extensions/firebase.dart';
import 'package:flights/core/utils/shred_prefs.dart';
import 'package:flights/core/utils/validators.dart';
import 'package:flights/core/widgets/custom_progress.dart';
import 'package:flights/core/widgets/custom_snackbar.dart';
import 'package:flights/core/widgets/custom_text_field.dart';
import 'package:flights/core/widgets/filled_button.dart';
import 'package:flights/features/flights/models/flight.dart';
import 'package:flights/features/flights/providers/fllights_providers.dart';
import 'package:flights/utils/r.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreateFlightScreen extends StatefulWidget {
  static const routeName = '/create-flight-screen';
  const CreateFlightScreen({super.key});

  @override
  State<CreateFlightScreen> createState() => _CreateFlightScreenState();
}

class _CreateFlightScreenState extends State<CreateFlightScreen> {
  // Flight flight = Flight(userId: userId, userName: userName,      seats: seats)
  final _flightNoController = TextEditingController();
  final _airplaneNoController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _lunchDateController = TextEditingController();
  final _lunchTimeController = TextEditingController();
  final _arriveDateController = TextEditingController();
  final _arriveTimeController = TextEditingController();
  final _businessClassCostController = TextEditingController();
  final _normalClassCostController = TextEditingController();
  final _numberOfNormalSeatsController = TextEditingController();
  final _numberOfVIPSeatsController = TextEditingController();
  final _periodController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  DateTime? lunchDate;
  TimeOfDay? lunchTime;
  TimeOfDay? arriveTime;

  DateTime? arriveDate;

  // final _normalClassController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final flightProvider = context.read<FlightsProvider>();

    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'إضافة رحلة',
        style: TextStyle(fontFamily: fontFamily),
      )),
      body: Center(
        child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.8,
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const Text('معلومات الرحلة'),
                  CustomTextField(
                    labelText: 'رقم الرحلة',
                    prefixIcon: Icon(Icons.numbers_outlined, color: R.secondaryColor),
                    mainColor: R.secondaryColor,
                    secondaryColor: R.tertiaryColor,
                    controller: _flightNoController,
                    keyboardType: TextInputType.text,
                    validator: emptyValidator,
                  ),
                  CustomTextField(
                    labelText: 'رقم الطائرة',
                    prefixIcon: Icon(Icons.numbers, color: R.secondaryColor),
                    mainColor: R.secondaryColor,
                    secondaryColor: R.tertiaryColor,
                    controller: _airplaneNoController,
                    keyboardType: TextInputType.text,
                    validator: emptyValidator,
                  ),
                  CustomTextField(
                    labelText: 'من مدينة',
                    prefixIcon: Icon(Icons.house, color: R.secondaryColor),
                    mainColor: R.secondaryColor,
                    secondaryColor: R.tertiaryColor,
                    controller: _fromController,
                    keyboardType: TextInputType.text,
                    validator: emptyValidator,
                  ),
                  CustomTextField(
                    labelText: 'إلى مدينة',
                    prefixIcon: Icon(Icons.house, color: R.secondaryColor),
                    mainColor: R.secondaryColor,
                    secondaryColor: R.tertiaryColor,
                    controller: _toController,
                    keyboardType: TextInputType.text,
                    validator: emptyValidator,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          labelText: 'تاريخ الانطلاق',
                          prefixIcon: Icon(Icons.date_range, color: R.secondaryColor),
                          mainColor: R.secondaryColor,
                          secondaryColor: R.tertiaryColor,
                          controller: _lunchDateController,
                          keyboardType: TextInputType.text,
                          readOnly: true,
                          validator: emptyValidator,
                          onTap: () async {
                            lunchDate = await showRoundedDatePicker(
                              context: context,
                              lastDate: DateTime(2026),
                              initialDate: DateTime.now(),
                              theme: ThemeData(primarySwatch: Colors.amber),
                              // firstDate: DateTime(2000),
                            );
                            _lunchDateController.text =
                                ('${lunchDate!.year}-${lunchDate!.month}-${lunchDate!.day}').toString();
                          },
                        ),
                      ),
                      Expanded(
                        child: CustomTextField(
                          labelText: 'وقت الانطلاق',
                          prefixIcon: Icon(Icons.timelapse_outlined, color: R.secondaryColor),
                          mainColor: R.secondaryColor,
                          secondaryColor: R.tertiaryColor,
                          controller: _lunchTimeController,
                          keyboardType: TextInputType.text,
                          validator: emptyValidator,
                          readOnly: true,
                          onTap: () async {
                            lunchTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());

                            if (lunchTime == null) {
                              _lunchTimeController.text = '';
                            } else {
                              _lunchTimeController.text =
                                  '${lunchTime!.hour}:${lunchTime!.minute} ${lunchTime!.period.name}';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          labelText: 'تاريخ الوصول',
                          prefixIcon: Icon(Icons.date_range, color: R.secondaryColor),
                          mainColor: R.secondaryColor,
                          secondaryColor: R.tertiaryColor,
                          controller: _arriveDateController,
                          keyboardType: TextInputType.text,
                          validator: emptyValidator,
                          readOnly: true,
                          onTap: () async {
                            arriveDate = await showRoundedDatePicker(
                              context: context,
                              lastDate: DateTime(2026),
                              initialDate: DateTime.now(),
                              theme: ThemeData(primarySwatch: Colors.amber),
                              // firstDate: DateTime(2000),
                            );
                            if (arriveDate != null) {
                              _arriveDateController.text =
                                  ('${arriveDate!.year}-${arriveDate!.month}-${arriveDate!.day}').toString();
                            } else {
                              _arriveDateController.text = '';
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: CustomTextField(
                          labelText: 'وقت الوصول',
                          prefixIcon: Icon(Icons.timelapse_outlined, color: R.secondaryColor),
                          mainColor: R.secondaryColor,
                          secondaryColor: R.tertiaryColor,
                          controller: _arriveTimeController,
                          keyboardType: TextInputType.text,
                          validator: emptyValidator,
                          readOnly: true,
                          onTap: () async {
                            arriveTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                            if (arriveTime == null) {
                              _arriveTimeController.text = '';
                            } else {
                              _arriveTimeController.text =
                                  '${arriveTime!.hour}:${arriveTime!.minute} ${arriveTime!.period.name}';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  CustomTextField(
                    labelText: 'مدة الرحلة',
                    prefixIcon: Icon(Icons.lock_clock, color: R.secondaryColor),
                    mainColor: R.secondaryColor,
                    secondaryColor: R.tertiaryColor,
                    controller: _periodController,
                    keyboardType: TextInputType.text,
                    validator: emptyValidator,
                    // digitsOnly: true,
                  ),
                  CustomTextField(
                    labelText: 'عدد مقاعد vip',
                    prefixIcon: Icon(Icons.chair_rounded, color: R.secondaryColor),
                    mainColor: R.secondaryColor,
                    secondaryColor: R.tertiaryColor,
                    controller: _numberOfVIPSeatsController,
                    keyboardType: TextInputType.text,
                    validator: emptyValidator,
                  ),
                  CustomTextField(
                    labelText: 'تكلفة حجز مقعد vip',
                    prefixIcon: Icon(Icons.attach_money_rounded, color: R.secondaryColor),
                    mainColor: R.secondaryColor,
                    secondaryColor: R.tertiaryColor,
                    controller: _businessClassCostController,
                    keyboardType: TextInputType.text,
                    validator: emptyValidator,
                  ),
                  CustomTextField(
                    labelText: 'عدد مقاعد normal',
                    prefixIcon: Icon(Icons.chair_rounded, color: R.secondaryColor),
                    mainColor: R.secondaryColor,
                    secondaryColor: R.tertiaryColor,
                    controller: _numberOfNormalSeatsController,
                    keyboardType: TextInputType.text,
                    validator: emptyValidator,
                  ),
                  CustomTextField(
                    labelText: 'تكلفة حجز مقعد notmal',
                    prefixIcon: Icon(Icons.attach_money_rounded, color: R.secondaryColor),
                    mainColor: R.secondaryColor,
                    secondaryColor: R.tertiaryColor,
                    controller: _normalClassCostController,
                    keyboardType: TextInputType.text,
                    validator: emptyValidator,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 125, vertical: 20),
                      child: context.watch<FlightsProvider>().dataState != DataState.loading
                          ? CustomFilledButton(
                              onPressed: () async {
                                FocusScope.of(context).unfocus();
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                _formKey.currentState!.save();
                                final Flight flight = Flight(
                                  userId: context.userUid!,
                                  userName: SharedPrefs.prefs.getString('name')!,
                                  logo: SharedPrefs.prefs.getString('image'),
                                  flightNo: _flightNoController.text,
                                  airplaneNo: _airplaneNoController.text,
                                  from: _fromController.text,
                                  to: _toController.text,
                                  lunchDate: lunchDate!,
                                  lunchTime: _lunchTimeController.text,
                                  arriveTime: _arriveTimeController.text,
                                  arriveDate: arriveDate!,
                                  businessClassCost: int.parse(_businessClassCostController.text),
                                  normalClassCost: int.parse(_normalClassCostController.text),
                                  numberOfNormalSeats: int.parse(_numberOfNormalSeatsController.text),
                                  numberOfVIPSeats: int.parse(_numberOfVIPSeatsController.text),
                                  period: _periodController.text,
                                  seats: [
                                    ...List.generate(
                                        int.parse(_numberOfNormalSeatsController.text),
                                        (index) => Seat(
                                            id: const Uuid().v4(),
                                            isVip: true,
                                            available: true,
                                            name: 'NS-${index + 1}'))
                                      ..addAll(List.generate(
                                          int.parse(_numberOfVIPSeatsController.text),
                                          (index) => Seat(
                                              id: const Uuid().v4(),
                                              isVip: false,
                                              available: true,
                                              name: 'VS-${index + 1}')))
                                  ],
                                );

                                await flightProvider.addFlight(flight: flight);

                                if (flightProvider.dataState == DataState.failure) {
                                  showErrorSnackBar(context, 'حدث خطأ عند اضافة رحلة');
                                  return;
                                }
                                flightProvider.getCompanyFlights();
                                Navigator.pop(context);
                              },
                              text: 'موافق')
                          : const CustomProgress()),
                ],
              ),
            )),
      ),
    );
  }
}
