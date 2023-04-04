import 'package:flutter/material.dart';
import 'package:safe_line/constants.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:safe_line/models/train.dart';
import 'package:safe_line/models/report.dart';


void reportModelView(context, Train currTrain) {
  int idx = subwayLines.indexOf(currTrain.line);
  MaterialColor subbgColor = subwayIconColor[idx];
  String dir = "Uptown";
  if (currTrain.direction == "S") {
    dir = "Downtown";
  }
  final TextEditingController descriptionController = TextEditingController();

  showMaterialModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "St: ${currTrain.stName}",
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 17.0,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        currTrain.headsign,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 17.0,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "ID: ${currTrain.id}",
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
                      subwayLineIcon(currTrain.line, subbgColor),
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

            // current reports
            const SizedBox(height: 30),
            incidentSummary(context, currTrain),

            // textbox
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: SizedBox(
                height: 60,
                child: TextField(
                  controller: descriptionController,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "Please describe the incident",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // submit button
            ElevatedButton(
              onPressed: () async {
                Report newReport =
                    Report(currTrain.id, descriptionController.text);
                await newReport.addReport();
                currTrain.incidentReports.add(newReport);


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

Widget incidentSummary(BuildContext context, Train selTrain) {
  int reportCnt = selTrain.incidentReports.length;
  if (reportCnt == 0) {
    return Container(
      width: deviceWidth(context) * 0.95,
      height: deviceHeight(context) * 0.25,
      decoration: BoxDecoration(
        color: accentColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: Text(
          "No reports recorded.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25.0,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
  return Container(
    width: deviceWidth(context) * 0.95,
    height: deviceHeight(context) * 0.25,
    decoration: BoxDecoration(
      color: accentColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: PageView.builder(
      itemCount: reportCnt,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.transparent,
          elevation: 0,
          child: incidentCard(selTrain.incidentReports[index]),
        );
      },
    ),
  );
}

Widget incidentCard(Report currReport) {
  return Padding(
    padding: const EdgeInsets.all(15),
    child: Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Time Posted: ${getTime(currReport.postTime)}",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 20),
          Row(
            children: [
              Wrap(
                children: [
                  Text(
                    "Incident Description:\n${currReport.description}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    ),
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
