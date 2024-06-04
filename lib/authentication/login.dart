import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_rider/authentication/register.dart';
import 'package:food_rider/splashScreen/splash_screen.dart';

import '../global/global.dart';
import '../mainScreen/home_screen.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreentState();
}

class _LoginScreentState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  formValidation() {
    if (emailcontroller.text.trim().isNotEmpty &&
        passwordcontroller.text.trim().isNotEmpty) {
      //login
      loginNow();
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return const ErrorDialog(
              message: 'Vui lòng nhập thông tin',
            );
          });
    }
  }

  loginNow() async {
    showDialog(
      context: context,
      builder: (c) {
        return const LoadingDialog(
          message: 'Loading',
        );
      },
    );
    User? currentUser;
    await firebaseAuth
        .signInWithEmailAndPassword(
      email: emailcontroller.text.trim(),
      password: passwordcontroller.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user!;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          });
    });
    if (currentUser != null) {
      readDataAndSetDataLocally(currentUser!).then((value) {
        Navigator.pop(context);
      });
    }
  }

  Future readDataAndSetDataLocally(User currentUser) async {
    await FirebaseFirestore.instance
        .collection("riders")
        .doc(currentUser.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        if (snapshot.data()!["status"] == "approved") {
          await sharedPreferences!.setString("uid", currentUser.uid);
          await sharedPreferences!
              .setString("email", snapshot.data()!["riderEmail"]);
          await sharedPreferences!
              .setString("name", snapshot.data()!["riderName"]);
          await sharedPreferences!
              .setString("photoUrl", snapshot.data()!["riderAvatarUrl"]);
          if (context.mounted) return;
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const HomeScreen()));
        } else {
          firebaseAuth.signOut();
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => const MySplashScreen()));
          Fluttertoast.showToast(
              msg:
                  "Your Account have been banned by Admin. Please contact support");
        }
      } else {
        firebaseAuth.signOut();
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const RegisterScreen()));

        showDialog(
            context: context,
            builder: (c) {
              return const ErrorDialog(
                message: "Không tìm thấy.",
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                'images/logo.png',
                height: 270,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.mail,
                  controller: emailcontroller,
                  hintText: "Email",
                  isObsecre: false,
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: passwordcontroller,
                  hintText: "Password",
                  isObsecre: true,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              formValidation();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
            child: const Text(
              'Đăng nhập',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
