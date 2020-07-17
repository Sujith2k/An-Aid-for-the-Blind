import speech_recognition as sr 

r = sr.Recognizer()

def ConvertToText(path_to_wav):

    with sr.AudioFile( path_to_wav ) as source:
        audio = r.listen(source)
        try:
            text = r.recognize_google(audio)
            return str(text)
        except Exception as e:
            return "Detection Error"
            print('[Debug] [ERROR] Speech Recognition:',e)