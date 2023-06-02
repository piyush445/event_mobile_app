import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:events_mobile_app/event_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'models/events.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Event> _events = [];

  Future<void> _searchEvents(query) async {
    try {
      dynamic uri =
          Uri.parse("https://sde-007.api.assignment.theinternetfolks.works/v1/event?search=$query");
      final response = await http.get(uri, headers: {});
      print(json.decode(response.body));

      var profileData = json.decode(response.body);
      final List<Event> loadedEvents = [];
      var content = profileData['content'] as Map;
      final List<dynamic> data = content['data'];

      for (int i = 0; i < data.length; i++) {
        loadedEvents.add(Event(
            id: data[i]['id'],
            bannerImage: data[i]['banner_image'],
            title: data[i]['title'],
            dateTime: data[i]['date_time'] ?? "",
            organiserName: data[i]['organiser_name'] ?? "",
            description: data[i]['description'] ?? "",
            organiserIcon: data[i]["organiser_icon"],
            venueName: data[i]['venue_name'],
            venueCity: data[i]['venue_city'],
            venuecountry: data[i]['venue_country']));

        _events = loadedEvents.toList();
      }
      setState(() {
        _events = loadedEvents.toList();
      });
    } catch (e) {
      print(e);
    }
  }

  void _runFilter(String enteredKeyword) {
    print(enteredKeyword);

    if (enteredKeyword.isEmpty) {
      setState(() {
        _events = [];
      });
    } else {
      _searchEvents(enteredKeyword);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.white,
          title: Text("Search", style: TextStyle(color: Colors.black, fontSize: 18.sp)),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Column(
          children: [
            TextField(
              textAlignVertical: TextAlignVertical.center,
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                hintText: 'Type Event Name',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFF5669FF),
                ),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(
              height: 10.sp,
            ),
            _showEvents()
          ],
        ));
  }

  String _parseDate(data) {
    DateTime dateTime = DateTime.parse(data);
    String dayOfWeek = DateFormat.E().format(dateTime);
    String month = DateFormat.MMMM().format(dateTime);
    String date = DateFormat.d().format(dateTime);

    return dayOfWeek + ", " + month + " " + date + " ";
  }

  String _parseTime(data) {
    DateTime dateTime = DateTime.parse(data);

    String time = DateFormat.jm().format(dateTime);
    return " " + time;
  }

  _showEvents() {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemBuilder: ((context, index) {
          Event currentEvent = _events[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => EventScreen(event: currentEvent)));
              },
              child: Card(
                elevation: 0.5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.sp)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 75.sp,
                            width: 65.sp,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      currentEvent.bannerImage,
                                    ),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(6.sp),
                                color: Colors.grey.shade300),
                          ),
                          SizedBox(
                            width: 10.sp,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    _parseDate(currentEvent.dateTime),
                                    style: TextStyle(color: Colors.blue.shade900),
                                  ),
                                  Container(
                                    height: 4.sp,
                                    width: 4.sp,
                                    // margin: EdgeInsets.only(top: .sp),
                                    decoration: new BoxDecoration(
                                      color: Colors.blue.shade900,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Text(
                                    _parseTime(currentEvent.dateTime),
                                    style: TextStyle(color: Colors.blue.shade900),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 3.sp,
                              ),
                              Text(
                                currentEvent.organiserName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 5.sp,
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 170.sp),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: Colors.grey,
                                      size: 10.sp,
                                    ),
                                    Text(
                                      currentEvent.venueName + " ",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 8.sp, color: Colors.grey),
                                    ),
                                    Container(
                                      height: 4.sp,
                                      width: 4.sp,
                                      margin: EdgeInsets.only(top: 3.sp),
                                      decoration: new BoxDecoration(
                                        color: Colors.grey.shade400,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Expanded(
                                        child: Text(
                                      " " +
                                          currentEvent.venueCity +
                                          "," +
                                          currentEvent.venuecountry,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 8.sp, color: Colors.grey),
                                    ))
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        itemCount: _events.length,
      ),
    );
  }
}
