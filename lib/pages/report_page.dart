import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_call_5/Authentication/Methods.dart';
import 'package:video_call_5/pages/report_view.dart';
import 'package:video_call_5/utils/routes.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _firestoreDBPatientAppointment =
      FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
          )),
          backgroundColor: Color(0xff8f94fb),
          actions: [
            Container(
              child: IconButton(
                  onPressed: () {
                    logOut(context);
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Color(0xff8f94fb),
                  )),
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: _firestoreDBPatientAppointment
                .doc(_auth.currentUser!.uid)
                .collection('appointmentHistoryDoctorList')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> _map = snapshot.data!.docs[index]
                        .data() as Map<String, dynamic>;
                    return SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white,
                              ),
                              color: Colors.white,
                            ),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.start,
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
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
                                        "${_map['doctorName']}",
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
                                        Text("${_map['hospitalName']}",
                                            style: TextStyle(
                                              //color: Colors.yellow,
                                              color: Color.fromARGB(
                                                  255, 155, 155, 155),
                                              fontSize: 14,
                                            )),
                                        Text("Date: ${_map['date']}",
                                            style: TextStyle(
                                              //color: Colors.yellow,
                                              color: Color.fromARGB(
                                                  255, 155, 155, 155),
                                              fontSize: 14,
                                            )),
                                        Text("Time: ${_map['fromTime']} - ${_map['toTime']}",
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
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        StreamBuilder(
                                            stream: _firestoreDBPatientAppointment
                                                .doc(_auth.currentUser!.uid)
                                                .collection("reportFileList")
                                                .doc(
                                                "${_map['date']}${_auth.currentUser!.displayName}${_map['doctorName']}")
                                                .snapshots(),
                                            builder: (context,
                                                AsyncSnapshot snapshot) {
                                              var x = snapshot.data;

                                              if (!snapshot.hasData) {
                                                return Center(
                                                    child:
                                                    CircularProgressIndicator());
                                              }
                                              if (snapshot.hasData) {
                                                return InkWell(
                                                    onTap: () {
                                                      try {
                                                        if (x['reportFileUrl'] !=
                                                            null) {
                                                          print("hi yes");
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      ReportView(
                                                                          x['reportFileUrl'])));
                                                        }
                                                      } catch (e) {
                                                        print(
                                                            "no upload report");
                                                        Navigator.pushNamed(
                                                            context,
                                                            MyRoute
                                                                .notReportRoute);
                                                      }
                                                    },
                                                    child: Container(
                                                        width: 110,
                                                        height: 34,
                                                        decoration: BoxDecoration(
                                                            color: Color(
                                                                0xff8f94fb),
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                8.0)),
                                                        child: Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .remove_red_eye,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                      right:
                                                                      9),
                                                                  child: Text(
                                                                      "Report",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                          16,
                                                                          color: CupertinoColors
                                                                              .white)),
                                                                ),
                                                              ],
                                                            )))
                                                );
                                              }
                                              //  }
                                              return Center(
                                                  child:
                                                  SizedBox(height: 40));
                                            }),
                                        InkWell(
                                            onTap: () {
                                              String id = snapshot
                                                  .data!.docs[index].id;
                                              _firestoreDBPatientAppointment
                                                  .doc(_auth.currentUser!.uid)
                                                  .collection(
                                                  'appointmentHistoryDoctorList')
                                                  .doc(id)
                                                  .delete();
                                              _firestoreDBPatientAppointment
                                                  .doc(_auth.currentUser!.uid)
                                                  .collection(
                                                  "reportFileList")
                                                  .doc(
                                                  "${_map['date']}${_auth.currentUser!.displayName}${_map['doctorName']}")
                                                  .delete();
                                            },
                                            child: Container(
                                                width: 110,
                                                height: 34,
                                                decoration: BoxDecoration(
                                                    color: Color(0xff8f94fb),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        8.0)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceEvenly,
                                                  children: [
                                                    Icon(
                                                      Icons.delete,
                                                      color: Colors.white,
                                                    ),
                                                    Padding(
                                                      padding:
                                                      EdgeInsets.only(
                                                          right: 9.0),
                                                      child: Text("Delete",
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                              CupertinoColors
                                                                  .white)),
                                                    ),
                                                  ],
                                                ))
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                        //         SizedBox(height: 3,),
                        //         Text(
                        //           "${_map['doctorName']}",
                        //           style: TextStyle(
                        //               color: Colors.black,
                        //               fontSize: 20,
                        //               fontWeight: FontWeight.bold,
                        //               fontStyle:
                        //                   FontStyle.italic),
                        //         ),
                        //         // SizedBox(height: 5),
                        //         // Text(
                        //         //   "Email:  ${_map['email']}",
                        //         //   style: TextStyle(
                        //         //       color: Colors.black,
                        //         //       fontSize: 20,
                        //         //       fontWeight: FontWeight.bold,
                        //         //       fontStyle:
                        //         //           FontStyle.italic),
                        //         // ),
                        //         SizedBox(height: 5),
                        //         Text(
                        //           "${_map['hospitalName']}",
                        //           style: TextStyle(
                        //               color: Colors.black,
                        //               fontSize: 20,
                        //               fontWeight: FontWeight.bold,
                        //               fontStyle:
                        //                   FontStyle.italic),
                        //         ),
                        //         SizedBox(height: 5),
                        //         Text("Date: ${_map['date']}",
                        //             style: TextStyle(
                        //                 color: Color.fromARGB(
                        //                     255, 155, 155, 155),
                        //                 fontSize: 16,
                        //                 fontStyle:
                        //                     FontStyle.italic)),
                        //         SizedBox(height: 5),
                        //         Text(
                        //             "Time: ${_map['fromTime']} - ${_map['toTime']}",
                        //             style: TextStyle(
                        //                 fontSize: 18,
                        //                 color: Color.fromARGB(
                        //                     255, 155, 155, 155),
                        //                 fontStyle:
                        //                     FontStyle.italic)
                                  //                     ),
                                ]),
                          ),
                        ));
                  });
            }));
  }
}
