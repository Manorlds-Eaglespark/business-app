import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget categoryListLoader() {
  return Expanded(
    child: Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      enabled: true,
      child: Center(
        child: ListView.builder(
          itemBuilder: (_, __) => Padding(
            padding:
                const EdgeInsets.only(bottom: 16.0, right: 16.0, left: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150.0,
                  height: 150.0,
                  color: Colors.white,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                Container(
                  width: 150.0,
                  height: 150.0,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          itemCount: 5,
        ),
      ),
    ),
  );
}
