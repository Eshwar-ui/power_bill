import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:power_bill/services/Newservicepage.dart';
import 'package:power_bill/services/PowerOutagePage.dart';
import 'package:power_bill/services/SuppyGrievancesPage.dart';
import 'package:power_bill/services/Voltagefluctuationpage.dart';
import 'package:power_bill/services/additionalloadpage.dart';
import 'package:power_bill/services/addresscorrectionpage.dart';
import 'package:power_bill/services/billingissuesPage.dart';
import 'package:power_bill/services/changeofcategorypage.dart';
import 'package:power_bill/services/contactuspage.dart';
import 'package:power_bill/services/greentarifpage.dart';
import 'package:power_bill/services/knowyourofficepage.dart';
import 'package:power_bill/services/metterissuesPage.dart';
import 'package:power_bill/services/otherservicepage.dart';
import 'package:power_bill/services/reportpowertheftpage.dart';
import 'package:power_bill/services/roofTopSolarpage.dart';
import 'package:power_bill/services/safetypage.dart';
import 'package:power_bill/services/savepowerpage.dart';
import 'package:power_bill/services/shiftingworkspage.dart';
import 'package:power_bill/services/tariffdetailspage.dart';
import 'package:power_bill/services/titletransferpage.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Center(
              child: Text(
            'Services',
            style: TextStyle(fontSize: 32.sp),
          )),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Theme.of(context).colorScheme.primary,
              const Color.fromARGB(255, 54, 54, 54)
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0.h),
                    child: ExpansionTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r)),
                      tilePadding: EdgeInsets.symmetric(
                          vertical: 12.h, horizontal: 25.w),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      childrenPadding: EdgeInsets.all(10.w),
                      collapsedBackgroundColor:
                          Theme.of(context).colorScheme.primary,
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0.r),
                      ),
                      leading: Image.asset(
                          "lib/assets/service_logos/customer-care.png",
                          width: 40.w,
                          height: 40.h),
                      title: Text(
                        "Customer Grievances",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp),
                      ),
                      children: <Widget>[
                        ListTile(
                          leading: Image.asset(
                            "lib/assets/service_logos/outage.png",
                            width: 40.w,
                            height: 40.h,
                          ),
                          title: Text(
                            "Power Outage",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontWeight: FontWeight.normal,
                                fontSize: 20.sp),
                          ),
                          onTap: () {
                            // Handle option 1 tap
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PowerOutagePage()));
                          },
                        ),
                        ListTile(
                          leading: Image.asset(
                            "lib/assets/service_logos/electricity.png",
                            width: 40.w,
                            height: 40.h,
                          ),
                          title: Text(
                            "Voltage fluctuation",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontWeight: FontWeight.normal,
                                fontSize: 20.sp),
                          ),
                          onTap: () {
                            // Handle option 2 tap
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Voltagefluctuationpage()));
                          },
                        ),
                        ListTile(
                          leading: Image.asset(
                            "lib/assets/service_logos/customer-care.png",
                            width: 40.w,
                            height: 40.h,
                          ),
                          title: Text(
                            "supply grievances",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontWeight: FontWeight.normal,
                                fontSize: 20.sp),
                          ),
                          onTap: () {
                            // Handle option 2 tap
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SuppyGrievancesPage()));
                          },
                        ),
                        ListTile(
                          leading: Image.asset(
                            "lib/assets/service_logos/electric-meter.png",
                            width: 40.w,
                            height: 40.h,
                          ),
                          title: Text(
                            "Meter issues",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontWeight: FontWeight.normal,
                                fontSize: 20.sp),
                          ),
                          onTap: () {
                            // Handle option 2 tap
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => metterissuesPage()));
                          },
                        ),
                        ListTile(
                          leading: Image.asset(
                            "lib/assets/service_logos/bill icon.png",
                            width: 40.w,
                            height: 40.h,
                          ),
                          title: Text(
                            "billing issues",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontWeight: FontWeight.normal,
                                fontSize: 20.sp),
                          ),
                          onTap: () {
                            // Handle option 1 tap
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => billingissuesPage()));
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0.h),
                    child: ExpansionTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r)),
                      tilePadding: EdgeInsets.symmetric(
                          vertical: 12.h, horizontal: 25.w),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      childrenPadding: EdgeInsets.all(10.w),
                      collapsedBackgroundColor:
                          Theme.of(context).colorScheme.primary,
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0.r),
                      ),
                      leading: Image.asset("lib/assets/service_logos/apply.png",
                          width: 40.w, height: 40.h),
                      title: Text(
                        "Apply for service",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp),
                      ),
                      children: <Widget>[
                        ListTile(
                          leading: Image.asset(
                            "lib/assets/service_logos/new.png",
                            width: 40.w,
                            height: 40.h,
                          ),
                          title: Text(
                            "New Service Application",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontWeight: FontWeight.normal,
                                fontSize: 20.sp),
                          ),
                          onTap: () {
                            // Handle option 1 tap
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Newservicepage()));
                          },
                        ),
                        ListTile(
                          leading: Image.asset(
                            "lib/assets/service_logos/TARIF.png",
                            width: 40.w,
                            height: 40.h,
                          ),
                          title: Text(
                            "Green Tarif",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontWeight: FontWeight.normal,
                                fontSize: 20.sp),
                          ),
                          onTap: () {
                            // Handle option 1 tap
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => greentarifpage()));
                          },
                        ),
                        ListTile(
                          leading: Image.asset(
                            "lib/assets/service_logos/solar-panels.png",
                            width: 40.w,
                            height: 40.h,
                          ),
                          title: Text(
                            "Roof Top Solar",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontWeight: FontWeight.normal,
                                fontSize: 20.sp),
                          ),
                          onTap: () {
                            // Handle option 1 tap
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => roofTopSolarpage()));
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0.h),
                    child: ExpansionTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r)),
                      tilePadding: EdgeInsets.symmetric(
                          vertical: 12.h, horizontal: 25.w),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      childrenPadding: EdgeInsets.all(10.r),
                      collapsedBackgroundColor:
                          Theme.of(context).colorScheme.primary,
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0.r),
                      ),
                      leading: Image.asset(
                          "lib/assets/service_logos/electric-meter.png",
                          width: 40.w,
                          height: 40.h),
                      title: Text(
                        "Service Request",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp),
                      ),
                      children: <Widget>[
                        ListTile(
                          title: Text("title transfer"),
                          onTap: () {
                            // Handle option 1 tap
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => titletransferpage()));
                          },
                        ),
                        ListTile(
                          title: Text("Address Corection"),
                          onTap: () {
                            // Handle option 1 tap
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        addresscorrectionpage()));
                          },
                        ),
                        ListTile(
                          title: Text("change of category"),
                          onTap: () {
                            // Handle option 2 tap
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        changeofcategorypage()));
                          },
                        ),
                        ListTile(
                          title: Text("Additional Load"),
                          onTap: () {
                            // Handle option 3 tap
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        additionalloadpage()));
                          },
                        ),
                        ListTile(
                          title: Text("Shifting works"),
                          onTap: () {
                            // Handle option 3 tap
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => shiftingworkspage()));
                          },
                        ),
                        ListTile(
                          title: Text("other service requests"),
                          onTap: () {
                            // Handle option 3 tap
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => otherservicepage()));
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.0.h),
                    child: ExpansionTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r)),
                      tilePadding: EdgeInsets.symmetric(
                          vertical: 12.h, horizontal: 25.w),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      childrenPadding: EdgeInsets.all(10.r),
                      collapsedBackgroundColor:
                          Theme.of(context).colorScheme.primary,
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0.r),
                      ),
                      leading: Image.asset(
                          "lib/assets/util_icons/other services.png",
                          width: 40.w,
                          height: 40.h),
                      title: Text(
                        " Other Service",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp),
                      ),
                      children: <Widget>[
                        ListTile(
                          title: Text("report power theft"),
                          onTap: () {
                            // Handle option 1 tap
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        reportpowertheftpage()));
                          },
                        ),
                        ListTile(
                          title: Text("contact us"),
                          onTap: () {
                            // Handle option 2 tap
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ContactUsPage()));
                          },
                        ),
                        ListTile(
                          title: Text("know your office"),
                          onTap: () {
                            // Handle option 3 tap
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        knowyourofficepage()));
                          },
                        ),
                        ListTile(
                          title: Text("tariff details"),
                          onTap: () {
                            // Handle option 3 tap
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => tariffdetailspage()));
                          },
                        ),
                        ListTile(
                          title: Text("safety tips"),
                          onTap: () {
                            // Handle option 3 tap
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => safetypage()));
                          },
                        ),
                        ListTile(
                          title: Text("save power"),
                          onTap: () {
                            // Handle option 3 tap
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => savepowerpage()));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
