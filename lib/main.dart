import 'package:events_mobile_app/event_screen.dart';
import 'package:events_mobile_app/providers/events.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'event_list.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers:[
        ChangeNotifierProvider.value(value:EventProvider()),
      ],
      child: Sizer(
          builder: (context,orientation, deviceType) {
            return const MaterialApp(
              title: 'Flutter Bloc Demo',
              debugShowCheckedModeBanner: false,
              home: EventList(),
            );
          }

      ),
    );
  }
}
