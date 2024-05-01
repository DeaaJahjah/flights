import 'package:flights/core/enums/enums.dart';
import 'package:flights/features/flights/models/flight.dart';
import 'package:flights/features/flights/services/flights_db_service.dart';
import 'package:flutter/material.dart';

class FlightsProvider extends ChangeNotifier {
  DataState dataState = DataState.notSet;
  DataState postponingDataState = DataState.notSet;

  List<Flight> flightList = [];
  List<Flight> flightFilterdList = [];
  List<Flight> filterdListByDate = [];

  List<Flight> returnedFlightList = [];
  List<Flight> returnedFilterdListByDate = [];

  final flightService = FlightDbService();

  Future<void> getCompanyFlights() async {
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

  Future<void> getAllFlights() async {
    dataState = DataState.loading;
    notifyListeners();

    final data = await flightService.getAllFlights();

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

  Future<void> filterFlights({
    required String flightClass,
    required String from,
    required String to,
    required DateTime? leavingDate,
    required DateTime? returnDate,
    required int travelerNumber,
  }) async {
    flightFilterdList = [];
    for (var flight in flightList) {
      if (flight.from.contains(from) &&
          flight.to.contains(to) &&
          flight.lunchDate.month == leavingDate!.month &&
          flight.hasAvailableSeats(flightClass: flightClass, neadedSeats: travelerNumber)) {
//
        flightFilterdList.add(flight);
      }
    }

    //TODO: filter the return flight
    returnedFlightList = [];

    if (returnDate != null) {
      for (var flight in flightList) {
        if (flight.from.contains(to) &&
            flight.to.contains(from) &&
            flight.lunchDate.month == returnDate.month &&
            flight.hasAvailableSeats(flightClass: flightClass, neadedSeats: travelerNumber)) {
//
          returnedFlightList.add(flight);
        }
      }
    }
    print('returnedFilterdListByDate ${flightFilterdList.length}');

    print('returnedFilterdListByDate ${returnedFlightList.length}');

    notifyListeners();
  }

  Future<void> filterFlightsByDay({
    required DateTime leavingDate,
  }) async {
    filterdListByDate = [];

    for (var flight in flightFilterdList) {
      if (flight.lunchDate.day == leavingDate.day) {
        filterdListByDate.add(flight.copyWith(index: 0));
      }
    }
    notifyListeners();
  }

  Future<void> filterReturnFlightsByDay({
    required DateTime returnDate,
  }) async {
    returnedFilterdListByDate = [];

    for (var flight in returnedFlightList) {
      if (flight.lunchDate.day == returnDate.day) {
        returnedFilterdListByDate.add(flight.copyWith(index: 1));
      }
    }
    notifyListeners();
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

  Future<void> postponingFlight({required Flight flight}) async {
    postponingDataState = DataState.loading;
    notifyListeners();
    final result = await flightService.updateFlight(flight: flight);

    if (result == 'error') {
      postponingDataState = DataState.failure;
      notifyListeners();
    } else {
      postponingDataState = DataState.done;
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
