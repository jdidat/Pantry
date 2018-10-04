const functions = require('firebase-functions');
const admin = require('firebase-admin');
exports.userRecipeCountUpdate = functions.firestore.document('customRecipes/{userId}').onWrite(
    (change, context) => {
        const {userId} = context.params;
        const app = admin.app();
        app.firestore()
    }
);



// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
