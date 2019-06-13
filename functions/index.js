const functions = require('firebase-functions');
const cors = require('cors')({
    origin: true
})
const BusBoy = require('busboy');
const os = require('os');
const path = require('path');
const fs = require('fs');
const fbAdmin = require('firebase-admin');
const uuid = require('uuid/v4');
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
const gcconfig = {
    projectId: 'flutter-app-32074',
    keyFilename: 'flutter-app-product.json'
};
// const gcs = require('@google-cloud/storage')(gcconfig);
const {
    Storage
} = require('@google-cloud/storage');
const gcs = new Storage({

    projectId: 'flutter-app-32074',
    keyFilename: 'flutter-app-product.json'

});
fbAdmin.initializeApp({
    credential: fbAdmin.credential.cert(require('./flutter-app-product.json'))
});
exports.storeImage = functions.https.onRequest((req, res) => {
    return cors(req, res, () => {
        if (req.method !== 'POST') {
            return res.status(500).json({
                message: 'method not allowed.'
            });
        }
        if (req.headers.authorization || req.headers.authorization.startsWith('Bearer ')) {
            return res.status(401).json({
                message: 'unauthorised'
            });
        }
        let idToken;
        idToken = req.headers.authorization.split('Bearer ')[1];
        const busBoy = new BusBoy({
            headers: req.headers
        });
        let uploadData;
        let oldImagePath;
        busBoy.on('file', (fieldname, file, filename, encoding, mimetype) => {
            const filepath = path.join(os.tmpdir(), filename);
            uploadData = {
                filepath: filepath,
                type: mimetype,
                name: filename
            };
            file.pipe(fs.createReadStream(filepath));
        });
        busBoy.on('field', (filename, value) => {
            oldImagePath = decodeURIComponent(value);
        });
        busBoy.on('finish', () => {
            const bucket = gcs.bucket('flutter-app-32074.appspot.com');
            const id = uuid();
            let imagePath = 'images/' + id + '-' + uploadData.name;
            if (oldImagePath) {
                imagePath = oldImagePath;
            }
            return fbAdmin.auth().verifyToken(idToken).then(decodedToken => {
                return bucket.upload(uploadData.filepath, {
                    uploadType: 'media',
                    destination: imagePath,
                    metadata: {
                        metadata: {
                            contentType: uploadData.type,
                            firbaseStorageDownloadToken: id
                        }
                    }
                });
            }).then(() => {
                return res.status(200).json({
                    imageUrl: 'https://firebasestorage.googleapis.com/v0/b/' +
                        bucket.name +
                        '/o/' +
                        encodeURIComponent(imagePath) +
                        '?alt=media&token=' + id,
                    imagePath: imagePath
                });
            }).catch(error => {
                res.status(401).json({
                    message: 'unauthorised'
                });
            });
        });
        return busBoy.end(req.rawBody);
    });
});