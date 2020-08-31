import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:math';
import 'main.dart';


stt.SpeechToText speech = stt.SpeechToText();
bool isListening = false;
dynamic words;
double minSoundLevel = -50000,maxSoundLevel = 50000;

initialize_stt() async{
  print('[DEBUG] Initialized STT');
  bool hasSpeech = await speech.initialize(
      onStatus: (val) => print('STT onStatus: $val'),
      onError: (val) => print('STT onError : $val'),
    );
}


StartListening() {

  speech.listen(
    onResult: resultListener,
    listenFor: Duration(seconds: 10),
    localeId: "en_IN",
    onSoundLevelChange: soundLevelListener,
    cancelOnError: true,
    partialResults: false,
    onDevice: true,
    listenMode: stt.ListenMode.confirmation
  );
  //speech.stop();
  /*Future.delayed(Duration(microseconds: 200), () => isListening = false);
  print('[DEBUG] Returning: $words');*/
  //return words;
}

resultListener(SpeechRecognitionResult result){
  if(result.finalResult)
    words = result.recognizedWords;
    print('[DEBUG] Words in Speech: $words');
    return words;
}

soundLevelListener(double level){
  minSoundLevel = min(minSoundLevel,level);
  maxSoundLevel = max(maxSoundLevel,level);

}
