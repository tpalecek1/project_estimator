/*
  Description: Copy of the cloud functions that were uploaded to the
    app's Firebase Cloud Function service. Note: this document was only added
    to the app's files for documentation purposes (it is not needed client side).
  Collaborator(s): Genevieve B-Michaud
*/

const firebase = require('firebase-admin');
const functions = require('firebase-functions');
const firebaseTools = require('firebase-tools');

firebase.initializeApp();

// recursively delete document(s) in sub-collection(s)
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

// on room delete -> delete room's photos from cloud storage
exports.onRoomDelete = functions
	.firestore.document('users/{userId}/projects/{projectId}/rooms/{roomId}')
	.onDelete((doc, context) => {
		const userId = context.params.userId;
		const roomId = context.params.roomId;
		const path = 'users/' + userId + '/rooms/' + roomId + '/';
		const storage = firebase.storage().bucket();

		return storage.deleteFiles({ prefix: path });
	});

// on room update -> delete any deleted room photo from cloud storage
exports.onRoomUpdate = functions
	.firestore.document('users/{userId}/projects/{projectId}/rooms/{roomId}')
	.onUpdate((doc, context) => {
		const userId = context.params.userId;
		const roomId = context.params.roomId;
		const path = 'users/' + userId + '/rooms/' + roomId + '/';
		const storage = firebase.storage().bucket();

		const photosBefore = doc.before.data().photos;
		const photosAfter = doc.after.data().photos;

		const photosDeleted = photosBefore.filter((photoBefore) => {
			return !photosAfter.includes(photoBefore);
		});

		const deletePhotos = photosDeleted.map((url) => {
			return storage.file(path + url.match(/(?!%2F)\d+(?=\?)/)).delete();
		});

		return Promise.all(deletePhotos);
	});

// on user delete -> delete user avatar from cloud storage
exports.onUserDelete = functions
	.firestore.document('users/{userId}')
	.onDelete((doc, context) => {
		const userId = context.params.userId;
		const path = 'users/' + userId + '/avatar/';
		const storage = firebase.storage().bucket();

		return storage.deleteFiles({ prefix: path });
	});