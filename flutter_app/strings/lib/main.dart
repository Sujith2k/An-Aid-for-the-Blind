import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home:Home(),
  ));
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final URLController = TextEditingController();
  String img_url = 'https://static.dezeen.com/uploads/2020/06/priestmangoode-neptune-spaceship-design_dezeen_2364_hero-2-1024x576.jpg';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text('Primary Model'),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
      ),

    // REFRESH Button
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        setState(() {
          img_url = URLController.text;
          print('[DEBUG] Entered URL : $img_url');
        });
      },
      child: Icon(Icons.refresh),
      backgroundColor: Colors.red,
    ),

    body: Padding(
      padding: EdgeInsets.all(10),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // URL INPUT BOX
          TextField(
            controller: URLController,
            autofocus: false,

            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: img_url,
            ),
          ),

          SizedBox(height: 20),

          //DISPLAY IMAGE
          Image(
            image: NetworkImage(img_url),
          ),
          SizedBox(height: 10),
          Text(
            'Results: ',
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 2,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    ),
    );
  }
}



