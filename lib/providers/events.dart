import 'dart:convert';

import 'package:events_mobile_app/models/events.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class EventProvider with ChangeNotifier {
  List<Event> _events = [];
  List<Event> get events {
    return [..._events];
  }

  Future<dynamic> getEvents(context) async {
    try {
      dynamic uri = Uri.parse("https://sde-007.api.assignment.theinternetfolks.works/v1/event");
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

        notifyListeners();
      }
    } catch (e) {
      print(e);

    }
  }
}
