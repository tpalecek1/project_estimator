/*
  Description: Copy of the recursiveDelete function that was uploaded to the
    app's Firebase Cloud Function service. Note: this document was only added
    to the app's files for documentation purposes (it is not needed client side).
  Collaborator(s): Genevieve B-Michaud
*/

const functions = require('firebase-functions');
const firebaseTools = require('firebase-tools');

exports.recursiveDelete = functions
	.runWith({										// from: https://firebase.google.com/docs/firestore/solutions/delete-collections
		timeoutSeconds: 540,
		memory: '2GB'
	})
	.https.onCall((data, context) => {
		if (!context.auth) 
		{
			throw new functions.https.HttpsError(	// HttpsError(code: FunctionsErrorCode, message: string, details?: unknown)
				'failed-precondition',
				'Function must be called by an authenticated user.'
			);
		}
		if (typeof data.path !== 'string' || 
			data.path.split('/').length < 2 || 
			data.path.split('/')[0] !== 'users')
		{
			throw new functions.https.HttpsError(
				'invalid-argument',
				'Function must be called with a string "path" argument starting with "users/<uid>/..."'
			);
		}
		if (context.auth.uid !== data.path.split('/')[1])
		{
			throw new functions.https.HttpsError(
				'permission-denied',
				'User can only delete his own documents.'
			);
		}
		
		return firebaseTools.firestore
			.delete(data.path, {
				project: process.env.GCLOUD_PROJECT,	// automatically populated
				recursive: true,						// delete document(s) and sub-collection(s)
				yes: true,								// no confirmation prompt
				token: functions.config().fb.token 		// get token with 'firebase login:ci' command
			})											//  then set functions config with command:
			.catch((error) => {							//  'firebase functions:config:set fb.token="<token>"'
				throw new functions.https.HttpsError(
					'unknown',
					error.message,
					error
				);
			});
	});