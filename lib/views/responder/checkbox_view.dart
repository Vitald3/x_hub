import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_hub/other/constant.dart';
import '../../provider/responder_edit_provider.dart';

class CheckboxView extends StatefulWidget {
  const CheckboxView({super.key, required this.label, required this.value});

  final String label;
  final int value;

  @override
  State<CheckboxView> createState() => _CheckboxViewState();
}

class _CheckboxViewState extends State<CheckboxView> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    final connectors = Provider.of<ResponderEditProvider>(context, listen: false).connectors;

    return GestureDetector(
        onTap: () {
          setState(() {
            checked = !checked;

            if (checked) {
              Provider.of<ResponderEditProvider>(context, listen: false).setConnector(widget.value);
            } else {
              Provider.of<ResponderEditProvider>(context, listen: false).deleteConnector(widget.value);
            }
          });
        },
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: checked || connectors.contains(widget.value) ? primaryColor : const Color(0xFF2c3e50), width: 1),
                  color: checked || connectors.contains(widget.value) ? primaryColor : Colors.white
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: const TextStyle(fontSize: 14, color: Color(0xFF2c3e50)),
            ).tr(),
          ],
        )
    );
  }
}