import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_rider/mainScreen/parcel_in_progress_screen.dart';

import '../assistantMethods/get_current_location.dart';
import '../authentication/auth_screen.dart';
import '../authentication/login.dart';
import '../global/global.dart';
import 'earnings_screen.dart';
import 'history_screen.dart';
import 'new_orders_screen.dart';
import 'not_yet_delivered_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Card makeDashboardItem(String title, IconData iconData, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: index == 0 || index == 3 || index == 4
            ? BoxDecoration(
                gradient: LinearGradient(
                colors: [
                  Colors.blue.shade50,
                  Colors.blue.shade100,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: const [0.0, 1.0],
                tileMode: TileMode.clamp,
              ))
            : const BoxDecoration(
                gradient: LinearGradient(
                colors: [
                  Colors.black26,
                  Colors.black12,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )),
        child: InkWell(
          onTap: () {
            if (index == 0) {
              //New Available Orders
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const NewOrdersScreen()));
            }
            if (index == 1) {
              //Parcels in Progress
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => const ParcelInProgressScreen()));
            }
            if (index == 2) {
              //Not Yet Delivered
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => const NotYetDeliveredScreen()));
            }
            if (index == 3) {
              //History
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const HistoryScreen()));
            }
            if (index == 4) {
              //Total Earnings
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const EarningsScreen()));
            }
            if (index == 5) {
              //Logout
              firebaseAuth.signOut().then((value) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => const AuthScreen()));
              });
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Icon(
                  iconData,
                  size: 40,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  restrictBannedRidersFromUsingApp() async {
    await FirebaseFirestore.instance
        .collection("riders")
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((snapshot) {
      if (snapshot.data()!["status"] != "approved") {
        Fluttertoast.showToast(msg: "you have been banned by admin");

        firebaseAuth.signOut();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ));
      } else {
        UserLocation uLocation = UserLocation();
        uLocation.getCurrentLocation();
        getPerParcelDeliveryAmount();
        getRiderPreviousEarnings();
      }
    });
  }

  @override
  void initState() {
    super.initState();

    restrictBannedRidersFromUsingApp();
  }

  getRiderPreviousEarnings() {
    FirebaseFirestore.instance
        .collection("riders")
        .doc(sharedPreferences!.getString("uid"))
        .get()
        .then((snap) {
      previousRiderEarnings = snap.data()!["earnings"].toString();
    });
  }

  getPerParcelDeliveryAmount() {
    FirebaseFirestore.instance
        .collection("perDelivery")
        .doc("testing123")
        .get()
        .then((snap) {
      perParcelDeliveryAmount = snap.data()!["amount"].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Colors.cyan),
        ),
        title: Text(
          sharedPreferences!.getString("name") ?? 'rider',
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 1),
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(2),
          children: [
            makeDashboardItem("Đơn hàng mới", Icons.assignment, 0),
            makeDashboardItem("Đơn hàng sẵn sàng", Icons.pedal_bike, 1),
            makeDashboardItem("Đơn hàng chưa giao", Icons.location_history, 2),
            makeDashboardItem("Lịch sử", Icons.done_all, 3),
            makeDashboardItem("Thu nhập", Icons.monetization_on, 4),
            makeDashboardItem("Đăng xuất", Icons.logout, 5),
          ],
        ),
      ),
    );
  }
}
