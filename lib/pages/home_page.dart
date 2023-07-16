// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:video_call_5/Authentication/Methods.dart';
// import 'package:hospital_app_2/pages/hospital_detail_page.dart';
import 'package:video_call_5/utils/routes.dart';

import 'package:video_call_5/utils/screen_arguments_doctor_list.dart';
import 'package:video_call_5/widgets/drawer.dart';

import '../utils/ScreenArgumentLatLng.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var firestoreDB = FirebaseFirestore.instance.collection("users").snapshots();
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 243, 247),
      appBar: AppBar(
        title: Center(
          child: Text(
            "Hospital App",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 21,
              color: Colors.white,
            ),
          ),
        ),
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
        backgroundColor: Color(0xff8f94fb),
        iconTheme: IconThemeData(color: Colors.white),
        //elevation: 0,
      ),
      body: StreamBuilder(
          stream: firestoreDB,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());
            return ListView.builder(
                itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                itemBuilder: (BuildContext context, int index) {
                  if ((snapshot.data! as QuerySnapshot).docs[index]
                          ['profession'] ==
                      "Hospital") {
                    String hospitalEmail =
                        (snapshot.data! as QuerySnapshot).docs[index]['email'];
                    String hospitalPhoneNo = (snapshot.data! as QuerySnapshot)
                        .docs[index]['phoneNo'];
                    String id =
                        (snapshot.data! as QuerySnapshot).docs[index]['uid'];
                    String hospitalAddress =
                        (snapshot.data! as QuerySnapshot).docs[index]['address'];
                    String hospitalName =
                        (snapshot.data! as QuerySnapshot).docs[index]['name'];
                    return SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(6, 5, 6, 0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, MyRoute.detailRoute,
                              arguments: ScreenArgumentsDoctorList(
                                  id,hospitalName, hospitalEmail, hospitalPhoneNo,hospitalAddress
                              )
                          );
                        },

                        child: Card(
                          elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(4,8,8,4),
                            decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                    color: Colors.white,
                                  ),
                            child: ListTile(
                              leading: Image.asset(
                                "Assets/images/hospital.png",
                                fit: BoxFit.fitHeight,
                                height: 70,
                              ),
                              title: Expanded(
                                child: Text(
                                    "${(snapshot.data! as QuerySnapshot).docs[index]['name']}",
                                    style: TextStyle(
                                                          //color: Colors.deepOrange,
                                        color: Colors.black,
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.bold)),
                              ),
                              subtitle: Expanded(
                                child: Text(
                                    "${(snapshot.data! as QuerySnapshot).docs[index]['address']}",
                                    style: TextStyle(
                                        color: Color.fromARGB(
                                            255, 155, 155, 155),
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic)),
                              ),
                            ),
                          ),
                        ),
                        // child: Card(
                        //     elevation: 3,
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(8.0),
                        //     ),
                        //     child: Container(
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(8),
                        //         border: Border.all(
                        //           color: Colors.white,
                        //         ),
                        //         color: Colors.white,
                        //       ),
                        //       padding: EdgeInsets.all(10),
                        //       height: 100,
                        //       width: double.infinity,
                        //       child: Row(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Padding(
                        //             padding: const EdgeInsets.fromLTRB(0,0,8,0),
                        //             child: Image.asset(
                        //               "Assets/images/hospital.png",
                        //               fit: BoxFit.fitHeight,
                        //               height: 60,
                        //             ),
                        //           ),
                        //           Expanded(
                        //             child: Column(
                        //                 mainAxisAlignment: MainAxisAlignment.start,
                        //                 crossAxisAlignment: CrossAxisAlignment.start,
                        //                 children: [
                        //                   Expanded(
                        //                     child: Text(
                        //                         "${(snapshot.data! as QuerySnapshot).docs[index]['name']}",
                        //                         style: TextStyle(
                        //                             //color: Colors.deepOrange,
                        //                             color: Colors.black,
                        //                             fontSize: 20,
                        //                             fontWeight: FontWeight.bold)),
                        //                   ),
                        //                   Expanded(
                        //                     child: Text(
                        //                         "${(snapshot.data! as QuerySnapshot).docs[index]['address']}",
                        //                         style: TextStyle(
                        //                             color: Color.fromARGB(
                        //                                 255, 155, 155, 155),
                        //                             fontSize: 16,
                        //                             fontStyle: FontStyle.italic)),
                        //                   ),
                        //                 ]),
                        //           ),
                        //           // GestureDetector(
                        //           //   onTap: () async{
                        //           //     List<Location> locations = await locationFromAddress("${(snapshot.data! as QuerySnapshot).docs[index]['address']}");
                        //           //     setState(() {
                        //           //
                        //           //     });
                        //           //     print("Tushar");
                        //           //     // print(locations.last.latitude.toString());
                        //           //     // print(locations.last.longitude.toString());
                        //           //     Navigator.pushNamed(context, MyRoute.patientMapRoute,
                        //           //         arguments: ScreenArgumentsLatLng(
                        //           //             _auth.currentUser!.displayName,
                        //           //             (snapshot.data! as QuerySnapshot).docs[index]['name'],
                        //           //             locations.last.latitude,
                        //           //             locations.last.longitude
                        //           //         )
                        //           //     );
                        //           //   },
                        //           //   child: Image.asset(
                        //           //     "Assets/images/google_maps.png",
                        //           //     fit: BoxFit.fitHeight,
                        //           //     height: size.height / 16,
                        //           //   ),
                        //           // ),
                        //         ],
                        //       ),
                        //       //   Icon(CupertinoIcons.heart),
                        //       // ]
                        //       //   )
                        //     )),
                      ),
                      //  );
                    );
                  }
                  return Container();
                });
          }),
      drawer: MyDrawer(),
    );
  }
}
