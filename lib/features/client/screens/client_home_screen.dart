import 'package:flights/core/enums/enums.dart';
import 'package:flights/core/extensions/firebase.dart';
import 'package:flights/core/utils/shred_prefs.dart';
import 'package:flights/core/widgets/custom_progress.dart';
import 'package:flights/core/widgets/custom_snackbar.dart';
import 'package:flights/features/auth/screens/client_profile_screen.dart';
import 'package:flights/features/auth/services/authentecation_service.dart';
import 'package:flights/features/client/models/ticket.dart';
import 'package:flights/features/client/providers/ticket_provider.dart';
import 'package:flights/features/client/screens/add_flight.dart';
import 'package:flights/features/client/services/ticket_db_service.dart';
import 'package:flights/features/client/widgets/animated_route.dart';
import 'package:flights/features/client/widgets/text.dart';
import 'package:flights/features/client/widgets/ticket_card.dart';
import 'package:flights/features/flights/providers/fllights_providers.dart';
import 'package:flights/utils/r.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum MainPageEnum { myFlights, addFlight }

class ClientHomeScreen extends StatefulWidget {
  static const String routeName = '/home-page';

  const ClientHomeScreen({
    super.key,
  });

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () {
        context.read<TicketProvider>().getMyTicket();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextUtil(
          text: "رحلاتي السابقة",
          color: R.primaryColor,
          weight: true,
          size: 20,
        ),
        elevation: 0,
        leading: InkWell(
          onTap: () {
            context.read<TicketProvider>().tickets = [];
            context.read<FlightsProvider>().flightList = [];
            FlutterFireAuthServices().signOut(context);
          },
          child: Icon(
            Icons.logout_rounded,
            color: Theme.of(context).primaryColor,
          ),
        ),
        actions: [
          InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(ClientProfileScreen.routeName, arguments: context.userUid);
              },
              child: SharedPrefs.prefs.getString('image') == ''
                  ? Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                            image: AssetImage("assets/profile.png"),
                          )),
                    )
                  : Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(SharedPrefs.prefs.getString('image')!),
                          )),
                    )),
          const SizedBox(
            width: 20,
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Consumer<TicketProvider>(
        builder: (context, provider, child) {
          print(provider.tickets.length);
          return Stack(
            children: [
              if (provider.dataState == DataState.loading)
                const Scaffold(
                  body: Center(
                    child: CustomProgress(),
                  ),
                ),
              if (provider.dataState == DataState.failure)
                const Scaffold(
                  body: Center(
                    child: Text('حدث خطأ ما الرجاء المحاولة لاحقاً'),
                  ),
                )
              else
                ListView.builder(
                  itemCount: provider.tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = provider.tickets[index];

                    return MyTicketCard(
                      ticket: ticket,
                      isMyTicket: true,
                    );
                  },
                )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MyCustomAnimatedRoute(
            enterWidget: const AddFlightScreen(),
          ));
          // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddFlightScreen()));
        },
        backgroundColor: Theme.of(context).indicatorColor,
        child: Icon(
          Icons.add,
          size: 28,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class MyTicketCard extends StatefulWidget {
  const MyTicketCard({
    super.key,
    required this.ticket,
    this.isMyTicket = false,
  });
  final Ticket ticket;
  final bool isMyTicket;

  @override
  State<MyTicketCard> createState() => _MyTicketCardState();
}

class _MyTicketCardState extends State<MyTicketCard> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      // padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: R.secondaryColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TicketCard(
              flight: widget.ticket.flights[0],
              seatsNumber: widget.ticket.flights[0].seats.length,
              flightClass: widget.ticket.flightClass,
              ticket: widget.ticket),
          if (widget.ticket.flights.length > 1)
            TicketCard(
                flight: widget.ticket.flights[1],
                seatsNumber: widget.ticket.flights[1].seats.length,
                flightClass: widget.ticket.flightClass,
                ticket: widget.ticket),
          if (widget.isMyTicket)
            Align(
                alignment: Alignment.center,
                child: !isLoading
                    ? ElevatedButton(
                        style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red)),
                        onPressed: () async {
                          // await showConfirmDialog(context, widget.ticket!);
                          setState(() {
                            isLoading = true;
                          });
                          final res = await TicketsDbService().canselTicket(ticket: widget.ticket, context: context);
                          setState(() {
                            isLoading = false;
                          });
                          print('End ticket');
                          if (res == 'success') {
                            showSuccessSnackBar(context, 'تم الغاء الحجز بنجاح');

                            context.read<TicketProvider>().deleteTicket(widget.ticket);
                            context.read<TicketProvider>().getMyTicket();
                          } else {
                            showErrorSnackBar(context, 'حدث خطأ الرجاء المحاولة لاحقا');
                          }
                        },
                        child: const Text(
                          'الغاء الرحلة',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ))
                    : const CustomProgress()),
          Padding(
            padding: const EdgeInsets.only(right: 10, bottom: 5),
            child: Text(
                'تاريخ حجز الرحلة ${widget.ticket.reservationDate.year}-${widget.ticket.reservationDate.month}-${widget.ticket.reservationDate.day}'),
          ),
        ],
      ),
    );
  }
}

      // Column(
      //   children: [
      //     Expanded(
      //         child: Container(
      //       padding: const EdgeInsets.symmetric(horizontal: 20),
      //       decoration: BoxDecoration(
      //           color: Theme.of(context).primaryColor,
      //           borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      //       alignment: Alignment.topCenter,
      //       child: Padding(
      //         padding: const EdgeInsets.only(top: 30),
      //         child: ListView.builder(
      //             itemCount: flightList.length,
      //             shrinkWrap: true,
      //             itemBuilder: (context, index) {
      //               return ShowUpAnimation(
      //                   delay: 150 * index,
      //                   child: GestureDetector(
      //                       onTap: () {
      //                         Navigator.of(context).push(MaterialPageRoute(
      //                             builder: (context) => DetailScreen(
      //                                   data: flightList[index],
      //                                   index: index,
      //                                 )));
      //                       },
      //                       child: FlightCard(
      //                         data: flightList[index],
      //                         index: index,
      //                       )));
      //             }),
      //       ),
      //     ))
      //   ],
      // ),