import 'package:flutter/material.dart';
import 'package:safe_line/constants.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:safe_line/models/train.dart';
import 'package:safe_line/models/report.dart';

void reportModelView(context, Train selTrain, String stationName) {
  int idx = subwayLines.indexOf(selTrain.line);
  MaterialColor subbgColor = subwayIconColor[idx];
  String dir = "Uptown";
  if (selTrain.direction == "S") {
    dir = "Downtown";
  }
  final TextEditingController descriptionController = TextEditingController();

  showMaterialModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext bc) {
      return Container(
        height: deviceHeight(context) * 0.65,
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
            // heading
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Next St: $stationName",
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        selTrain.headsign,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "(ID: ${selTrain.id})",
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 10.0,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w300,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Column(
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
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: SizedBox(
                height: 100,
                child: TextField(
                  controller: descriptionController,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Report newReport =
                    Report(selTrain.id, descriptionController.text);
                await newReport.addReport();
                selTrain.incidentReports.add(newReport);

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
              child: const Text("Submit Report"),
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
      width: 50,
      height: 50,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
        child: Text(
          line,
          // overflow: TextOverflow.visible,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 30.0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
    ),
  );
}
