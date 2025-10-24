import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UiHelper{

  static Widget shimmerWidget({required double width,required double height,double? borderRadius}){
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius != null
              ? BorderRadius.circular(borderRadius)
              : null,
        ),
      ),);
  }



}