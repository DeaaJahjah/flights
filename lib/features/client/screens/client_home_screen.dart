import 'package:flights/features/client/screens/add_flight.dart';
import 'package:flights/features/client/screens/detail_screen.dart';
import 'package:flights/features/client/widgets/animated_route.dart';
import 'package:flights/features/client/widgets/flight_card.dart';
import 'package:flights/features/client/widgets/flight_data.dart';
import 'package:flights/features/client/widgets/show_up_animation.dart';
import 'package:flights/features/client/widgets/text.dart';
import 'package:flights/utils/r.dart';
import 'package:flutter/material.dart';

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
        leading: Icon(
          Icons.account_tree,
          color: Theme.of(context).primaryColor,
        ),
        // actions: [
        //   Container(
        //     height: 50,
        //     width: 50,
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(10),
        //         image: const DecorationImage(
        //           image: AssetImage("assets/profile.png"),
        //         )),
        //   ),
        //   const SizedBox(
        //     width: 20,
        //   ),
        // ],
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          //   height: 60,
          //   alignment: Alignment.centerRight,
          //   decoration: const BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
          //   ),
          //   child: TextUtil(
          //     text: "رحلاتي السابقة",
          //     color: R.primaryColor,
          //     weight: true,
          //     size: 20,
          //   ),
          // ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: ListView.builder(
                  itemCount: flightList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ShowUpAnimation(
                        delay: 150 * index,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                        data: flightList[index],
                                        index: index,
                                      )));
                            },
                            child: FlightCard(
                              data: flightList[index],
                              index: index,
                            )));
                  }),
            ),
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).indicatorColor,
        onPressed: () {
          Navigator.of(context).push(MyCustomAnimatedRoute(
            enterWidget: const AddFlightScreen(),
          ));
          // Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddFlightScreen()));
        },
        child: Icon(
          Icons.add,
          size: 28,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
