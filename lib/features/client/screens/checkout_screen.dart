import 'package:flights/core/enums/enums.dart';
import 'package:flights/core/extensions/firebase.dart';
import 'package:flights/core/widgets/custom_progress.dart';
import 'package:flights/core/widgets/custom_snackbar.dart';
import 'package:flights/core/widgets/filled_button.dart';
import 'package:flights/features/client/models/ticket.dart';
import 'package:flights/features/client/providers/ticket_provider.dart';
import 'package:flights/features/client/widgets/next_back_buttons.dart';
import 'package:flights/features/client/widgets/ticket_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, required this.tabController});
  final TabController tabController;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String process = "Pay";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<TicketProvider>(builder: (context, provider, child) {
          print(provider.flightClass);
          return Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: provider.selectedFlights.length,
              itemBuilder: (context, index) => TicketCard(
                  flight: provider.selectedFlights[index],
                  seatsNumber: provider.leavingSelectedSeat.length,
                  flightClass: provider.flightClass),
            ),
          );
        }),
        Row(
          children: [
            NextBackButtons(
              // onNext: () {
              //   // final provider = context.read<TicketProvider>();
              //   // if (provider.leavingSelectedSeat.length < provider.travelerNumber) {
              //   //   showErrorSnackBar(context, 'الرجاء اختيار مقاعد لكل الأشخاص');
              //   //   return;
              //   // }
              //   // if (provider.selectedFlights.isEmpty) {
              //   //   showErrorSnackBar(context, 'الرجاء اختيار رحلة');
              //   //   return;
              //   // }
              //   widget.tabController.animateTo(3);
              // },
              onBack: () {
                widget.tabController.animateTo(1);
              },
            ),
            Expanded(
                child: context.watch<TicketProvider>().dataState == DataState.loading
                    ? const CustomProgress()
                    : CustomFilledButton(
                        onPressed: () async {
                          final provider = context.read<TicketProvider>();

                          final myFlights = provider.selectedFlights;
                          if (myFlights.length > 1) {
                            myFlights[0] = myFlights[0].copyWith(seats: provider.leavingSelectedSeat);
                            myFlights[1] = myFlights[1].copyWith(seats: provider.returnSelectedSeat);
                          } else {
                            myFlights[0] = myFlights[0].copyWith(seats: provider.leavingSelectedSeat);
                          }

                          await provider.addTicket(
                              ticket: Ticket(
                                  id: const Uuid().v1(),
                                  clientId: context.userUid,
                                  flights: myFlights,
                                  isOneWay: myFlights.length == 1,
                                  travelers: provider.travlersList,
                                  reservationDate: DateTime.now(),
                                  flightClass: provider.flightClass));

                          if (provider.dataState == DataState.failure) {
                            showErrorSnackBar(context, 'حدث خطأ عند حجز التذكرة');
                            return;
                          }
                          provider.getMyTicket();
                          showSuccessSnackBar(context, 'تم حجز التذكرة بنجاح');
                          Navigator.pop(context);
                        },
                        text: 'تثبيت الحجز')),
            const SizedBox(
              width: 10,
            )
          ],
        )
      ],
    );
  }
}

// class TicketCard extends StatelessWidget {
//   const TicketCard({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ;
//   }
// }
