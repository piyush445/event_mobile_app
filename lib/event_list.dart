import 'package:cached_network_image/cached_network_image.dart';
import 'package:events_mobile_app/event_screen.dart';
import 'package:events_mobile_app/providers/events.dart';
import 'package:events_mobile_app/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:shimmer/shimmer.dart';
import 'models/events.dart';
import 'package:intl/intl.dart';

class EventList extends StatefulWidget {
  const EventList({super.key});

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Events", style: TextStyle(color: Colors.black, fontSize: 18.sp)),
        elevation: 0,
        leadingWidth: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (builder) => SearchScreen()));
            },
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
          SizedBox(
            width: 10.sp,
          ),
          Icon(
            Icons.more_vert_outlined,
            color: Colors.black,
          ),
          SizedBox(
            width: 10.sp,
          ),
        ],
      ),
      body: FutureBuilder(
          future: Provider.of<EventProvider>(context, listen: false).getEvents(context),
          builder: (context, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return _loadingShimmer();
            }
            return Consumer<EventProvider>(
              builder: (ctx, events, child) => ListView.builder(
                scrollDirection: Axis.vertical,
                itemBuilder: ((context, index) {
                  Event currentEvent = events.events[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.sp, horizontal: 10.sp),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => EventScreen(event: currentEvent)));
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
                itemCount: events.events.length,
              ),
            );
          }),
    );
  }

  String _parseDate(data) {
    DateTime dateTime = DateTime.parse(data);
    String dayOfWeek = DateFormat.E().format(dateTime);
    String month = DateFormat.MMMM().format(dateTime);
    String date = DateFormat.d().format(dateTime);


    return dayOfWeek + "," + month + "" + date+" ";
  }

  String _parseTime(data){
     DateTime dateTime = DateTime.parse(data);

    String time = DateFormat.jm().format(dateTime);
    return " "+time;
  }

  _loadingShimmer() {
    return ListView.builder(
      itemBuilder: (_, i) {
        return Shimmer.fromColors(
          baseColor: Color(0xFFE0E0E0),
          highlightColor: Color(0xFFF5F5F5),
          enabled: true,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
      itemCount: 5,
    );
  }
}
