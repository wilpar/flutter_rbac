import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/profile.dart';

class DatabaseService {
  final String uid;
  DatabaseService({
    this.uid,
  });

  final CollectionReference _profileCollection =
      FirebaseFirestore.instance.collection('profiles');

  Stream<Profile> get profile {
    return _profileCollection.doc(uid).snapshots().map(_profileFromSnapshot);
  }

  Profile _profileFromSnapshot(DocumentSnapshot snapshot) {
    return Profile(
      uid: uid,
      market: snapshot.data()['market'],
      email: snapshot.data()['email'],
      roleView: snapshot.data()['roleView'],
      firstName: snapshot.data()['firstName'],
      lastName: snapshot.data()['lastName'],
    );
  }

  Future<void> updateProfileName(String firstName, String lastName) async {
    return await _profileCollection.doc(uid).set(
      {
        'firstName': firstName,
        'lastName': lastName,
      },
      SetOptions(merge: true),
    );
  }
}
