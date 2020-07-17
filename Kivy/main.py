from kivy.app import App
from kivy.uix.gridlayout import GridLayout
from kivy.uix.button import Button
from kivy.uix.image import Image , AsyncImage
from kivy.uix.textinput import TextInput
from kivy.uix.label import Label
from jnius import autoclass
from plyer import tts
from kivy.clock import Clock


import cv2
import numpy as np
import certifi
import os

import speechTotxt
import Detection 

from android.permissions import request_permissions, Permission

os.environ['SSL_CERT_FILE'] = certifi.where()

PATH = "/sdcard/rec_test.wav"

class FirstLayout(GridLayout):

    def __init__(self,**kwargs):
        super().__init__(**kwargs)
        self.cols = 1

        #Add URL Text Input box widget 
        self.url_txt_input = TextInput( text = "https://image.shutterstock.com/image-vector/flag-hi-there-old-school-260nw-1538367731.jpg")
        self.url_txt_input.height = '48dp'
        self.url_txt_input.size_hint_y = None
        self.add_widget( self.url_txt_input )


        #Adding Image Widget
        self.img = DispImg( url = self.url_txt_input.text)
        self.add_widget( self.img )   

        # Adding Result Label Widget
        self.result_label = Label( text = "Result:" , height = '48dp', size_hint_y = None )
        self.add_widget( self.result_label ) 

        # Adding Button Widget
        self.record_button = Button(text = "Press and Hold to speak" ,height = '48dp', size_hint_y = None )
        self.record_button.background_color = [0, 1, 0, 1]   # Green Color
        self.record_button.bind(on_press = self.ButtonPressed)
        self.record_button.bind(on_release = self.ButtonReleased)
        self.add_widget( self.record_button )     


    # When Button is pressed
    def ButtonPressed(self,instance):
        print("[Debug] : Button Pressed")
        self.record_button.text = "Release to Process"
        self.record_button.background_color = [1, 0, 0, 1]      # Red Color

        Clock.schedule_once(self.StartRecording)
        #self.img.update(self.url_txt_input.text)
        

    #When button is released
    def ButtonReleased(self,instance):
        print("[Debug] : Button Released")
        self.record_button.text = "Press and Hold to speak"
        self.record_button.background_color = [0, 1, 0, 1]      #Green Color

        self.StopRecording()
        self.result_label.text = "Processing..."
        self.data_from_audio = speechTotxt.ConvertToText('/sdcard/rec_test.wav')

        print("[DEBUG]:",self.data_from_audio)

        if( True ):                                              #'object' in self.data_from_audio 
            # Update Image Data
            self.url_txt_input.text = "http://192.168.43.7/jpg"
            self.img.update("http://192.168.43.7/jpg")

            # Perform Genral Scan with Yolo Model
            height, width = self.img.texture.height, self.img.texture.width

            img_data = np.frombuffer(self.img.texture.pixels, np.uint8)
            img_data = img_data.reshape(height, width, 4)
        
            res = str(Detection.ret_classes(img_data))
            self.result_label.text = "Result" + res
        
        # If no Useful Data from Voice
        else:
            self.result_label.text = "Try Again !"



    def StartRecording(self,dt):
        self.r = MyRecorder()
        self.r.mRecorder.start()

    def StopRecording(self):
   
        self.r.mRecorder.stop()
        self.r.mRecorder.release() 
        Clock.unschedule(self.StartRecording)



class MyRecorder:
    def __init__(self):
        '''Recorder object To access Android Hardware'''
        self.MediaRecorder = autoclass('android.media.MediaRecorder')
        self.AudioSource = autoclass('android.media.MediaRecorder$AudioSource')
        self.OutputFormat = autoclass('android.media.MediaRecorder$OutputFormat')
        self.AudioEncoder = autoclass('android.media.MediaRecorder$AudioEncoder')
 
        # create out recorder
        self.mRecorder = self.MediaRecorder()
        self.mRecorder.setAudioSource(self.AudioSource.MIC)
        self.mRecorder.setOutputFormat(self.OutputFormat.MPEG_4)
        self.mRecorder.setOutputFile('/sdcard/MYAUDIO.mp4')
        self.mRecorder.setAudioEncoder(self.AudioEncoder.HE_AAC)
        self.mRecorder.prepare()



class DispImg(AsyncImage):
    def __init__(self, url , **kwargs):
        super().__init__(**kwargs)
        self.url = url
        self.update( self.url )

    def update(self, url ):
        self.source = url
        self.reload()   



# Layout to Display Error Message
class ErrorLayout(GridLayout):
    def __init__(self,e,**kwargs):
        super().__init__(**kwargs)

        self.cols = 1
        self.add_widget( Label( text = str(e) ))



class StringsApp(App):
    def build(self):
        
        request_permissions([Permission.RECORD_AUDIO])
        request_permissions([Permission.READ_EXTERNAL_STORAGE, Permission.WRITE_EXTERNAL_STORAGE])

        try:
            return FirstLayout()
        except Exception as e:
            return ErrorLayout(e)



if __name__ == '__main__':
    StringsApp().run()
