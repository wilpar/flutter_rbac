const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

//
// User Setup
//

exports.profileCreate = functions.auth.user().onCreate(async (user) => {
  admin.auth().setCustomUserClaims(user.uid, {role: 'member'});
  return admin.firestore().collection('profiles').doc(user.uid).set({
    email: user.email,
    roleView: 'member',
    // firstName: 'New',
    // lastName: 'Member', 
  }, { merge: true });
});

exports.profileDelete = functions.auth.user().onDelete((user) => {
  const doc =  admin.firestore().collection('profiles').doc(user.uid);
  return doc.delete();
});

// 
// Role Modification. 
// 

exports.becomeAdmin = functions.https.onCall((data, context) => {
  return admin.auth().getUserByEmail(data.email).then(user => {
    admin.auth().setCustomUserClaims(user.uid, {role: 'admin'});
    return admin.firestore().collection('profiles').doc(user.uid).update({roleView: 'admin'});
  }).then(() => {
    return {
      message: `Success. ${data.email} is now an Admin.`
    }
  }).catch(err => {
    return err;
  });
});

exports.becomeMember = functions.https.onCall((data, context) => {
  return admin.auth().getUserByEmail(data.email).then(user => {
    admin.auth().setCustomUserClaims(user.uid, {role: 'member'});
    return admin.firestore().collection('profiles')
                .doc(user.uid).update({roleView: 'member'});
  }).then(() => {
    return {
      message: `Success. ${data.email} is now just a Member.`
    }
  }).catch(err => {
    return err;
  });
});
