import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/colors.dart';
import 'package:food_delivery/entity/user.dart';
import 'package:food_delivery/repository/sepetdao_repository.dart';
import 'package:food_delivery/repository/user_repository.dart';
import 'package:food_delivery/views/home_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddCartPage extends StatefulWidget {
  AddCartPage({Key? key}) : super(key: key);

  @override
  State<AddCartPage> createState() => _AddCartPageState();
}

class _AddCartPageState extends State<AddCartPage> {
  var userRepo = UserRepository();
  double longitude = 0.0;
  double latitude = 0.0;
  Completer<GoogleMapController> mapControl = Completer();
  var startLocation =
      const CameraPosition(target: LatLng(41.03, 28.95), zoom: 15);

  var userEntity = UserEntity(
      email: "email",
      userName: "userName",
      name: "name",
      timeStamp: DateTime.now());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // userRepo.getUserId().then((value) {
    //   userRepo.getUser(value).then((us) {
    //     userEntity = us!;
    //     print(userEntity.userName);
    //   });
    // });

    _determinePosition().then((position) {
      print(position.latitude);
      print(position.longitude);

      print(position.altitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sepet Onay",
            style: TextStyle(fontFamily: "JosefinNormal", fontSize: 26)),
        backgroundColor: c5,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 250,
              child: GoogleMap(
                initialCameraPosition: startLocation,
                mapType: MapType.normal,
                onMapCreated: (GoogleMapController controller) {
                  mapControl.complete(controller);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width / 20,
          horizontal: MediaQuery.of(context).size.width / 30,
        ),
        height: 170,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(offset: Offset(0, -2), blurRadius: 10, color: c2)
            ]),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height / 20,
                  width: MediaQuery.of(context).size.width / 10,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Center(child: Icon(Icons.receipt)),
                ),
                const Spacer(),
                const Text("İndirim Kodunu Yazınız",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    )),
                const SizedBox(
                  width: 10,
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TotalAmount(),
                ElevatedButton.icon(
                  icon: Icon(Icons.location_pin, color: Colors.white),
                  label: Text("Konumumu bul"),
                  onPressed: () {
                    // ignore: avoid_single_cascade_in_expression_statements
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Konumunuz bulunuyor")));
                    goChoosenLocation();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: c5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.done, color: Colors.white),
                  label: Text("Onayla"),
                  onPressed: () {
                    // ignore: avoid_single_cascade_in_expression_statements
                    AwesomeDialog(
                        context: context,
                        dialogType: DialogType.SUCCES,
                        animType: AnimType.SCALE,
                        title: "Başarılı",
                        desc: "Siparişiniz alındı",
                        btnOkOnPress: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => HomePage(
                                      firstTimeLogin: false,
                                      choosenIndex: 0))));
                        })
                      ..show();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: c5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    var pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    setState(() {
      longitude = pos.longitude;
      latitude = pos.latitude;
    });
    return pos;
  }

  Future<void> goChoosenLocation() async {
    GoogleMapController controller = await mapControl.future;

    var position = await _determinePosition();

    var location = CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 15);

    controller.animateCamera(CameraUpdate.newCameraPosition(location));
  }
}

class TotalAmount extends StatefulWidget {
  TotalAmount();

  @override
  State<TotalAmount> createState() => _TotalAmountState();
}

class _TotalAmountState extends State<TotalAmount> {
  var useRepo = UserRepository();
  var sepetRepo = SepetDaoRepository();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: sepetRepo.getTotalAmount(),
      builder: (context, snapshott) {
        if (snapshott.hasData) {
          String? x = snapshott.data;
          print("xXxX $x");

          return Text.rich(TextSpan(
              text: "Total:\n",
              style: TextStyle(color: Colors.grey),
              children: [
                TextSpan(
                    text: "$x,00 ₺",
                    style: TextStyle(fontSize: 16, color: Colors.black))
              ]));
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
