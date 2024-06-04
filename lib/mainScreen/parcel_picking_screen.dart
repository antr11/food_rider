import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_rider/mainScreen/parcel_delivering_screen.dart';

import '../assistantMethods/get_current_location.dart';
import '../global/global.dart';
import '../maps/map_utils.dart';

class ParcelPickingScreen extends StatefulWidget {
  final String? purchaserId;
  final String? sellerId;
  final String? getOrderID;
  final String? purchaserAddress;
  final double? purchaserLat;
  final double? purchaserLng;

  const ParcelPickingScreen({
    super.key,
    this.purchaserId,
    this.sellerId,
    this.getOrderID,
    this.purchaserAddress,
    this.purchaserLat,
    this.purchaserLng,
  });

  @override
  State<ParcelPickingScreen> createState() => _ParcelPickingScreenState();
}

class _ParcelPickingScreenState extends State<ParcelPickingScreen> {
  double? sellerLat, sellerLng;
  String? sellerAdd;

  getSellerData() async {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(widget.sellerId)
        .get()
        .then((documentSnapshot) {
      sellerLat = documentSnapshot.data()!["lat"];
      sellerLng = documentSnapshot.data()!["lng"];
      sellerAdd = documentSnapshot.data()!['address'];
    });
  }

  @override
  void initState() {
    super.initState();

    getSellerData();
  }

  confirmParcelHasBeenPicked(getOrderId, sellerId, purchaserId,
      purchaserAddress, purchaserLat, purchaserLng) {
    FirebaseFirestore.instance.collection("orders").doc(getOrderId).update({
      "status": "delivering",
      "address": completeAddress,
      "lat": position!.latitude,
      "lng": position!.longitude,
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => ParcelDeliveringScreen(
                  purchaserId: purchaserId,
                  purchaserAddress: purchaserAddress,
                  purchaserLat: purchaserLat,
                  purchaserLng: purchaserLng,
                  sellerId: sellerId,
                  getOrderId: getOrderId,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/confirm1.png",
            width: 350,
          ),
          const SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () {
              //show location from rider current location towards seller location
              MapUtils.launchMapFromSourceToDestination(position!.latitude,
                  position!.longitude, sellerLat, sellerLng);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/restaurant.png',
                  width: 50,
                ),
                const SizedBox(
                  width: 7,
                ),
                const Column(
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Xem địa chỉ nhà hàng",
                      style: TextStyle(
                        fontFamily: "Bea",
                        fontSize: 18,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: InkWell(
                onTap: () {
                  UserLocation uLocation = UserLocation();
                  uLocation.getCurrentLocation();

                  //confirmed - that rider has picked parcel from seller
                  confirmParcelHasBeenPicked(
                      widget.getOrderID,
                      widget.sellerId,
                      widget.purchaserId,
                      widget.purchaserAddress,
                      widget.purchaserLat,
                      widget.purchaserLng);
                },
                child: Container(
                  decoration: const BoxDecoration(color: Colors.cyan),
                  width: MediaQuery.of(context).size.width - 90,
                  height: 50,
                  child: const Center(
                    child: Text(
                      "Tài xế đã nhận hàng",
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
