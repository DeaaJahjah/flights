import 'package:flights/core/enums/enums.dart';
import 'package:flights/features/client/models/ticket.dart';
import 'package:flights/features/client/models/traveler.dart';
import 'package:flights/features/client/services/ticket_db_service.dart';
import 'package:flights/features/flights/models/flight.dart';
import 'package:flutter/material.dart';

class TicketProvider extends ChangeNotifier {
  Ticket? ticket;
  List<Ticket> tickets = [];
  DataState dataState = DataState.notSet;
  String flightClass = '';
  List<Flight> selectedFlights = [];
  List<Seat> leavingSelectedSeat = [];
  List<Seat> returnSelectedSeat = [];
  List<Traveler> travlersList = [];

  DateTime? leavingDate;
  DateTime? returnDate;
  late int travelerNumber;

  void deleteTicket(Ticket? ticket) {
    tickets.remove(ticket);
    notifyListeners();
  }

  void selecteFlight(Flight flight) {
    if (selectedFlights.contains(flight)) {
      selectedFlights.remove(flight);
    } else {
      selectedFlights.remove(flight);
      selectedFlights.add(flight);
    }

    selectedFlights.sort((a, b) => a.index.compareTo(b.index));
    if (selectedFlights.isNotEmpty) {
      print(selectedFlights[0].index);
    }
    notifyListeners();
  }

  void deSelecteFlight(Flight flight) {
    ticket!.flights.remove(flight);
    notifyListeners();
    // for( var f in ticket!.flights){
    //   if(f.id == id){

    //   }
  }

  bool isVip() {
    return flightClass == 'Business' ? true : false;
  }

  Future<void> addTicket({required Ticket ticket}) async {
    dataState = DataState.loading;
    notifyListeners();
    final result = await TicketsDbService().addTicket(ticket: ticket);

    if (result == 'error') {
      dataState = DataState.failure;
      notifyListeners();
    } else {
      dataState = DataState.done;
      notifyListeners();
    }
  }

  Future<void> getMyTicket() async {
    dataState = DataState.loading;
    notifyListeners();

    final data = await TicketsDbService().getMyTickets();

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

    print('GET MY Tickets');
    print('tickets $tickets');
    tickets = data;
    dataState = DataState.done;
    notifyListeners();
  }

  void updateInfo(
    DateTime? leavingDate,
    DateTime? returnDate,
    int travelerNumber,
  ) {
    this.leavingDate = leavingDate;
    this.returnDate = returnDate;
    this.travelerNumber = travelerNumber;
  }
}
