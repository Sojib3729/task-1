import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intertest/model/namaz_time.dart';


class ApiService {

  late SaladTimeModel saladTimeModel;
  Future<dynamic> getSalatData({
   required String year,
    required String month,
    required String lon,
    required String lat,


    context,
  }) async {
    String url = "https://api.aladhan.com/v1/calendar/$year/$month?latitude=23.6850&longitude=-90.3563&method=2";

    try{
      final response = await http.get(Uri.parse(url));
      print(response.body);

      saladTimeModel = saladTimeModelFromJson(response.body);
      if (saladTimeModel.status == "OK") {
        // var areaData = data["area-list"] as List;

        return saladTimeModel;
      }
      else
      {
        ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Failed")));

        return saladTimeModel;
      }
    }
    catch(e)
    {
      saladTimeModel = SaladTimeModel();
      ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Error Loading Data")));
      return;
    }

  }



}