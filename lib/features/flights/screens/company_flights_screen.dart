import 'package:flights/core/enums/enums.dart';
import 'package:flights/core/widgets/custom_progress.dart';
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
        context.read<FlightsProvider>().getAllFlight();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الرحلات')),
      body: Consumer<FlightsProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              if (provider.dataState == DataState.loading)
                const Center(
                  child: CustomProgress(),
                ),
              if (provider.dataState == DataState.failure)
                const Center(
                  child: Text('حدث خطأ ما الرجاء المحاولة لاحقاً'),
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
