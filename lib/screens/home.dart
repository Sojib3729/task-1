import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intertest/API/api_services.dart';
import 'package:intertest/model/namaz_time.dart';

import '../API/location_service.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String lat = "";
  String lon = "";
  SaladTimeModel saladTimeModel = SaladTimeModel();

  @override
  void initState() {
    getLoc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff3A3A6A),
      // appBar: AppBar(
      //   backgroundColor: Color(0xff3A3A6A),
      //   title: Padding(
      //     padding:  EdgeInsets.symmetric(vertical: 20),
      //     child:
      //   ),
      //   centerTitle: true,
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2.0,
                  ),
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    "Namaz Time",
                    style: TextStyle(
                      color: CupertinoColors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FutureBuilder(
                future: ApiService().getSalatData(
                    context: context,
                    lat: lat,
                    lon: lon,
                    month: "8",
                    year: "2024"),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    saladTimeModel = snapshot.data!;
                    List<Datum> list = saladTimeModel.data!;
                    return SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.8,
                      child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          if (list.isNotEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 2.0,
                                  ),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      _buildPrayerTimes(list[index]),
                                      Divider(color: Colors.grey.shade400),
                                      _buildDateInfo(list[index]),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Text("No Data");
                          }
                        },
                      ),
                    );
                  } else {
                    return Text("No Data");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getLoc() async {
    List<String> loc = await LocationService().getLocation();
    if (loc.length >= 2) {
      lat = loc[0];
      lon = loc[1];
      setState(() {});
    }
  }

  Widget _buildPrayerTimes(Datum datum) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTimeRow("Fajr", datum.timings!.fajr),
        _buildTimeRow("Sunrise", datum.timings!.sunrise),
        _buildTimeRow("Dhuhr", datum.timings!.dhuhr),
        _buildTimeRow("Asr", datum.timings!.asr),
        _buildTimeRow("Sunset", datum.timings!.sunset),
        _buildTimeRow("Maghrib", datum.timings!.maghrib),
        _buildTimeRow("Isha", datum.timings!.isha),
        _buildTimeRow("Imsak", datum.timings!.imsak),
        _buildTimeRow("Midnight", datum.timings!.midnight),
        _buildTimeRow("First Third", datum.timings!.firstthird),
        _buildTimeRow("Last Third", datum.timings!.lastthird),
      ],
    );
  }

  Widget _buildTimeRow(String title, String? time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xff3A3A6A),
            ),
          ),
          Text(
            time ?? "-",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xff3A3A6A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateInfo(Datum datum) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Day: ${datum.date!.gregorian!.weekday!.en}",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff3A3A6A),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                "${datum.meta!.timezone}",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff3A3A6A),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        SizedBox(width: 16), // Add some spacing between the two columns
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Date: ${datum.date!.readable}",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff3A3A6A),
                ),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                "Hijri: ${datum.date!.hijri!.date}",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff3A3A6A),
                ),
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
