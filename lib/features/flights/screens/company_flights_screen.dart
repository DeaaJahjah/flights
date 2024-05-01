import 'package:flights/core/enums/enums.dart';
import 'package:flights/core/extensions/firebase.dart';
import 'package:flights/core/utils/shred_prefs.dart';
import 'package:flights/core/widgets/custom_progress.dart';
import 'package:flights/features/auth/screens/company_profile_screen.dart';
import 'package:flights/features/auth/services/authentecation_service.dart';
import 'package:flights/features/flights/providers/fllights_providers.dart';
import 'package:flights/features/flights/screens/create_flightt_screen.dart';
import 'package:flights/features/flights/screens/flight_card.dart';
import 'package:flights/utils/r.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompanyFlightScreen extends StatefulWidget {
  static const routeName = '/company-flights';
  const CompanyFlightScreen({super.key});

  @override
  State<CompanyFlightScreen> createState() => _CompanyFlightScreenState();
}

class _CompanyFlightScreenState extends State<CompanyFlightScreen> {
  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () {
        context.read<FlightsProvider>().getCompanyFlights();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الرحلات', style: TextStyle(fontFamily: fontFamily)),
        leading: IconButton(
            onPressed: () {
              FlutterFireAuthServices().signOut(context);
            },
            icon: const Icon(Icons.logout_rounded)),
        actions: [
          InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(CompanyProfileScreen.routeName, arguments: context.userUid);
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
      ),
      body: Consumer<FlightsProvider>(
        builder: (context, provider, child) {
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
                  itemCount: provider.flightList.length,
                  itemBuilder: (context, index) {
                    final flight = provider.flightList[index];

                    return FlightCard(
                      flightData: flight,
                    );
                  },
                )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: R.secondaryColor,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(
              CreateFlightScreen.routeName,
            );
          }),
    );
  }
}
