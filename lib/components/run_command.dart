import 'dart:io';
import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';

Widget runCommand(context, String btnTitle, String cmd, List<String> args, filter) {
  return TextButton(
    style: TextButton.styleFrom(primary: Colors.green),
    onPressed: () {},
    child: ElevatedButton(
      onPressed: () {
        var results = Process.runSync(cmd, args);
        print(results.stdout.toString());
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              elevation: 16,
              child: Container(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    SizedBox(height: 20),
                    Center(child: Text(btnTitle)),
                    SizedBox(height: 20),
                    _buildRow('assets/choc.png', filter(results.stdout.toString()), 1000),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Text(btnTitle),
    ),
  );
}

Widget _buildRow(String imageAsset, String name, double score) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Column(
      children: <Widget>[
        const SizedBox(height: 12),
        Container(height: 2, color: Colors.green),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            const SizedBox(width: 12),
            Text(
              name,
              style: const TextStyle(fontFamily: "Courier"),
            ),
            const Spacer(),
          ],
        ),
      ],
    ),
  );
}
