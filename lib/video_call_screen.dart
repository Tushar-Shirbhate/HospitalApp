import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:agora_uikit/agora_uikit.dart';
class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({Key? key}) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final AgoraClient _client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: 'c146f08d7f7e48e7bdaa230ac18b1d4e',
        channelName: 'video_call_3',
        tempToken:
        '007eJxTYGi++uaBsZBpG3Ox0Y3reYyBnfMWSVp7/3l9PcRyveKyfDkFhmRDE7M0A4sU8zTzVBOLVPOklMREI2ODxGRDiyTDFJPUpvmLUhoCGRnc1RoZGRkgEMTnYSjLTEnNj09OzMmJN2ZgAAA4hiHr',
      ));

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  Future<void> _initAgora() async {
    await _client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Video Call'),
            backgroundColor: Color(0xff8f94fb),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                AgoraVideoViewer(
                  client: _client,
                  layoutType: Layout.oneToOne,
                  showNumberOfUsers: true,
                ),
                AgoraVideoButtons(
                  client: _client,
                  enabledButtons: const [
                    BuiltInButtons.toggleCamera,
                    BuiltInButtons.switchCamera,
                    BuiltInButtons.callEnd,
                    BuiltInButtons.toggleMic,
                  ],
                )
              ],
            ),
          )),
    );
  }
}
