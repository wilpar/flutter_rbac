import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Profile with ChangeNotifier {
  final String uid;
  final String email;
  final String market;
  final String roleView;
  final String firstName;
  final String lastName;
  final String photoUrl;

  Profile({
    this.uid,
    this.email,
    this.market,
    this.roleView,
    this.firstName,
    this.lastName,
    this.photoUrl,
  });

  factory Profile.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();

    return Profile(
      uid: doc.id,
      email: data['email'] ?? '',
      market: data['market'] ?? '',
      roleView: data['roleView'] ?? 'member',
      firstName: data['firstName'] ?? 'Valued',
      lastName: data['lastName'] ?? 'Guest',
      photoUrl: data['photoUrl'] ?? '',
    );
  }
}
