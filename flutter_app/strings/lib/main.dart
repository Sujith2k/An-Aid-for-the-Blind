
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;


import 'yolo.dart';
import 'Text2Speech.dart';
import 'Speech2text.dart';


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
  var objects = new List();
  String words1;

  @override
  void initState() {
    super.initState();
    img = Image(image: NetworkImage(img_url) );
    loadmodel();
    initialize_stt();
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
      onPressed: () async{

        img_url = URLController.text;
        print('[DEBUG] Entered URL : $img_url');
        dynamic img_data = urlToImgData(img_url);
        img_data.then((data) {
          img = Image.memory(data);
        });

        isListening = true;
        dynamic words = await StartListening();
        print('[DEBUG] Recived from Start : $words');

        await Future.delayed(Duration(seconds: 4));
        // YOLO
        if( words.contains('detect')){

          print('[DEBUG] Entered YOLO');

            dynamic results = await yoloTiny(img_data);
            objects = new List();

              for( int i =0 ; i < results.length ; i++) {
                objects.add(results[i]['detectedClass']);
              }
              print('[DEBUG] Objects: $objects');
              ReadOut('Detected:' + objects.toString());
        }
        Future.delayed(Duration(seconds: 2), () => setState(() {}));
        speech.stop();
      },


      child: Icon(Icons.mic),
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



