import 'package:flights/core/widgets/custom_snackbar.dart';
import 'package:flights/features/client/models/ticket.dart';
import 'package:flights/features/client/providers/ticket_provider.dart';
import 'package:flights/features/client/services/ticket_db_service.dart';
import 'package:flights/features/client/widgets/show_up_animation.dart';
import 'package:flights/features/client/widgets/text.dart';
import 'package:flights/features/flights/models/flight.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TicketCard extends StatefulWidget {
  const TicketCard(
      {super.key, this.ticket, required this.flight, required this.seatsNumber, required this.flightClass});
  final Flight flight;
  final int seatsNumber;
  final String flightClass;
  final Ticket? ticket;

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30), bottom: Radius.circular(20))),
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShowUpAnimation(
              delay: 200,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Image.asset(
                                    "assets/logo.png",
                                    color: Theme.of(context).primaryColor,
                                  )),
                              Icon(
                                Icons.flight_takeoff,
                                size: 35,
                                color: Theme.of(context).indicatorColor,
                              ),
                              TextUtil(
                                text: "السعر النهائي",
                                size: 12,
                              ),
                              TextUtil(
                                text: context.read<TicketProvider>().flightClass == 'Business'
                                    ? '${widget.flight.businessClassCost * widget.seatsNumber}\$'
                                    : '${widget.flight.normalClassCost * widget.seatsNumber}\$',
                                size: 22,
                                weight: true,
                                color: Theme.of(context).primaryColor,
                              ),
                            ],
                          ),
                          Transform.rotate(
                            angle: 0.3,
                            child: SizedBox(
                              height: 150,
                              width: 200,
                              child: Image.asset(
                                "assets/world.png",
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            TextUtil(
                              text: "من",
                              size: 12,
                            ),
                            TextUtil(
                              text: '${widget.flight.from} ',
                              size: 15,
                              weight: true,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            TextUtil(
                              text: " ",
                              size: 12,
                            ),
                            TextUtil(
                              text: '',
                              size: 15,
                              weight: true,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            TextUtil(
                              text: "إلى",
                              size: 12,
                            ),
                            TextUtil(
                              text: widget.flight.to,
                              size: 15,
                              weight: true,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            TextUtil(
                              text: "وقت الانطلاق",
                              size: 12,
                            ),
                            TextUtil(
                              text: '${widget.flight.lunchTime} ',
                              size: 15,
                              weight: true,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            TextUtil(
                              text: "موعد الانطلاق",
                              size: 12,
                            ),
                            TextUtil(
                              text:
                                  '${widget.flight.lunchDate.year}-${widget.flight.lunchDate.month}-${widget.flight.lunchDate.day} ',
                              size: 15,
                              weight: true,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            TextUtil(
                              text: "رقم الرحلة",
                              size: 12,
                            ),
                            TextUtil(
                              text: widget.flight.flightNo,
                              size: 15,
                              weight: true,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            TextUtil(
                              text: "وقت الوصول",
                              size: 12,
                            ),
                            TextUtil(
                              text: widget.flight.arriveTime,
                              size: 15,
                              weight: true,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            TextUtil(
                              text: "عدد المقاعد",
                              size: 12,
                            ),
                            TextUtil(
                              text: widget.seatsNumber.toString(),
                              size: 15,
                              weight: true,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            TextUtil(
                              text: "الدرجة",
                              size: 12,
                            ),
                            TextUtil(
                              text: widget.flightClass != 'Economy' ? 'رجال أعمال' : 'سياحية',
                              size: 15,
                              weight: true,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Stack(
              children: [
                SizedBox(
                  height: 25,
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: double.infinity,
                          height: 1,
                          child: Row(
                            children: List.generate(
                                700 ~/ 10,
                                (index) => Expanded(
                                      child: Container(
                                        color: index % 2 == 0 ? Colors.transparent : Theme.of(context).canvasColor,
                                        height: 2,
                                      ),
                                    )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    left: -10,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Theme.of(context).primaryColor,
                    )),
                Positioned(
                    right: -10,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Theme.of(context).primaryColor,
                    ))
              ],
            ),
            if (widget.ticket != null)
              Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Colors.red)),
                      onPressed: () async {
                        await showConfirmDialog(context, widget.ticket!);
                      },
                      child: const Text(
                        'الغاء الرحلة',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )))
          ],
        ),
      ),
    );
  }

  String process = "Pay";

  void update() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        process = "Book";
      });
    });
  }
}

Future<void> showConfirmDialog(BuildContext context, Ticket ticket) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('تأكيد إلغاء الحجز'),
        content: const Text('هل أنت متأكد من إلغاء الحجز؟\nسوف يتم إعادة ثمن التذكرة إلى حسابك.'),
        actions: <Widget>[
          TextButton(
            child: const Text('إلغاء'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: const Text('تأكيد'),
            onPressed: () async {
              final result = await TicketsDbService().canselTicket(ticket: ticket);

              if (result == 'error') {
                showErrorSnackBar(context, 'حدث خطأ الرجاء المحاولة لاحقا');
                return;
              }
              showSuccessSnackBar(context, 'تم الغاء الحجز بنجاح');

              await context.read<TicketProvider>().getMyTicket();
              // Handle the confirmation action
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
