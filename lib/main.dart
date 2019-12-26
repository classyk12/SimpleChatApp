import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(FriendlyChatApp());

class FriendlyChatApp extends StatelessWidget {
  //define classes to create native themes of feel and look
  final ThemeData kIOSTheme = new ThemeData(
    primarySwatch: Colors.orange,
    primaryColor: Colors.grey[100],
    primaryColorBrightness: Brightness.light,
  );
  final ThemeData kDefaultTheme = new ThemeData(
    primarySwatch: Colors.purple,
    accentColor: Colors.orangeAccent[400],
  );

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Friendlychat',
      home: ChatScreen(),
      theme: debugDefaultTargetPlatformOverride == TargetPlatform.iOS
          ? kIOSTheme
          : kDefaultTheme,
    );
  }
}

//use this to create a stateful widget
class ChatScreen extends StatefulWidget {
  State createState() => new ChatScreenState();
}

//use this to manage the state for the stateful widget
class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  //create a text controller object to read input value and clear text input
  TextEditingController _controller = new TextEditingController();
  //use this to create a list of chat message and initialize it to an empty array
  final List<ChatMessage> _messages = <ChatMessage>[];
  bool _isComposing = false;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Friendlychat"),
          elevation:
              Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        ),
        //create a column to hold the listview
        body: new Column(
          children: <Widget>[
            new Flexible(
              child: new ListView.builder(
                padding: EdgeInsets.all(8.0),
                reverse: true, //use this to create infinite loading
                itemBuilder: (_, int index) => _messages[index],
                itemCount: _messages.length,
              ),
            ),
            new Divider(
              height: 1.0,
            ),
            new Container(
              decoration: new BoxDecoration(color: Theme.of(context).cardColor),
              child: buildTextComposer(),
            )
          ],
        ));
  }

  //use this to create the chat input field which is of type widget:
  //every UI element in flutter is a widget
  Widget buildTextComposer() {
    return new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                controller: _controller,
                onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                icon: Icon(Icons.send),
                //:: makes the avtion on the send button null if _isComposing is false
                onPressed: _isComposing
                    ? () => _handleSubmitted(_controller.text)
                    : null,
                color: Colors.blue,
              ),
            )
          ],
        ));
  }

  //use this to handle submitted method
  void _handleSubmitted(String text) {
    _controller.clear();
    setState(() {
      _isComposing = false;
    });
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
          vsync: this, duration: new Duration(milliseconds: 700)),
    );
    setState(() {
      //insert the chat message instance into the bottom of the array
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  //use this to dispose the animation when not in use
  @override
  void dispose() {
    for (ChatMessage _chatmessage in _messages) {
      _chatmessage.animationController.dispose();
      super.dispose();
    }
  }
}

//use this to create the widget displayed when user sends a message
class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    const String _name = 'Faith';
    return new SizeTransition(
        sizeFactor: new CurvedAnimation(
            parent: animationController, curve: Curves.easeOut),
        axisAlignment: 0.0,
        child: new Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: new CircleAvatar(
                  //pick only the character at index 0 from the text
                  child: new Text(_name[0]),
                ),
              ),
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //this one takes the style of the context theme and places it in the head of the other widget
                    new Text(_name, style: Theme.of(context).textTheme.subhead),
                    new Container(
                      margin: EdgeInsets.only(top: 5.0),
                      child: new Text(text),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
