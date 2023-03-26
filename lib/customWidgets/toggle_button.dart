import 'package:flutter/material.dart';
import 'package:safe_line/constants.dart';

// ignore: must_be_immutable
class SubwayButton extends StatefulWidget {
  final String buttonText;
  final Color buttonColor;
  final Border selected = Border.all(color: accentColor, width: 3);
  final Border unselected = Border.all(color: slBgColor, width: 3);

  bool state;
  Border currentBorder = Border.all(color: slBgColor, width: 3);

  SubwayButton({
    super.key,
    required this.buttonText,
    required this.buttonColor,
    required this.state,
  });

  @override
  State<SubwayButton> createState() => _SubwayButtonState();
}

class _SubwayButtonState extends State<SubwayButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: GestureDetector(
        onTap: () {
          if (widget.state) {
            widget.state = false;
          } else {
            widget.state = true;
          }
          setState(() {
            if (widget.state) {
              widget.currentBorder = widget.selected;
            } else {
              widget.currentBorder = widget.unselected;
            }
          });
        },
        child: SizedBox(
          width: 45,
          height: 45,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.buttonColor,
              border: widget.currentBorder,
            ),
            child: Text(
              widget.buttonText,
              // overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15.0,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
