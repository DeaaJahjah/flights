import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flights/features/auth/screens/company_profile_screen.dart';
import 'package:flights/features/client/providers/ticket_provider.dart';
import 'package:flights/features/client/widgets/show_up_animation.dart';
import 'package:flights/features/client/widgets/text.dart';
import 'package:flights/features/flights/providers/fllights_providers.dart';
import 'package:flights/utils/r.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class SelecteReturnFlight extends StatefulWidget {
  const SelecteReturnFlight({super.key});

  @override
  State<SelecteReturnFlight> createState() => _SelecteReturnFlightState();
}

class _SelecteReturnFlightState extends State<SelecteReturnFlight> {
  DateTime _selectedDate = DateTime.now();
  bool isLoad = true;
  int? selctedIndex;

  void update() {
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        isLoad = true;
      });
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      context.read<FlightsProvider>().filterReturnFlightsByDay(
            returnDate: context.read<TicketProvider>().returnDate!,
          );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FlightsProvider>(builder: (context, provider, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _adddatebar(),
          isLoad
              ? Expanded(
                  child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextUtil(
                        text: "عدد الرحلات المتاحة ${provider.returnedFilterdListByDate.length}",
                        color: Colors.white,
                        weight: true,
                        size: 14,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: provider.returnedFilterdListByDate.length,
                            shrinkWrap: true,
                            // scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final flight = provider.returnedFilterdListByDate[index];

                              selctedIndex =
                                  context.read<TicketProvider>().selectedFlights.contains(flight) ? index : null;
                              final ticketPrice = context.read<TicketProvider>().flightClass == 'Business'
                                  ? flight.businessClassCost
                                  : flight.normalClassCost;
                              return ShowUpAnimation(
                                  delay: 150,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selctedIndex = index;
                                      });
                                      print(context.read<TicketProvider>().selectedFlights.length);
                                      context.read<TicketProvider>().selecteFlight(flight.copyWith(index: 1));
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          margin: const EdgeInsets.only(bottom: 15),
                                          height: 200,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: selctedIndex == index
                                                      ? Theme.of(context).indicatorColor
                                                      : Theme.of(context).canvasColor)),
                                          child: Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).pushNamed(CompanyProfileScreen.routeName,
                                                      arguments: flight.userId);
                                                },
                                                child: Row(
                                                  children: [
                                                    flight.logo != null
                                                        ? CircleAvatar(
                                                            radius: 20,
                                                            backgroundColor: Colors.transparent,
                                                            backgroundImage: NetworkImage(flight.logo!))
                                                        : const CircleAvatar(
                                                            radius: 20,
                                                            backgroundColor: Colors.transparent,
                                                            backgroundImage: AssetImage(
                                                              "assets/images/pick_image.png",
                                                            )),
                                                    const SizedBox(width: 10),
                                                    Text(flight.userName)
                                                  ],
                                                ),
                                              ),
                                              const Spacer(),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      TextUtil(
                                                        text: flight.from,
                                                        color: selctedIndex == index
                                                            ? Theme.of(context).indicatorColor
                                                            : Colors.white,
                                                        size: 28,
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      // TextUtil(
                                                      //   text: 'من',
                                                      //   color: Colors.white,
                                                      //   size: 12,
                                                      //   weight: true,
                                                      // )
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      TextUtil(
                                                        text: flight.to,
                                                        color: selctedIndex == index
                                                            ? Theme.of(context).indicatorColor
                                                            : Colors.white,
                                                        size: 28,
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      // TextUtil(
                                                      //   text: flightList[0].destinationName,
                                                      //   color: Colors.white,
                                                      //   size: 12,
                                                      //   weight: true,
                                                      // )
                                                    ],
                                                  )
                                                ],
                                              ),
                                              const Spacer(),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      TextUtil(
                                                        text: "تاريخ الرحلة",
                                                        color: Theme.of(context).canvasColor,
                                                        size: 12,
                                                        weight: true,
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      TextUtil(
                                                        text:
                                                            "${Jiffy.parseFromDateTime(flight.lunchDate).yMMMd} ${flight.lunchTime}",
                                                        color: Colors.white,
                                                        size: 13,
                                                        weight: true,
                                                      )
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      TextUtil(
                                                        text: "رقم الرحلة",
                                                        color: Theme.of(context).canvasColor,
                                                        size: 12,
                                                        weight: true,
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      TextUtil(
                                                        text: flight.flightNo,
                                                        color: Colors.white,
                                                        size: 13,
                                                        weight: true,
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                              const Spacer(),
                                              Divider(
                                                color: selctedIndex == index
                                                    ? Theme.of(context).indicatorColor
                                                    : Colors.white,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      text: 'سعر التذكرة ',
                                                      style: TextStyle(
                                                          fontFamily: fontFamily,
                                                          fontWeight: FontWeight.bold,
                                                          color: Theme.of(context).canvasColor,
                                                          fontSize: 14),
                                                      children: <TextSpan>[
                                                        TextSpan(
                                                          text: "\$ $ticketPrice",
                                                          style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              color: selctedIndex == index
                                                                  ? Theme.of(context).indicatorColor
                                                                  : Colors.white,
                                                              fontSize: 17),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.credit_card,
                                                    color: selctedIndex == index
                                                        ? Theme.of(context).indicatorColor
                                                        : Colors.white,
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 40,
                                          child: Container(
                                            height: 60,
                                            width: 60,
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                gradient: LinearGradient(
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    stops: const [
                                                      0.5,
                                                      0.5
                                                    ],
                                                    colors: [
                                                      Theme.of(context).canvasColor,
                                                      Theme.of(context).primaryColor,
                                                    ])),
                                            child: Container(
                                              padding: const EdgeInsets.only(top: 10),
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Theme.of(context).primaryColor,
                                              ),
                                              child: Column(
                                                children: [
                                                  Transform.rotate(
                                                      angle: 6,
                                                      child: Icon(
                                                        Icons.flight_takeoff,
                                                        size: 25,
                                                        color: selctedIndex == index
                                                            ? Theme.of(context).indicatorColor
                                                            : Colors.white,
                                                      )),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextUtil(
                                                    text: flight.period,
                                                    color: Colors.white,
                                                    size: 11,
                                                    weight: true,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ));
                            }),
                      ),
                    ],
                  ),
                ))
              : const SizedBox(),
        ],
      );
    });
  }

  _adddatebar() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          DatePicker(
            DateTime.now(),
            height: 85,
            width: 60,
            initialSelectedDate: context.read<TicketProvider>().returnDate,
            selectedTextColor: Theme.of(context).primaryColor,
            selectionColor: Theme.of(context).indicatorColor,
            dateTextStyle: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 17),
            dayTextStyle: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).canvasColor, fontSize: 11),
            monthTextStyle: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).canvasColor, fontSize: 11),
            onDateChange: (date) {
              setState(() {
                _selectedDate = date;
                isLoad = false;
                selctedIndex = null;
                context.read<FlightsProvider>().filterReturnFlightsByDay(returnDate: _selectedDate);

                update();
              });
            },
          ),
        ],
      ),
    );
  }
}
