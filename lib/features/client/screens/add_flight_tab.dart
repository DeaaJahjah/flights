import 'package:flights/features/client/screens/route_screen.dart';
import 'package:flights/features/client/screens/seat_screen.dart';
import 'package:flights/utils/r.dart';
import 'package:flutter/material.dart';

import 'checkout_screen.dart';
import 'flight_screen.dart';

class BookingTabBar extends StatefulWidget {
  const BookingTabBar({super.key});

  @override
  State<BookingTabBar> createState() => _BookingTabBarState();
}

class _BookingTabBarState extends State<BookingTabBar> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          labelColor: Theme.of(context).indicatorColor,
          unselectedLabelColor: Theme.of(context).canvasColor,
          dividerColor: Theme.of(context).canvasColor,
          indicatorColor: Theme.of(context).indicatorColor,
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Text("الوجهة", style: TextStyle(fontFamily: fontFamily)),
            ),
            Tab(
              icon: Text("الرحلة", style: TextStyle(fontFamily: fontFamily)),
            ),
            Tab(
              icon: Text("المقعد", style: TextStyle(fontFamily: fontFamily)),
            ),
            Tab(
              
              icon: Text("الدفع", style: TextStyle(fontFamily: fontFamily)),
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: <Widget>[
              RouteScreen(tabController: _tabController),
              const FlightScreen(),
              const SeatScreen(),
              const CheckoutScreen(),
            ],
          ),
        ),
      ],
    );
  }
}
