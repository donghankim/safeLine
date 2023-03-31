import 'package:flutter/material.dart';
import 'package:safe_line/constants.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:safe_line/models/train.dart';
import 'package:safe_line/models/report.dart';

void reportModelView(context, Train selTrain) {
  int idx = subwayLines.indexOf(selTrain.line);
  MaterialColor subbgColor = subwayIconColor[idx];
  String dir = "Uptown";
  if (selTrain.direction == "S") {
    dir = "Downtown";
  }

  showMaterialModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext bc) {
      final TextEditingController descriptionController =
          TextEditingController();
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
        child: Column(
          children: [
            const SizedBox(height: 10),

            // heading
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Columbia University",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 25.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      selTrain.headsign,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "ID: ${selTrain.id}",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    subwayLineIcon(selTrain.line, subbgColor),
                    Text(
                      dir,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              ],
            ),

            // textbox
            const SizedBox(height: 25),
            
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Describe the Incident",
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: SizedBox(
                height: 175,
                child: TextField(
                  controller: descriptionController,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // submit button
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () async {
                    Report newReport =
                        Report("selTrain.id", descriptionController.text);
                    await newReport.addReport();

                    if (context.mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Report Saved!"),
                          backgroundColor: accentColor,
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 30),
                    backgroundColor: const Color.fromARGB(255, 94, 78, 228),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                  ),
                  child: const Text("Submit"),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget subwayLineIcon(String line, MaterialColor bgColor) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: SizedBox(
      width: 60,
      height: 60,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
        child: Text(
          line,
          // overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 35.0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
    ),
  );
}
