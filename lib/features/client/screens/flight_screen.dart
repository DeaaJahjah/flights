import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flights/core/widgets/custom_snackbar.dart';
import 'package:flights/features/auth/screens/company_profile_screen.dart';
import 'package:flights/features/client/providers/ticket_provider.dart';
import 'package:flights/features/client/widgets/next_back_buttons.dart';
import 'package:flights/features/client/widgets/select_return_flight.dart';
import 'package:flights/features/client/widgets/show_up_animation.dart';
import 'package:flights/features/client/widgets/text.dart';
import 'package:flights/features/flights/providers/fllights_providers.dart';
import 'package:flights/utils/r.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class FlightScreen extends StatefulWidget {
  const FlightScreen({super.key, required this.tabController});
  final TabController tabController;

  @override
  State<FlightScreen> createState() => _FlightScreenState();
}

class _FlightScreenState extends State<FlightScreen> {
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
      context.read<FlightsProvider>().filterFlightsByDay(leavingDate: context.read<TicketProvider>().leavingDate!);
    });
    super.initState();
  }

  Set<String> selected = <String>{'one'};

  @override
  Widget build(BuildContext context) {
    return Consumer<FlightsProvider>(builder: (context, provider, child) {
      return Column(children: [
        if (context.read<TicketProvider>().returnDate != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SegmentedButton(
              selected: selected,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return R.secondaryColor;
                    }
                    return R.primaryColor;
                  },
                ),
              ),
              segments: [
                const ButtonSegment(value: 'one', label: Text('رحلة الذهاب')),
                if (context.read<TicketProvider>().returnDate != null)
                  const ButtonSegment(value: 'two', label: Text('رحلة الإياب'))
              ],
              onSelectionChanged: (p0) {
                if (p0.contains('one')) {
                  context
                      .read<FlightsProvider>()
                      .filterFlightsByDay(leavingDate: context.read<TicketProvider>().leavingDate!);
                } else {
                  context
                      .read<FlightsProvider>()
                      .filterReturnFlightsByDay(returnDate: context.read<TicketProvider>().returnDate!);
                }
                selected = p0;
                setState(() {});
              },
            ),
          ),
        // Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        // children: [
        if (selected.contains('one')) _adddatebar(),
        if (selected.contains('one'))
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextUtil(
                        text: "عدد الرحلات المتاحة ${provider.filterdListByDate.length}",
                        color: Colors.white,
                        weight: true,
                        size: 14,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: SizedBox(
                          // height: MediaQuery.of(context).size.height / 2,
                          // width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              itemCount: provider.filterdListByDate.length,
                              shrinkWrap: true,
                              // scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final flight = provider.filterdListByDate[index];

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
                                        context.read<TicketProvider>().selecteFlight(flight.copyWith(index: 0));
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
                      ),
                    ],
                  ))),
        // : const SizedBox(),
        if (selected.contains('two')) const Expanded(flex: 1, child: SelecteReturnFlight()),

        NextBackButtons(
          onNext: () {
            final provider = context.read<TicketProvider>();
            if (provider.returnDate != null && provider.selectedFlights.length != 2) {
              showErrorSnackBar(context, 'الرجاء اختيار رحلة الذهاب والأياب');
              return;
            }
            if (provider.selectedFlights.isEmpty) {
              showErrorSnackBar(context, 'الرجاء اختيار رحلة');
              return;
            }
            widget.tabController.animateTo(2);
          },
          onBack: () {
            widget.tabController.animateTo(0);
          },
        )
      ]);
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
            initialSelectedDate: context.read<TicketProvider>().leavingDate,
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
                context.read<FlightsProvider>().filterFlightsByDay(leavingDate: _selectedDate);

                update();
              });
            },
          ),
        ],
      ),
    );
  }
}
