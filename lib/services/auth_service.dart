import 'package:firebase_auth/firebase_auth.dart';

Future<User?> registerUser(String email, String password) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  } catch (e) {
    print("Error during registration: $e");
    return null;
  }
}

Future<User?> loginUser(String email, String password) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  } catch (e) {
    print("Error during login: $e");
    return null;
  }
}

void checkAuthState() {
  FirebaseAuth auth = FirebaseAuth.instance;

  auth.authStateChanges().listen((User? user) {
    if (user != null) {

      print("User is signed in: ${user.email}");
    } else {

      print("User is signed out");
    }
  });
}
