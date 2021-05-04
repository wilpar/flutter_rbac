import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

import '../../models/profile.dart';
import '../../services/database.dart';
import '../../widgets/loading.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final HttpsCallable adminCall =
      FirebaseFunctions.instance.httpsCallable('becomeAdmin');
  final HttpsCallable memberCall =
      FirebaseFunctions.instance.httpsCallable('becomeMember');
  bool _processing = false;
  String _response = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
      ),
      body: StreamBuilder<Profile>(
        stream: DatabaseService(uid: 'MiR4U5WXIIRvGHPyWdSA4fJxgld2').profile,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Profile profile = snapshot.data;
            return _processing
                ? Loading()
                : ListView(
                    padding: EdgeInsets.all(20),
                    children: [
                      Center(
                        child:
                            Text(profile.email + " is a " + profile.roleView),
                      ),
                      ElevatedButton(
                        child: Text('Make Admin'),
                        onPressed: () async {
                          setState(() {
                            _processing = true;
                          });
                          try {
                            final HttpsCallableResult result =
                                await adminCall.call(
                              <String, dynamic>{
                                'email': 'c@c.com',
                              },
                            );
                            setState(() {
                              _processing = false;
                              _response = result.data['message'].toString();
                            });
                          } on FirebaseFunctionsException catch (e) {
                            print('caught firebase functions exception');
                            print(e.code);
                            print(e.message);
                            print(e.details);
                          } catch (e) {
                            print('caught generic exception');
                            print(e);
                          }
                        },
                      ),
                      ElevatedButton(
                        child: Text('Make Member'),
                        onPressed: () async {
                          setState(() {
                            _processing = true;
                          });
                          try {
                            final HttpsCallableResult result =
                                await memberCall.call(
                              <String, dynamic>{
                                'email': 'c@c.com',
                              },
                            );
                            setState(() {
                              _processing = false;
                              _response = result.data['message'].toString();
                            });
                          } on FirebaseFunctionsException catch (e) {
                            print('caught firebase functions exception');
                            print(e.code);
                            print(e.message);
                            print(e.details);
                          } catch (e) {
                            print('caught generic exception');
                            print(e);
                          }
                        },
                      ),
                      Text(_response),
                    ],
                  );
          }
          return Container();
        },
      ),
    );
  }
}
