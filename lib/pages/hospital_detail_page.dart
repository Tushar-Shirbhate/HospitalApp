import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:quantupi/quantupi.dart';
import 'package:video_call_5/Authentication/Methods.dart';
import 'package:video_call_5/pages/chat_room.dart';
import 'package:video_call_5/utils/routes.dart';
import 'package:video_call_5/utils/screen_arguments_doctor_list.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:video_call_5/video_call_screen.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../utils/ScreenArgumentLatLng.dart';

class HospitalDetailPage extends StatefulWidget {

  @override
  State<HospitalDetailPage> createState() => _HospitalDetailPageState();
}

class _HospitalDetailPageState extends State<HospitalDetailPage>{
  final CollectionReference _firestoreDBDoctorList =
      FirebaseFirestore.instance.collection("users");
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool getAppointment = false;
  String hospitalEmail = "";
  String hospitalName = "";
  String hospitalPhoneNo = "";
  String hospitalAddress = "";
  Map<String, dynamic>? userMap;
  String _colorName = 'No';
  Color _color = Colors.black;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;

  String data = 'No transaction yet';

  String appname = paymentappoptions[0];

  Future<String> initiateTransaction({QuantUPIPaymentApps? app}) async {
    Quantupi upi = Quantupi(
      receiverUpiId: '9146909255@ybl',
      receiverName: 'Tushar Shirbhate',
      transactionRefId: 'TestingId',
      transactionNote: 'Hospital Payment',
      amount: 1.0,
      appname: app,
    );
    String response = await upi.startTransaction();

    return response;
  }
  void onClick() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection("users")
        .where("email", isEqualTo: hospitalEmail)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
      print(hospitalEmail);
    });
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final argsDL =
        ModalRoute.of(context)!.settings.arguments as ScreenArgumentsDoctorList;
    String id = argsDL.id;
    hospitalEmail = argsDL.hospitalEmail;
    hospitalName = argsDL.hospitalName;
    hospitalPhoneNo = argsDL.hospitalPhoneNo;
    hospitalAddress = argsDL.hospitalAddress;
    final size = MediaQuery.of(context).size;
    bool isios = !kIsWeb && Platform.isIOS;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 243, 247),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Center(
          child: Text(
            "Hospital App",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Color(0xff8f94fb),
        actions: [
          Container(
            child: IconButton(
                onPressed: () {
                  logOut(context);
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                )),
          )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: 680,
              child: StreamBuilder(
                  stream: _firestoreDBDoctorList
                      .doc(id)
                      .collection("doctorList")
                      .snapshots(),
                  builder: (BuildContext context, snapshots) {
                    if (!snapshots.hasData)
                      return Center(child: CircularProgressIndicator());
                    return ListView.builder(
                        itemCount: (snapshots.data! as QuerySnapshot).docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          Map<String, dynamic> map = (snapshots.data! as QuerySnapshot)
                              .docs[index]
                              .data() as Map<String, dynamic>;

                          return SingleChildScrollView(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                              child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Container(
                              // padding: const EdgeInsets.fromLTRB(2,8,8,2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading:
                                    (index%2==0)?Image.asset(
                                      "Assets/images/doctor_6.png",
                                      fit: BoxFit.cover,
                                      height: 60,
                                    ):Image.asset(
                                      "Assets/images/nutritionist_3.png",
                                      // "Assets/images/doctor_6.png",

                                      fit: BoxFit.fitHeight,
                                      height: 60,
                                    ),
                                    title: Expanded(
                                      child: Text(
                                        map['doctorName'],
                                        style: TextStyle(
                                          // color: Colors.white,
                                            color: Colors.black,
                                            fontSize: 16.5,
                                            fontWeight: FontWeight.bold),
                                      ),

                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(map['doctorPost'],
                                            style: TextStyle(
                                              //color: Colors.yellow,
                                              color: Color.fromARGB(
                                                  255, 155, 155, 155),
                                              fontSize: 14,
                                            )),
                                        Text(map['doctorSpeciality'],
                                            style: TextStyle(
                                              //color: Colors.yellow,
                                              color: Color.fromARGB(
                                                  255, 155, 155, 155),
                                              fontSize: 14,
                                            )),
                                        Text(map['doctorEducation'],
                                            style: TextStyle(
                                              //color: Colors.yellow,
                                              color: Color.fromARGB(
                                                  255, 155, 155, 155),
                                              fontSize: 14,
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                // SizedBox(height: 3,),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                                        title: Text("Get Appointment"),
                                                        content: SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              SizedBox(height: 10),
                                                              Text(
                                                                  "Do you want to send request for appointment to ${map['doctorName']}?",
                                                                  style: TextStyle(
                                                                    fontSize: 16,
                                                                  )),
                                                            ],
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children: [
                                                              TextButton(
                                                                onPressed: () async {
                                                                  Map<String, dynamic>
                                                                      doctorList = {
                                                                    "doctorName":
                                                                        map['doctorName'],
                                                                    "doctorPost":
                                                                        map['doctorPost'],
                                                                    "doctorSpeciality":
                                                                        map['doctorSpeciality'],
                                                                    "doctorEducation":
                                                                        map['doctorEducation'],
                                                                    "hospitalUid": id,
                                                                  };
                                                                  _firestoreDBDoctorList
                                                                      .doc(_auth
                                                                          .currentUser!.uid)
                                                                      .collection(
                                                                          'appointmentRequestedDoctorList')
                                                                      .add(doctorList);

                                                                  var _firestore =
                                                                      FirebaseFirestore
                                                                          .instance
                                                                          .collection("users")
                                                                          .doc(_auth
                                                                              .currentUser!
                                                                              .uid);
                                                                  DocumentSnapshot snapshot =
                                                                      await _firestore.get();
                                                                  FirebaseFirestore.instance
                                                                      .collection("users")
                                                                      .doc(id)
                                                                      .collection(
                                                                          'patientRequestList')
                                                                      .add({
                                                                    'patientName':
                                                                        snapshot['name'],
                                                                    'phoneNo':
                                                                        snapshot['phoneNo'],
                                                                    'email': snapshot['email'],
                                                                    'uid':
                                                                        _auth.currentUser!.uid,
                                                                    'patientAddress':
                                                                    snapshot['address'],
                                                                    'doctorName':
                                                                        map['doctorName'],
                                                                    "doctorPost":
                                                                        map['doctorPost'],
                                                                    "doctorSpeciality":
                                                                        map['doctorSpeciality'],
                                                                    "doctorEducation":
                                                                        map['doctorEducation'],
                                                                  });

                                                                  Navigator.pushNamed(
                                                                      context,
                                                                      MyRoute
                                                                          .appointmentListRoute);
                                                                },
                                                                child: Text("Done",
                                                                style: TextStyle(
                                                                  color: Color(0xff8f94fb)
                                                                ),),
                                                              ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(ctx).pop();
                                                            },
                                                            child: Text("Cancel",
                                                            style: TextStyle(
                                                              color: Color(0xff8f94fb)
                                                            ),),
                                                          ),
                                                        ]
                                                          ),
                                                        ],
                                                      ),
                                    );
                                    },
                                  child: Container(
                                      margin: EdgeInsets.fromLTRB(58, 5, 58, 5),
                                      width: double.infinity,
                                      height: 37,
                                      decoration: BoxDecoration(
                                          color: Color(0xff8f94fb),
                                          borderRadius:
                                          BorderRadius.circular(20.0)),
                                      child: Center(
                                          child: Text("Get Appointment",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: CupertinoColors
                                                      .white)))),
                                ),
                                  SizedBox(height: 2,),
                                ],
                              ),
                            ),
                          ),
                              // child: Card(
                              //     elevation: 3,
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(8.0),
                              //     ),
                              //     child: Container(
                              //         decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(8),
                              //           border: Border.all(
                              //             // color: Colors.deepOrange,
                              //             color: Colors.white,
                              //           ),
                              //           //color: Colors.blueAccent,
                              //           color: Colors.white,
                              //         ),
                              //         padding: EdgeInsets.all(12),
                              //         height: size.height / 4.2,
                              //         width: double.infinity,
                              //         //  padding: EdgeInsets.all(15),
                              //         child: Column(
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.spaceBetween,
                              //             children: [
                              //               Row(children: [
                              //                 // Image.asset(
                              //                 //   "assets/images/user.png",
                              //                 // ),
                              //                 Column(
                              //                     mainAxisAlignment:
                              //                         MainAxisAlignment.start,
                              //                     crossAxisAlignment:
                              //                         CrossAxisAlignment.start,
                              //                     children: [
                              //                       Text(
                              //                         map['doctorName'],
                              //                         style: TextStyle(
                              //                             // color: Colors.white,
                              //                             color: Colors.black,
                              //                             fontSize: 20,
                              //                             fontWeight: FontWeight.bold),
                              //                       ),
                              //                       Text(map['doctorPost'],
                              //                           style: TextStyle(
                              //                             //color: Colors.yellow,
                              //                             color: Color.fromARGB(
                              //                                 255, 155, 155, 155),
                              //                             fontSize: 16,
                              //                           )),
                              //                       Text(map['doctorSpeciality'],
                              //                           style: TextStyle(
                              //                             //color: Colors.yellow,
                              //                             color: Color.fromARGB(
                              //                                 255, 155, 155, 155),
                              //                             fontSize: 16,
                              //                           )),
                              //                       Text(map['doctorEducation'],
                              //                           style: TextStyle(
                              //                             //color: Colors.yellow,
                              //                             color: Color.fromARGB(
                              //                                 255, 155, 155, 155),
                              //                             fontSize: 16,
                              //                           )
                            //                           ),
                              //                     ]),
                              //               ]),
                              //               SizedBox(
                              //                 height: 5,
                              //               ),
                              //               InkWell(
                              //                 onTap: () {
                              //                   showDialog(
                              //                     context: context,
                              //                     builder: (ctx) => AlertDialog(
                              //                       title: Text("Get Appointment"),
                              //                       content: SingleChildScrollView(
                              //                         child: Column(
                              //                           children: [
                              //                             SizedBox(height: 10),
                              //                             Text(
                              //                                 "Do you want to send request for appointment to ${map['doctorName']}?",
                              //                                 style: TextStyle(
                              //                                   fontSize: 16,
                              //                                 )),
                              //                           ],
                              //                         ),
                              //                       ),
                              //                       actions: <Widget>[
                              //                         ElevatedButton(
                              //                           onPressed: () async {
                              //                             Map<String, dynamic>
                              //                                 doctorList = {
                              //                               "doctorName":
                              //                                   map['doctorName'],
                              //                               "doctorPost":
                              //                                   map['doctorPost'],
                              //                               "doctorSpeciality":
                              //                                   map['doctorSpeciality'],
                              //                               "doctorEducation":
                              //                                   map['doctorEducation'],
                              //                               "hospitalUid": id,
                              //                             };
                              //                             _firestoreDBDoctorList
                              //                                 .doc(_auth
                              //                                     .currentUser!.uid)
                              //                                 .collection(
                              //                                     'appointmentRequestedDoctorList')
                              //                                 .add(doctorList);
                              //
                              //                             var _firestore =
                              //                                 FirebaseFirestore
                              //                                     .instance
                              //                                     .collection("users")
                              //                                     .doc(_auth
                              //                                         .currentUser!
                              //                                         .uid);
                              //                             DocumentSnapshot snapshot =
                              //                                 await _firestore.get();
                              //                             FirebaseFirestore.instance
                              //                                 .collection("users")
                              //                                 .doc(id)
                              //                                 .collection(
                              //                                     'patientRequestList')
                              //                                 .add({
                              //                               'patientName':
                              //                                   snapshot['name'],
                              //                               'phoneNo':
                              //                                   snapshot['phoneNo'],
                              //                               'email': snapshot['email'],
                              //                               'uid':
                              //                                   _auth.currentUser!.uid,
                              //                               'doctorName':
                              //                                   map['doctorName'],
                              //                               "doctorPost":
                              //                                   map['doctorPost'],
                              //                               "doctorSpeciality":
                              //                                   map['doctorSpeciality'],
                              //                               "doctorEducation":
                              //                                   map['doctorEducation'],
                              //                             });
                              //
                              //                             Navigator.pushNamed(
                              //                                 context,
                              //                                 MyRoute
                              //                                     .appointmentListRoute);
                              //                           },
                              //                           child: Text("Done"),
                              //                         ),
                              //                         SizedBox(width: size.width / 5),
                              //                         ElevatedButton(
                              //                           onPressed: () {
                              //                             Navigator.of(ctx).pop();
                              //                           },
                              //                           child: Text("Cancel"),
                              //                         ),
                              //                       ],
                              //                     ),
                              //                   );
                              //                 },
                              //                 child: Container(
                              //                     margin:
                              //                         EdgeInsets.fromLTRB(50, 5, 50, 5),
                              //                     width: double.infinity,
                              //                     height: 37,
                              //                     decoration: BoxDecoration(
                              //                         color: Color(0xff8f94fb),
                              //                         borderRadius:
                              //                             BorderRadius.circular(20.0)),
                              //                     child: Center(
                              //                         child: Text("Get Appointment",
                              //                             style: TextStyle(
                              //                                 fontSize: 19,
                              //                                 color: CupertinoColors
                              //                                     .white)))),
                              //               )
                              //             ])))
                          );
                        });
                  }),
            ),
          ),
          CircularMenu(
            alignment: Alignment.bottomCenter,
            toggleButtonColor:  Color(0xff8f94fb),
            // toggleButtonAnimatedIconData: AnimatedIcons.view_list,
            items: [
              CircularMenuItem(
                  icon:  Icons.call,
                  color: Colors.green,
                  onTap: () async{
                    await FlutterPhoneDirectCaller.callNumber(hospitalPhoneNo);
                    setState(() {
                      _color = Colors.green;
                      _colorName = 'Green';
                    });
                  }),
              CircularMenuItem(
                  icon: Icons.mail_rounded,
                  color: Colors.orange,
                  onTap: () {
                            onClick();
                            if (userMap != null) {
                              String roomId = chatRoomId(
                                  _auth.currentUser!.displayName!, userMap!['name']);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) =>
                                          ChatRoom(chatRoomId: roomId, userMap: userMap!)));
                            }
                    setState(() {
                      _color = Colors.orange;
                      _colorName = 'Orange';
                    });
                  }),
              CircularMenuItem(
                  icon: CupertinoIcons.video_camera_solid,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => VideoCallScreen()));
                    setState(() {
                      _color = Colors.blue;
                      _colorName = 'Blue';
                    });
                  }
                  ),
              CircularMenuItem(
                  // icon: Icons.map,
                  // icon: CupertinoIcons.map_pin_ellipse,
                  icon:CupertinoIcons.location_solid,
                  color: Colors.purple,
                  onTap: () async{
                      List<Location> locations = await locationFromAddress(hospitalAddress);
                      setState(() {

                      });
                      print("Tushar");
                      // print(locations.last.latitude.toString());
                      // print(locations.last.longitude.toString());
                      Navigator.pushNamed(context, MyRoute.patientMapRoute,
                          arguments: ScreenArgumentsLatLng(
                              _auth.currentUser!.displayName,
                              hospitalName,
                              locations.last.latitude,
                              locations.last.longitude
                          )
                      );

                    setState(() {
                      _color = Colors.blue;
                      _colorName = 'Blue';
                    });
                  }
                  ),
              CircularMenuItem(
                  icon: Icons.payment,
                  color: Colors.brown,
                  // onTap:(){
                  onTap: () async {
                      String value = await initiateTransaction(
                      app: isios ? appoptiontoenum(appname) : null,
                      );
                      setState(() {
                      data = value;
                      });

                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (_) => PaymentService()));
                    setState(() {
                      _color = Colors.brown;
                      _colorName = 'Brown';
                    });
                  })
            ],
          ),
        ],
      ),
      // floatingActionButton:
      //     Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //   Padding(
      //     padding: EdgeInsets.fromLTRB(32, 0, 0, 0),
      //     child: Align(
      //       alignment: Alignment.bottomRight,
      //       child: FloatingActionButton(
      //         backgroundColor: Color(0xff8f94fb),
      //         child: Icon(
      //           Icons.call,
      //           color: Colors.white,
      //         ),
      //         onPressed: () async {
      //           await FlutterPhoneDirectCaller.callNumber(hospitalPhoneNo);
      //         },
      //       ),
      //     ),
      //   ),
      //   Align(
      //     alignment: Alignment.bottomLeft,
      //     child: FloatingActionButton(
      //       backgroundColor: Color(0xff8f94fb),
      //       child: Icon(
      //         Icons.messenger_rounded,
      //         color: Colors.white,
      //       ),
      //       onPressed: () {
      //         onClick();
      //         if (userMap != null) {
      //           String roomId = chatRoomId(
      //               _auth.currentUser!.displayName!, userMap!['name']);
      //           Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (_) =>
      //                       ChatRoom(chatRoomId: roomId, userMap: userMap!)));
      //         }
      //       },
      //     ),
      //   ),
      // ]),
    );
  }
  QuantUPIPaymentApps appoptiontoenum(String appname) {
    switch (appname) {
      case 'Amazon Pay':
        return QuantUPIPaymentApps.amazonpay;
      case 'BHIMUPI':
        return QuantUPIPaymentApps.bhimupi;
      case 'Google Pay':
        return QuantUPIPaymentApps.googlepay;
      case 'Mi Pay':
        return QuantUPIPaymentApps.mipay;
      case 'Mobikwik':
        return QuantUPIPaymentApps.mobikwik;
      case 'Airtel Thanks':
        return QuantUPIPaymentApps.myairtelupi;
      case 'Paytm':
        return QuantUPIPaymentApps.paytm;

      case 'PhonePe':
        return QuantUPIPaymentApps.phonepe;
      case 'SBI PAY':
        return QuantUPIPaymentApps.sbiupi;
      default:
        return QuantUPIPaymentApps.googlepay;
    }
  }
}
const List<String> paymentappoptions = [
  'Amazon Pay',
  'BHIMUPI',
  'Google Pay',
  'Mi Pay',
  'Mobikwik',
  'Airtel Thanks',
  'Paytm',
  'PhonePe',
  'SBI PAY',
];
