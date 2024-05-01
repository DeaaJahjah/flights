import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flights/features/client/models/ticket.dart';
import 'package:flights/features/flights/models/flight.dart';

class TicketsDbService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  Future<List<Ticket>?> getMyTickets() async {
    List<Ticket> tickets = [];
    try {
      final data = await _db.collection('tickets').where('clientId', isEqualTo: firebaseUser!.uid).get();
      for (var doc in data.docs) {
        tickets.add(Ticket.fromFirestore(doc));
      }
    } catch (e) {
      return null;
    }
    return tickets;
  }

  Future<String> addTicket({required Ticket ticket}) async {
    try {
      await _db.collection('tickets').add(ticket.toJson());

      //TODO: get flights to update seates

      for (var flight in ticket.flights) {
        final json = await _db.collection('flights').doc(flight.id).get();
        final ff = Flight.fromFirestore(json);

        // for (int i = 0; i < ff.seats.length; i++) {

        for (var seat in flight.seats) {
          final index = ff.seats.indexWhere((element) => element.id == seat.id);

          ff.seats[index] = ff.seats[index].copyWith(available: false);
        }
        await _db.collection('flights').doc(ff.id).update(ff.toJson());
        // if (ff.seats[i].id == flight.id) {
        //   ff.seats[i] = ff.seats[i].copyWith(available: false);
        // }
        // }
      }
    } catch (e) {
      return 'error';
    }
    return 'success';
  }
}
