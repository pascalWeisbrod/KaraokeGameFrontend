import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MenuWidget extends StatefulWidget {
  final List<String> items = ["Cat", "Dog"];

  MenuWidget({super.key});

  @override
  State<StatefulWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<List<String>> fetchData() async {
    final response = await http.get(Uri.parse('localhost:8080/db'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['Data'];
      return data.map((el) => el['Name'].toString()).toList();
    }
    return ["you fcked it"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Fetch Data Example')),
      body: Column(
        children: [
          Text("Let's try"),
          SizedBox(
            height: 400,
            child: FutureBuilder(
              future: fetchData(),
              builder: (
                BuildContext buildcontext,
                AsyncSnapshot<List<String>> snapshot,
              ) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Text(snapshot.data![index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
