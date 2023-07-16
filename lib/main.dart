import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:video_call_5/pages/appointment_list.dart';
import 'package:video_call_5/pages/hospital_detail_page.dart';
// import 'package:hospital_app_2/Authentication/Authenticate.dart';
import 'package:video_call_5/HospitalAuthentication/hospital_login_screen.dart';
import 'package:video_call_5/pages/DoctorHomePage.dart';
import 'package:video_call_5/pages/patient_map.dart';
import 'package:video_call_5/widgets/add_doctor_list_page.dart';
import 'package:video_call_5/pages/app_home_page.dart';
import 'package:video_call_5/pages/appointment_list.dart';
import 'package:video_call_5/pages/doctor_appointment_detail_page.dart';
import 'package:video_call_5/pages/doctor_history_page.dart';
import 'package:video_call_5/pages/doctor_login_page.dart';
import 'package:video_call_5/pages/doctor_profile_page.dart';
import 'package:video_call_5/pages/doctor_request_detail_page.dart';
import 'package:video_call_5/pages/home_page.dart';
import 'package:video_call_5/pages/hospital_detail_page.dart';
import 'package:video_call_5/Authentication/login_screen.dart';
import 'package:video_call_5/pages/not_report.dart';
import 'package:video_call_5/pages/profile_page.dart';
import 'package:video_call_5/pages/report_page.dart';
import 'package:video_call_5/utils/routes.dart';
import 'package:video_call_5/widgets/appointment_requested.dart';
// import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:video_call_5/widgets/doctor_appointment.dart';
import 'package:video_call_5/widgets/doctor_me.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // CHeck for Errors
        if (snapshot.hasError) {
          print("Something went Wrong");
        }
        // once Completed, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              // theme: ThemeProvider.of(context),
              routes: {
                // "/": (context) => Authenticate(),
                "/": (context) => AppHomePage(),
                MyRoute.appHomeRoute: (context) => AppHomePage(),
                MyRoute.loginRoute: (context) => LoginScreen(),
                MyRoute.hospitalLoginRoute: (context) =>
                    HospitalLoginScreen(),
                //   MyRoute.homeRoute: (context) => HomePage(),
                MyRoute.detailRoute: (context) =>
                    HospitalDetailPage(),
                MyRoute.profileRoute: (context) => ProfilePage(),
                MyRoute.doctorLoginRoute: (context) =>
                    DoctorLoginPage(),
                MyRoute.doctorHomeRoute: (context) =>
                    DoctorHomePage(),
                MyRoute.doctorMeRoute: (context) => DoctorMe(),
                MyRoute.doctorAppointmentRoute: (context) =>
                    DoctorAppointment(),
                MyRoute.doctorAppointmentDetailRoute: (context) =>
                    DoctorAppointmentDetailPage(),
                MyRoute.doctorRequestDetailRoute: (context) =>
                    DoctorRequestDetailPage(),
                MyRoute.doctorProfileRoute: (context) =>
                    DoctorProfilePage(),
                MyRoute.appointmentListRoute: (context) =>
                    AppointmentListPage(),
                MyRoute.addDoctorListRoute: (context) =>
                    AddDoctorListPage(),
                MyRoute.appointmentRequestedRoute: (context) =>
                    AppointmentRequested(),
                MyRoute.reportRoute: (context) => ReportPage(),
                MyRoute.doctorHistoryRoute: (context) =>
                    DoctorHistoryPage(),
                MyRoute.notReportRoute: (context) => NotReport(),
                MyRoute.patientMapRoute: (context) => PatientMap()
              }
          );
          // return ThemeProvider(
          //     initTheme: ThemeData.light(),
          //     child: Builder(
          //         builder: (context) => MaterialApp(
          //             debugShowCheckedModeBanner: false,
          //             // theme: ThemeProvider.of(context),
          //             routes: {
          //               // "/": (context) => Authenticate(),
          //               "/": (context) => AppHomePage(),
          //               MyRoute.appHomeRoute: (context) => AppHomePage(),
          //               MyRoute.loginRoute: (context) => LoginScreen(),
          //               MyRoute.hospitalLoginRoute: (context) =>
          //                   HospitalLoginScreen(),
          //             //   MyRoute.homeRoute: (context) => HomePage(),
          //               MyRoute.detailRoute: (context) =>
          //                   HospitalDetailPage(),
          //               MyRoute.profileRoute: (context) => ProfilePage(),
          //               MyRoute.doctorLoginRoute: (context) =>
          //                   DoctorLoginPage(),
          //               MyRoute.doctorHomeRoute: (context) =>
          //                   DoctorHomePage(),
          //               MyRoute.doctorMeRoute: (context) => DoctorMe(),
          //               MyRoute.doctorAppointmentRoute: (context) =>
          //                   DoctorAppointment(),
          //               MyRoute.doctorAppointmentDetailRoute: (context) =>
          //                   DoctorAppointmentDetailPage(),
          //               MyRoute.doctorRequestDetailRoute: (context) =>
          //                   DoctorRequestDetailPage(),
          //               MyRoute.doctorProfileRoute: (context) =>
          //                   DoctorProfilePage(),
          //               MyRoute.appointmentListRoute: (context) =>
          //                   AppointmentListPage(),
          //               MyRoute.addDoctorListRoute: (context) =>
          //                   AddDoctorListPage(),
          //               MyRoute.appointmentRequestedRoute: (context) =>
          //                   AppointmentRequested(),
          //               MyRoute.reportRoute: (context) => ReportPage(),
          //               MyRoute.doctorHistoryRoute: (context) =>
          //                   DoctorHistoryPage(),
          //               MyRoute.notReportRoute: (context) => NotReport(),
          //               MyRoute.patientMapRoute: (context) => PatientMap()
          //             }
          //             )
          //     )
          // );
        }
        return CircularProgressIndicator();
      },
    );
  }
}