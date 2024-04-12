import 'package:flights/core/enums/enums.dart';
import 'package:flights/features/flights/models/flight.dart';
import 'package:flights/features/flights/services/flights_db_service.dart';
import 'package:flutter/material.dart';

class FlightsProvider extends ChangeNotifier {
  DataState dataState = DataState.notSet;
  List<Flight> flightList = [];

  final flightService = FlightDbService();

  void getAllFlight() async {
    dataState = DataState.loading;
    notifyListeners();

    final data = await flightService.getMyFlights();

    if (data == null) {
      dataState = DataState.failure;
      notifyListeners();
      return;
    }

    if (data.isEmpty) {
      dataState = DataState.empty;
      notifyListeners();
      return;
    }
    flightList = data;
    dataState = DataState.done;
    notifyListeners();
  }

  void filterFlights(
      {required String from,
      required String to,
      required DateTime travileDate,
      DateTime? retriveDate,
      required int travelrs}) {
    //TODO: filter available flights
  }

  Future<void> addFlight({required Flight flight}) async {
    dataState = DataState.loading;
    notifyListeners();
    final result = await flightService.addFlight(flight: flight);

    if (result == 'error') {
      dataState = DataState.failure;
      notifyListeners();
    } else {
      dataState = DataState.done;
      notifyListeners();
    }
  }

  Future<void> updateFlight({required Flight flight}) async {
    dataState = DataState.loading;
    notifyListeners();
    final result = await flightService.updateFlight(flight: flight);

    if (result == 'error') {
      dataState = DataState.failure;
      notifyListeners();
    } else {
      dataState = DataState.done;
      notifyListeners();
    }
  }

  void deleteFlight({required String flightId}) async {
    dataState = DataState.loading;
    notifyListeners();
    final result = await flightService.deleteFlight(flightId: flightId);

    if (result == 'error') {
      dataState = DataState.failure;
      notifyListeners();
    } else {
      dataState = DataState.done;
      notifyListeners();
    }
  }
}
