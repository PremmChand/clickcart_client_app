import 'dart:io';
import 'package:firebase_core/firebase_core.dart';

FirebaseOptions firebaseOptions = Platform.isAndroid
    ? const FirebaseOptions(
  apiKey: 'use your firebase api key here',
  appId: '1:375829687117:android:ab6bfbe3b58c5c96126504',
  messagingSenderId: '375829687117',
  projectId: 'clickcart-12f24',
)
    : throw UnsupportedError('This platform is not supported');
