import 'package:flights/core/enums/enums.dart';
import 'package:flights/core/utils/validators.dart';
import 'package:flights/core/widgets/custom_progress.dart';
import 'package:flights/core/widgets/custom_snackbar.dart';
import 'package:flights/core/widgets/custom_text_field.dart';
import 'package:flights/core/widgets/filled_button.dart';
import 'package:flights/features/flights/models/flight.dart';
import 'package:flights/features/flights/providers/fllights_providers.dart';
import 'package:flights/utils/r.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class FlightCard extends StatelessWidget {
  final Flight flightData;
  final bool withPrice;
  final double ticketPrice;

  const FlightCard({
    Key? key,
    required this.flightData,
    this.ticketPrice = 0.0,
  })  : withPrice = false,
        super(key: key);

  const FlightCard.withPrice({
    Key? key,
    required this.flightData,
    required this.ticketPrice,
  })  : withPrice = true,
        super(key: key);

  TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm(); //"6:00 AM"
    return TimeOfDay.fromDateTime(format.parse(tod));
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          left: withPrice ? 16.0 : 32.0,
          top: 32.0,
          right: withPrice ? 16.0 : 32.0,
          bottom: withPrice ? 16.0 : 0.0,
        ),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: R.secondaryColor)),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildLeftColumn(),
                  ),
                  Expanded(
                    child: _buildMiddlePart(),
                  ),
                  Expanded(
                    child: _buildRightColumn(),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              if (withPrice) const SizedBox(height: 6.0),
              Divider(
                color: R.secondaryColor,
              ),
              Container(
                // margin: const EdgeInsets.only(top: 5),
                padding: const EdgeInsets.all(10),
                // decoration:
                //     BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: R.secondaryColor)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.flight_class_outlined, color: R.secondaryColor),
                        const SizedBox(width: 10),
                        const Text('عدد الكراسي الكلي: ', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 10),
                        Text('${flightData.seats.length}',
                            style: TextStyle(color: R.secondaryColor, fontSize: 24.0, fontFamily: fontFamily)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        // Icon(Icons.flight_class_outlined, color: R.secondaryColor),
                        const SizedBox(width: 35),
                        const Text('عدد الكراسي vip المتاحة: ', style: TextStyle(fontFamily: fontFamily)),
                        const SizedBox(width: 10),
                        Text('${flightData.countSeats('Business')}',
                            style: TextStyle(color: R.secondaryColor, fontSize: 24.0, fontFamily: fontFamily)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        // Icon(Icons.flight_class_outlined, color: R.secondaryColor),
                        const SizedBox(width: 35),
                        const Text('عدد الكراسي normal المتاحة: ',
                            style: TextStyle(
                              fontSize: 14,
                            )),
                        const SizedBox(width: 10),
                        Text('${flightData.countSeats('Normal')}',
                            style: TextStyle(color: R.secondaryColor, fontSize: 24.0, fontFamily: fontFamily)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Divider(
                color: R.secondaryColor,
              ),
              _buildPriceArea(),
              const SizedBox(height: 20),
              CustomFilledButton(
                  onPressed: () async {
                    await showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        DateTime? lunchDate = flightData.lunchDate;
                        TimeOfDay? lunchTime = TimeOfDay(
                            hour: int.parse(flightData.lunchTime.split(':')[0]),
                            minute: int.parse(flightData.lunchTime[3] + flightData.lunchTime[4]));
                        TimeOfDay? arriveTime = TimeOfDay(
                            hour: int.parse(flightData.arriveTime.split(':')[0]),
                            minute: int.parse(flightData.arriveTime[3] + flightData.arriveTime[4]));

                        DateTime? arriveDate = flightData.arriveDate;

                        final lunchDateController = TextEditingController(
                            text:
                                '${flightData.lunchDate.year}-${flightData.lunchDate.month}-${flightData.lunchDate.day}');
                        final lunchTimeController = TextEditingController(text: flightData.lunchTime);
                        final arriveDateController = TextEditingController(
                            text:
                                '${flightData.arriveDate.year}-${flightData.arriveDate.month}-${flightData.arriveDate.day}');
                        final arriveTimeController = TextEditingController(text: flightData.arriveTime);
                        final formKey = GlobalKey<FormState>();

                        return Form(
                          key: formKey,
                          child: Container(
                            width: MediaQuery.sizeOf(context).width,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: R.primaryColor,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                const Text('تأجيل موعد الرجلة', style: TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),

                                //
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        labelText: 'تاريخ الانطلاق',
                                        prefixIcon: Icon(Icons.date_range, color: R.secondaryColor),
                                        mainColor: R.secondaryColor,
                                        secondaryColor: R.tertiaryColor,
                                        controller: lunchDateController,
                                        keyboardType: TextInputType.text,
                                        readOnly: true,
                                        validator: emptyValidator,
                                        onTap: () async {
                                          lunchDate = await showRoundedDatePicker(
                                            context: context,
                                            lastDate: DateTime(2026),
                                            initialDate: lunchDate,
                                            theme: ThemeData(primarySwatch: Colors.amber),
                                            // firstDate: DateTime(2000),
                                          );
                                          if (lunchDate == null) {
                                            lunchDateController.text = '';
                                          } else {
                                            lunchDateController.text =
                                                ('${lunchDate!.year}-${lunchDate!.month}-${lunchDate!.day}').toString();
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: CustomTextField(
                                        labelText: 'وقت الانطلاق',
                                        prefixIcon: Icon(Icons.timelapse_outlined, color: R.secondaryColor),
                                        mainColor: R.secondaryColor,
                                        secondaryColor: R.tertiaryColor,
                                        controller: lunchTimeController,
                                        keyboardType: TextInputType.text,
                                        validator: emptyValidator,
                                        readOnly: true,
                                        onTap: () async {
                                          lunchTime = await showTimePicker(context: context, initialTime: lunchTime!);

                                          if (lunchTime == null) {
                                            lunchTimeController.text = '';
                                          } else {
                                            lunchTimeController.text =
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
                                        controller: arriveDateController,
                                        keyboardType: TextInputType.text,
                                        validator: emptyValidator,
                                        readOnly: true,
                                        onTap: () async {
                                          arriveDate = await showRoundedDatePicker(
                                            context: context,
                                            lastDate: DateTime(2026),
                                            initialDate: arriveDate,
                                            theme: ThemeData(primarySwatch: Colors.amber),
                                            // firstDate: DateTime(2000),
                                          );
                                          if (arriveDate == null) {
                                            arriveDateController.text = '';
                                          } else {
                                            arriveDateController.text =
                                                ('${arriveDate!.year}-${arriveDate!.month}-${arriveDate!.day}')
                                                    .toString();
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: CustomTextField(
                                        labelText: 'وقت الوصول',
                                        prefixIcon: Icon(Icons.timelapse_outlined, color: R.secondaryColor),
                                        mainColor: R.secondaryColor,
                                        secondaryColor: R.tertiaryColor,
                                        controller: arriveTimeController,
                                        keyboardType: TextInputType.text,
                                        validator: emptyValidator,
                                        readOnly: true,
                                        onTap: () async {
                                          arriveTime = await showTimePicker(context: context, initialTime: arriveTime!);
                                          if (arriveTime == null) {
                                            arriveTimeController.text = '';
                                          } else {
                                            arriveTimeController.text =
                                                '${arriveTime!.hour}:${arriveTime!.minute} ${arriveTime!.period.name}';
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                context.watch<FlightsProvider>().postponingDataState != DataState.loading
                                    ? CustomFilledButton(
                                        onPressed: () async {
                                          FocusScope.of(context).unfocus();
                                          if (!formKey.currentState!.validate()) {
                                            return;
                                          }
                                          formKey.currentState!.save();

                                          final Flight flight = flightData.copyWith(
                                            lunchDate: lunchDate!,
                                            lunchTime: lunchTimeController.text,
                                            arriveTime: arriveTimeController.text,
                                            arriveDate: arriveDate!,
                                          );

                                          await context.read<FlightsProvider>().postponingFlight(flight: flight);
                                          if (context.read<FlightsProvider>().dataState == DataState.failure) {
                                            showErrorSnackBar(context, 'حدث خطأ عند تأجيل الرحلة');
                                            return;
                                          }
                                          await context.read<FlightsProvider>().getCompanyFlights();
                                          Navigator.pop(context);
                                        },
                                        text: 'موافق')
                                    : const CustomProgress()
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  text: 'تأجيل موعد الرحلة'),
            ],
          ),
        ),
      );

  String extractTime(DateTime dateTime) {
    String time =
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";

    return time;
  }

  Widget _buildLeftColumn() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            flightData.from,
            style: TextStyle(color: R.secondaryColor, fontSize: 32.0),
          ),
          const SizedBox(
            height: 6.0,
          ),
          // Text(
          //   flightData.departure,
          //   style: const TextStyle(
          //     color: Colors.white,
          //     fontWeight: FontWeight.bold,
          //     fontSize: 12.0,
          //   ),
          // ),
          const SizedBox(
            height: 24.0,
          ),
          Text(
            "تاريخ الانطلاق",
            style: TextStyle(color: R.tertiaryColor),
          ),
          const SizedBox(
            height: 6.0,
          ),
          Text(
            "${Jiffy.parseFromDateTime(flightData.lunchDate).yMMMd} ${flightData.lunchTime}",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),
        ],
      );

  Widget _buildRightColumn() => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            flightData.to,
            style: TextStyle(color: R.secondaryColor, fontSize: 32.0),
          ),
          const SizedBox(
            height: 6.0,
          ),
          Text(
            "${Jiffy.parseFromDateTime(flightData.arriveDate).yMMMd} ${flightData.arriveTime}",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          Text(
            "رقم الرحلة",
            style: TextStyle(color: R.tertiaryColor),
          ),
          const SizedBox(
            height: 6.0,
          ),
          Text(
            flightData.flightNo,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),
        ],
      );

  Widget _buildMiddlePart() => Column(
        children: [
          Icon(
            Icons.flight_takeoff,
            color: R.secondaryColor,
          ),
          const SizedBox(
            height: 6.0,
          ),
          Text(
            'مدة الرحلة ${flightData.period}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      );

  Widget _buildPriceArea() => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            // mainAxisSize: MainAxisSize.max,
            // crossAxisAlignment: CrossAxisAlignment.baseline,
            // textBaseline: TextBaseline.ideographic,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.attach_money,
                color: R.secondaryColor,
              ),

              const Text("سعر تذكرة vip  ", style: TextStyle(color: Colors.white, fontFamily: fontFamily)),

              Text(
                "${flightData.businessClassCost} ل.س",
                style: TextStyle(color: R.secondaryColor, fontSize: 24.0, fontFamily: fontFamily),
              ),
              // RichText(
              //   text: TextSpan(
              //     children: [
              //       const TextSpan(
              //         text: "سعر تذكرة vip  ",
              //         style: TextStyle(color: Colors.white, fontFamily: fontFamily),
              //       ),
              //       TextSpan(
              //         text: "${flightData.businessClassCost} ل.س",
              //         style: TextStyle(color: R.secondaryColor, fontSize: 24.0, fontFamily: fontFamily),
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
          Row(
            // mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.attach_money,
                color: R.secondaryColor,
              ),
              const Text("سعر تذكرة normal  ", style: TextStyle(color: Colors.white, fontFamily: fontFamily)),
              Text(
                "${flightData.normalClassCost} ل.س",
                style: TextStyle(color: R.secondaryColor, fontSize: 24.0, fontFamily: fontFamily),
              ),
              // RichText(
              //   textAlign: TextAlign.right,
              //   text: const TextSpan(
              //     children: [
              //       TextSpan(
              //         text: "سعر تذكرة normal  ",
              //         style: TextStyle(color: Colors.white, fontFamily: fontFamily),
              //       ),
              // TextSpan(
              //   text: "${flightData.normalClassCost} ل.س",
              //   style: TextStyle(color: R.secondaryColor, fontSize: 24.0, fontFamily: fontFamily),
              // ),
              //   ],
              // ),
              // )
            ],
          ),
        ],
      );
}
