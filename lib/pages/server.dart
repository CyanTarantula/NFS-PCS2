import 'package:flutter/material.dart';
import 'package:network_file_system/components/run_command.dart';
import 'dart:io';

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
  String finalString = "";
  for (int i=4; i<13; i++) {
    List<String> temp = arrStr[i].trim().split(" ");
    String tmp = temp.sublist(1).join(" ");
    finalString += padString(temp[0], 16, false) + " :-  " + tmp[0].toUpperCase() + tmp.substring(1) + "\n";
  }
  return finalString;
}

class ServerPage extends StatefulWidget {
  const ServerPage({Key? key}) : super(key: key);

  @override
  State<ServerPage> createState() => _ServerPageState();
}

class _ServerPageState extends State<ServerPage> {
  final clientIP = TextEditingController();
  final serverSharePath = TextEditingController();
  String fldrContents = "";

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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        height: pgSize.height * 0.3,
                        width: pgSize.width * 0.3,
                        child: Column(
                          children: [
                            const Text(
                                "For Server:",
                                style: TextStyle(fontSize: 26),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: TextField(
                                controller: clientIP,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Enter Client IP"
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: TextField(
                                controller: serverSharePath,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Enter Absolute Path of folder to be shared"
                                ),
                              ),
                            ),
                            // Container(
                            //   margin: const EdgeInsets.all(10),
                            //   child: const TextField(
                            //     obscureText: true,
                            //     decoration: InputDecoration(
                            //         border: OutlineInputBorder(),
                            //         labelText: "Enter your Linux Password"
                            //     ),
                            //   ),
                            // ),
                            // runCommand(context, "Connect to Server", "/bin/sh", ['-c', r'SUDO_ASKPASS=/usr/bin/ssh-askpass sudo -A apt update'], emptyReturn),
                            TextButton(
                                style: TextButton.styleFrom(backgroundColor: Colors.amber, primary: Colors.black),
                                onPressed: () {
                                  setState(() {
                                    fldrContents = serverSharePath.text;
                                  });
                                  String client_ip_addr = clientIP.text;
                                  String servershare_fldr = serverSharePath.text;

                                  String cmd = "SUDO_ASKPASS=/usr/bin/ssh-askpass sudo -A mkdir -p " + servershare_fldr +
                                      "; sudo chown -R nobody:nogroup " + servershare_fldr +
                                      "; sudo chmod 777 " + servershare_fldr + "; " +
                                      "echo '" + servershare_fldr + " " + client_ip_addr + "(rw,sync,no_subtree_check)' | sudo tee -a /etc/exports; " +
                                      "sudo exportfs -a; sudo systemctl restart nfs-kernel-server; " +
                                      "sudo ufw allow from " + client_ip_addr + " to any port nfs; sudo ufw enable; sudo ufw status;";
                                  // var res = Process.runSync("/bin/sh", ["-c", r'SUDO_ASKPASS=/usr/bin/ssh-askpass sudo -A id']);
                                  var res = Process.runSync("/bin/sh", ['-c', cmd]);
                                  print(res.stdout.toString());
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => const MyHomePage()
                                  //     )
                                  // );
                                },
                                child: const Text(
                                  "Share with client",
                                  style: TextStyle(
                                      fontSize: 18
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                    "Folder contents:",
                  style: TextStyle(fontSize: 20),
                ),
                Text(Process.runSync("ls", [fldrContents.toString()]).stdout.toString()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
