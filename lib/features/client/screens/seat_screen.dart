import 'package:flights/core/widgets/custom_snackbar.dart';
import 'package:flights/features/client/providers/ticket_provider.dart';
import 'package:flights/features/client/widgets/next_back_buttons.dart';
import 'package:flights/features/client/widgets/selected_return_seat.dart';
import 'package:flights/features/client/widgets/text.dart';
import 'package:flights/utils/r.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class SeatScreen extends StatefulWidget {
  const SeatScreen({super.key, required this.tabController});
  final TabController tabController;

  @override
  State<SeatScreen> createState() => _SeatScreenState();
}

class _SeatScreenState extends State<SeatScreen> {
  Set<String> selected = <String>{'one'};

  @override
  Widget build(BuildContext context) {
    return Consumer<TicketProvider>(builder: (context, provider, child) {
      final flight = provider.selectedFlights[0];
      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
        child: Column(
          children: [
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
                      // context
                      //     .read<FlightsProvider>()
                      //     .filterFlightsByDay(leavingDate: context.read<TicketProvider>().leavingDate!);
                    } else {
                      // context
                      //     .read<FlightsProvider>()
                      //     .filterReturnFlightsByDay(returnDate: context.read<TicketProvider>().returnDate!);
                    }
                    selected = p0;
                    setState(() {});
                  },
                ),
              ),
            if (selected.contains('one'))
              Expanded(
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: ClipOval(
                                child: Container(width: 180, color: const Color(0xff597672)),
                              ),
                            ),
                            const SizedBox(
                              height: 100,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 100,
                            ),
                            Expanded(
                              child: Container(
                                width: 180,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(100)),
                                    color: Color(0xff597672)),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              width: 180,
                              height: 20,
                            ),
                            Center(
                              child: SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: Image.asset(
                                    "assets/logo.png",
                                    color: Theme.of(context).indicatorColor,
                                  )),
                            ),
                            TextUtil(
                              text: "${Jiffy.parseFromDateTime(flight.lunchDate).yMMMd} ${flight.lunchTime}",
                              color: Colors.white,
                              size: 12,
                              weight: true,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextUtil(
                              text: provider.flightClass,
                              color: Theme.of(context).indicatorColor,
                              size: 12,
                              weight: true,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 180,
                                height: MediaQuery.sizeOf(context).height,
                                // color: Colors.white,
                                child: GridView.builder(
                                  itemCount: flight.seats.length,
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3, crossAxisSpacing: 0, mainAxisExtent: 40, mainAxisSpacing: 10),
                                  itemBuilder: (context, index) {
                                    final seat = flight.seats[index];
                                    return GestureDetector(
                                      onTap: !seat.available || seat.isVip == provider.isVip()
                                          ? null
                                          : () {
                                              setState(() {
                                                print(provider.travelerNumber);
                                                // selectedSeat.clear();
                                                if (provider.leavingSelectedSeat.contains(seat)) {
                                                  provider.leavingSelectedSeat.remove(seat);
                                                } else {
                                                  if (provider.leavingSelectedSeat.length < provider.travelerNumber) {
                                                    provider.leavingSelectedSeat.add(seat);
                                                  } else {
                                                    showErrorSnackBar(context, 'لا يمكنك اختيار مقاعد اضافية');
                                                  }
                                                }
                                              });
                                            },
                                      child: Container(
                                        margin: const EdgeInsets.only(right: 1 == 1 ? 20 : 5),
                                        height: 35,
                                        width: 30,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: !seat.available || seat.isVip == provider.isVip()
                                                ? Colors.grey[800]
                                                : provider.leavingSelectedSeat.contains(seat)
                                                    ? Theme.of(context).indicatorColor
                                                    : Colors.transparent
                                            // : Colors.transparent,
                                            ,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                                color: !seat.available || seat.isVip == provider.isVip()
                                                    ? Colors.grey[800]!
                                                    : provider.leavingSelectedSeat.contains(seat)
                                                        ? Theme.of(context).indicatorColor
                                                        : Theme.of(context).canvasColor
                                                // : Theme.of(context).canvasColor
                                                )),
                                        child: Text(seat.name,
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: provider.leavingSelectedSeat.contains(seat)
                                                    ? R.primaryColor
                                                    : Colors.white)),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextUtil(
                              text: 'من',
                              color: Theme.of(context).indicatorColor,
                              size: 28,
                            ),
                            TextUtil(
                              text: flight.from,
                              color: Colors.white,
                              size: 12,
                              weight: true,
                            )
                          ],
                        ),
                        Container(
                          height: 60,
                          width: 60,
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient:
                                  LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: const [
                                0.5,
                                0.5
                              ], colors: [
                                Theme.of(context).indicatorColor,
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
                                    child:
                                        Icon(Icons.flight_takeoff, size: 25, color: Theme.of(context).indicatorColor)),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextUtil(
                              text: 'إلى',
                              color: Theme.of(context).indicatorColor,
                              size: 28,
                            ),
                            TextUtil(
                              text: flight.to,
                              color: Colors.white,
                              size: 12,
                              weight: true,
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextUtil(
                              text: "رقم الرحلة",
                              color: Theme.of(context).canvasColor,
                              size: 12,
                              weight: true,
                            ),
                            TextUtil(
                              text: flight.flightNo,
                              color: Colors.white,
                              size: 13,
                              weight: true,
                            )
                          ],
                        ),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.center,
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     provider.leavingSelectedSeat.isEmpty
                        //         ? const SizedBox()
                        //         : TextUtil(
                        //             text: provider.leavingSelectedSeat[0].name,
                        //             color: Theme.of(context).indicatorColor,
                        //             size: 28,
                        //           ),
                        //     TextUtil(
                        //       text: "المقعد",
                        //       color: Colors.white,
                        //       size: 12,
                        //       weight: true,
                        //     )
                        //   ],
                        // ),
                        const SizedBox(),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            if (selected.contains('two'))
              Expanded(
                  flex: 1, child: SizedBox(width: MediaQuery.sizeOf(context).width, child: const SelectReturnSeat())),
            NextBackButtons(
              onNext: () {
                final provider = context.read<TicketProvider>();
                if (provider.selectedFlights.length > 1) {
                  if (provider.leavingSelectedSeat.length < provider.travelerNumber) {
                    showErrorSnackBar(context, 'الرجاء اختيار مقاعد لكل الأشخاص في رحلة الذهاب');
                    return;
                  }

                  if (provider.returnSelectedSeat.length < provider.travelerNumber) {
                    showErrorSnackBar(context, 'الرجاء اختيار مقاعد لكل الأشخاص في رحلة الإياب');
                    return;
                  }
                }

                if (provider.leavingSelectedSeat.length < provider.travelerNumber) {
                  showErrorSnackBar(context, 'الرجاء اختيار مقاعد لكل الأشخاص');
                  return;
                }
                // if (provider.selectedFlights.isEmpty) {
                //   showErrorSnackBar(context, 'الرجاء اختيار رحلة');
                //   return;
                // }
                widget.tabController.animateTo(3);
              },
              onBack: () {
                widget.tabController.animateTo(1);
              },
            )
          ],
        ),
      );
    });
  }
}
