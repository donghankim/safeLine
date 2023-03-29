import 'package:flutter/material.dart';
import 'package:safe_line/constants.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


void reportModelView(context) {
  showMaterialModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext bc) {
      return Container(
        height: deviceHeight(context) * 0.5,
        width: deviceWidth(context),
        decoration: const BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
      );
    },
  );
}
