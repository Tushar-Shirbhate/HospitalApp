import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_call_5/video_call_screen.dart';

class VideoWidget extends StatefulWidget {
  const VideoWidget({Key? key}) : super(key: key);

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => VideoCallScreen()));

          },
          child: Container(
            width: 100,
            height: 45,
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(CupertinoIcons.video_camera_solid, color: Colors.white,size: 40,),
                Text('Call',
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white
                  ),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
