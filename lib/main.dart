import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:io';
import 'package:network_file_system/components/run_command.dart';
import 'package:network_file_system/pages/client.dart';
import 'package:network_file_system/pages/server.dart';
import 'package:process_run/shell.dart';

void main() {
  // var shell = Shell();
  //
  // shell.run("""
  //     #!/bin/bash
  //     sudo SUDO_ASKPASS=/usr/bin/ssh-askpass sh -A sleep 10 &
  //     """).then((result){
  //   print('Shell script done!');
  // }).catchError((onError) {
  //   print('Shell.run error!');
  //   print(onError);
  // });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NFS',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      // home: const MyHomePage(title: 'Home Page'),
      home: const MyHomePage(),
    );
  }
}

String padString(String str, int len, [bool padLeft=true]) {
  if (str.length > len) {
    return str.substring(0, len);
  }
  else if (padLeft) {
    return (" " * (len - str.length)) + str;
  }
  else {
    return str + (" " * (len - str.length));
  }
}

String emptyReturn(String hmm) {
  return hmm;
}

String filterNetstat(String str) {
  var arrStr = str.split("\n");
  int k = 0;
  while (arrStr[k].trim() != "Tcp:") {
    k += 1;
  }

  String finalString = "";
  for (int i=k+1; i<k+10; i++) {
    List<String> temp = arrStr[i].trim().split(" ");
    String tmp = temp.sublist(1).join(" ");
    finalString += padString(temp[0], 16, false) + " :-  " + tmp[0].toUpperCase() + tmp.substring(1) + "\n";
  }
  return finalString;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size pgSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("NFS"),
        actions: <Widget>[
          TextButton(
              style: TextButton.styleFrom(primary: Colors.green),
              onPressed: () {},
              child: const Text("Login"))
        ],
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                    "Setup NFS:",
                    style: TextStyle(
                        fontSize: 30
                    ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                  ),
                  height: pgSize.height * 0.5,
                  width: pgSize.width * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ServerPage()));
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.amber),
                              foregroundColor: MaterialStateProperty.all(Colors.black),
                              padding: MaterialStateProperty.all(const EdgeInsets.all(40)),
                          ),
                          child: const Text(
                              "For Server",
                            style: TextStyle(fontSize: 20),
                          )
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ClientPage()));
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.amber),
                              foregroundColor: MaterialStateProperty.all(Colors.black),
                              padding: MaterialStateProperty.all(const EdgeInsets.all(40)),
                          ),
                          child: const Text(
                              "For Client",
                            style: TextStyle(fontSize: 20),
                          )
                      )
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Network Monitoring:",
                  style: TextStyle(
                      fontSize: 30
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                  ),
                  height: pgSize.height * 0.5,
                  width: pgSize.width * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      runCommand(context, "Connections Info", "/bin/sh", ['-c', r"netstat -st"], filterNetstat),
                      runCommand(context, "Received and transmitted bytes", "/bin/sh", ['-c', r"netstat -i | tail -n 3 | awk '{print $1,$3,$7}'"], emptyReturn),
                      runCommand(context, "Get Your IP Address", '/bin/sh', ['-c', r"ip route | grep -oP '(?<=src )[^ ]*' | head -n 1"], emptyReturn),
                      // runCommand(context, "Sudo button", '/bin/sh', ['-c', r"SUDO_ASKPASS=/usr/bin/ssh-askpass sudo -A id"], emptyReturn),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
