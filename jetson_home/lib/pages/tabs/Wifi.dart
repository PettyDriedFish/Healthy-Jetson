import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WifiPage extends StatefulWidget {
  const WifiPage({super.key});

  _WifiPageState createState() => _WifiPageState();
}

class _WifiPageState extends State<WifiPage> {
  final TextEditingController _controller = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://192.168.3.27:8000/websocket'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            const SizedBox(height: 24),
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                return Text(snapshot.hasData ? '${snapshot.data}' : '');
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _channel.sink.add(_controller.text);
    }
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}