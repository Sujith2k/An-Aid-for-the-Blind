
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as Img;
import 'package:http/http.dart' as http;
import 'yolo.dart';

void main() {
  runApp(MaterialApp(
    home:Home(),
  ));
}

urlToImgData(String imageUrl) async {
  http.Response response = await http.get(imageUrl);
  return response.bodyBytes;
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final URLController = TextEditingController();
  String img_url = 'https://static.dezeen.com/uploads/2020/06/priestmangoode-neptune-spaceship-design_dezeen_2364_hero-2-1024x576.jpg';
  Image img ;
  bool ready_flag;

  @override
  void initState() {
    super.initState();
    img = Image(image: NetworkImage(img_url) );
    loadmodel();
  }

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
          img_url = URLController.text;
          print('[DEBUG] Entered URL : $img_url');
          dynamic img_data = urlToImgData(img_url);
          print(img_data);
          predict(img_data);
          img_data
              .then( (data) {
            img = Image.memory(data);
            setState(() {});
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
          img,

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



