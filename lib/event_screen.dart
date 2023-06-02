import 'dart:convert';
import 'dart:ffi' as fi;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:events_mobile_app/styles/asset_paths.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import 'models/events.dart';

class EventScreen extends StatefulWidget {
  final Event event;
  const EventScreen({super.key, required this.event});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Event Details", style: TextStyle(color: Colors.white, fontSize: 18.sp)),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          Container(
            height: 6.sp,
            width: 20.sp,
            margin: EdgeInsets.all(10),
            decoration:
                BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(4.sp)),
            child: Center(
                child: Icon(
              Icons.bookmark,
              size: 15.sp,
            )),
          )
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 220.sp,
                width: double.infinity,
                // color: Colors.red,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        widget.event.bannerImage,
                      ),
                      fit: BoxFit.cover),
                ),
              ),
              SizedBox(
                height: 10.sp,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
                child: Text(
                  widget.event.title,
                  style: TextStyle(fontSize: 30.sp, color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
                child: Column(children: [
                  Row(
                    children: [
                      Container(
                        height: 40.sp,
                        width: 40.sp,
                        decoration: BoxDecoration(
                            // color: Colors.red,
                            borderRadius: BorderRadius.circular(4.sp)),
                        child: Center(
                          child: CachedNetworkImage(imageUrl: widget.event.organiserIcon),
                        ),
                      ),
                      SizedBox(
                        width: 10.sp,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.event.organiserName,
                            style: TextStyle(fontSize: 11.sp),
                          ),
                          SizedBox(
                            height: 3.sp,
                          ),
                          Text(
                            "Organizer",
                            style: TextStyle(fontSize: 8.sp, color: Colors.black38),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.sp,
                  ),
                  Row(
                    children: [
                      Container(
                          height: 40.sp,
                          width: 40.sp,
                          decoration: BoxDecoration(
                              // color: Colors.red,
                              color: Color(0xFFEFF0FF),
                              borderRadius: BorderRadius.circular(4.sp)),
                          child: Center(
                              child: Icon(
                            Icons.calendar_month,
                            color: Color(0xFF5669FF),
                            size: 25.sp,
                          ))),
                      SizedBox(
                        width: 10.sp,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _parseDate(widget.event.dateTime),
                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 3.sp,
                          ),
                          Text(
                            _parseTime(widget.event.dateTime),
                            style: TextStyle(fontSize: 8.sp, color: Colors.black38),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.sp,
                  ),
                  Row(
                    children: [
                      Container(
                          height: 40.sp,
                          width: 40.sp,
                          decoration: BoxDecoration(
                              color: Color(0xFFEFF0FF), borderRadius: BorderRadius.circular(4.sp)),
                          // child: Center(
                          //   child: Image.asset(Assets.navigate,height: 25.sp,width: 25.sp,),
                          // ),
                          child: Center(
                              child: Icon(
                            Icons.pin_drop_rounded,
                            size: 25.sp,
                            color: Color(0xFF5669FF),
                          ))),
                      SizedBox(
                        width: 10.sp,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.event.venueName,
                            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 3.sp,
                          ),
                          Text(
                            widget.event.venueCity + "," + widget.event.venuecountry,
                            style: TextStyle(fontSize: 8.sp, color: Colors.black38),
                          )
                        ],
                      )
                    ],
                  )
                ]),
              ),
              Expanded(child: SizedBox()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 10.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "About Event",
                      style: TextStyle(fontSize: 12.sp),
                    ),
                    SizedBox(
                      height: 15.sp,
                    ),
                    Text(
                      widget.event.description,
                      maxLines: 3,
                      overflow: TextOverflow.fade,
                      style: TextStyle(color: Colors.black, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40.sp,
              ),
            ],
          ),
          _bookNowButton(),
        ],
      ),
    );
  }

  String _parseDate(data) {
    DateTime dateTime = DateTime.parse(data);
    String year = DateFormat.y().format(dateTime);

    String month = DateFormat.MMMM().format(dateTime);
    String date = DateFormat.d().format(dateTime);


    return date +" "+month+", "+year;
  }

  String _parseTime(data){
    DateTime dateTime = DateTime.parse(data);

    String dayOfWeek = DateFormat.EEEE().format(dateTime);


    String time = DateFormat.jm().format(dateTime);
    return dayOfWeek+" "+time;
  }

  Widget _bookNowButton() {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Container(
        height: 60.sp,
        color: Colors.white54,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(left: 70.sp, right: 70.sp, bottom: 17.sp, top: 12.sp),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.sp)),
                minimumSize: Size(100.sp, 35.sp),
                primary: Color(0xFF5669FF)),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text("BOOK NOW",
                      style: TextStyle(
                          color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w500)),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 23.sp,
                    width: 23.sp,
                    // padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue.shade800),
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 14.sp,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
