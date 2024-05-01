import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flights/features/client/models/ticket.dart';
import 'package:flights/features/flights/models/flight.dart';

class FlightDbService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  Future<List<Flight>?> getAllFlights() async {
    List<Flight> flights = [];
    try {
      final data = await _db.collection('flights').get();
      for (var doc in data.docs) {
        flights.add(Flight.fromFirestore(doc));
      }
    } catch (e) {
      return null;
    }
    return flights;
  }

  Future<List<Flight>?> getMyFlights() async {
    List<Flight> flights = [];
    try {
      final data = await _db.collection('flights').where('userId', isEqualTo: firebaseUser!.uid).get();
      for (var doc in data.docs) {
        flights.add(Flight.fromFirestore(doc));
      }
    } catch (e) {
      return null;
    }
    return flights;
  }

  Future<String> addFlight({required Flight flight}) async {
    try {
      await _db.collection('flights').add(flight.toJson());
    } catch (e) {
      return 'error';
    }
    return 'success';
  }

  Future<String> updateFlight({required Flight flight}) async {
    try {
      await _db.collection('flights').doc(flight.id).update(flight.toJson());

      final allteciket = await _db.collection('tickets').get();

      //TODO: 1 get all tickets
      List<Ticket> tickets = [];
      for (var doc in allteciket.docs) {
        tickets.add(Ticket.fromFirestore(doc));
      }
      //TODO:: 2 update each

      for (var ticket in tickets) {
        for (int i = 0; i < ticket.flights.length; i++) {
          final remoteFlight = ticket.flights[i];
          if (remoteFlight.id == flight.id && remoteFlight.lunchDate.isBefore(DateTime.now())) {
            final flight0 = remoteFlight.copyWith(
              lunchDate: flight.lunchDate,
              lunchTime: flight.lunchTime,
              arriveDate: flight.arriveDate,
              arriveTime: flight.arriveTime,
            );
            ticket.flights[i] = flight0;
          }

          await _db.collection('tickets').doc(ticket.id).update(ticket.toJson());
        }

        //end of update
      }
    } catch (e) {
      return 'error';
    }
    return 'success';
  }

  Future<String> deleteFlight({required String flightId}) async {
    try {
      await _db.collection('flights').doc(flightId).delete();
    } catch (e) {
      return 'error';
    }
    return 'success';
  }
}
