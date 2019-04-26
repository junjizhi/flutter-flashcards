import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:transformer_page_view/transformer_page_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter-Flashcard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Programming Questions'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: rootBundle.loadString('lib/assets/questions.csv'), //
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<List<dynamic>> csvTable =
              CsvToListConverter().convert(snapshot.data);
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: new TransformerPageView(
                loop: true,
                viewportFraction: 0.8,
                transformer: new PageTransformerBuilder(
                    builder: (Widget child, TransformInfo info) {
                  return new Padding(
                    padding: new EdgeInsets.all(10.0),
                    child: new Material(
                      elevation: 8.0,
                      textStyle: new TextStyle(color: Colors.white),
                      borderRadius: new BorderRadius.circular(10.0),
                      child: new Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          new Positioned(
                            child: new Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new ParallaxContainer(
                                  child: new Text(
                                    csvTable[info.index + 1][0],
                                    style: new TextStyle(
                                      fontSize: 24.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  position: info.position,
                                  translationFactor: 300.0,
                                ),
                              ],
                            ),
                            left: 10.0,
                            right: 10.0,
                            top: 100.0,
                          )
                        ],
                      ),
                    ),
                  );
                }),
                itemCount: csvTable.length - 1),
          );
        });
  }
}
