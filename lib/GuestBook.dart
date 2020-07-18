import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
//import 'HexColor.dart';

class GuestBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink =
        HttpLink(uri: "https://wonmocyberschool.com/graphqlapi/");
    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(link: httpLink, cache: InMemoryCache()),
    );
    return GraphQLProvider(
      child: CacheProvider(
        child: GuestBookPage(),
      ),
      client: client,
    );
  }
}

class GuestBookPage extends StatefulWidget {
  @override
  _GuestBookPageState createState() => _GuestBookPageState();
}

class _GuestBookPageState extends State<GuestBookPage> {
  final String gbm = r"""
mutation createGuestBook($writer: String!, $text: String!) {
  createGuestbook(input: {writer:$writer, text:$text}) {
    guestbook {
      id
      writer
      text
      date
    }
  }
}
  """;
  final String query = r"""
  query{
  allGuestbook{
    writer
    text
    date
  }
}
  """;
  TextEditingController writerCon;
  TextEditingController commentCon;
  void initState() {
    super.initState();
    writerCon = TextEditingController();
    commentCon = TextEditingController();
  }

  void dispose() {
    writerCon.dispose();
    commentCon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Query(
        options: QueryOptions(
          documentNode: gql(query),
          pollInterval: 10,
        ),
        builder: (QueryResult result,
            {VoidCallback refetch, FetchMore fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }
          if (result.loading) {
            return Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: Container(
                  width: 300,
                  height: 300,
                  child: Image(
                    image: AssetImage("assets/gb.png"),
                  )),
            );
          }
          return Container(
            child: Scaffold(
              appBar: AppBar(
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.add),
                    tooltip: "Write Guest Book",
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => _guestbookAdd(
                              context, size, gbm, writerCon, commentCon)));
                    },
                  ),
                ],
                title: Text("Guest Book"),
                elevation: 0,
                backgroundColor: Theme.of(context).primaryColor,
              ),
              body: _guestbookList(context, size, result),
            ),
          );
        },
      ),
    );
  }
}

Widget _guestbookAdd(BuildContext context, Size size, String gbm,
    TextEditingController writerCon, TextEditingController commentCon) {
  final HttpLink httpLink =
      HttpLink(uri: "https://wonmocyberschool.com/graphqlapi/");
  final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
    GraphQLClient(link: httpLink, cache: InMemoryCache()),
  );
  return GraphQLProvider(
    child: CacheProvider(
      child: _guestbookwrite(context, size, gbm, writerCon, commentCon),
    ),
    client: client,
  );
}

Widget _guestbookwrite(BuildContext context, Size size, String gbm,
    TextEditingController writerCon, TextEditingController commentCon) {
  return Mutation(
    options: MutationOptions(
        documentNode: gql(gbm),
        onCompleted: (result) {
          Navigator.of(context).pop();
        }),
    builder: (RunMutation insert, QueryResult result) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("Writing Guest Book"),
        ),
        body: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: "name( Limit : 20 )",
                  border: OutlineInputBorder(),
                ),
                controller: writerCon,
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: "comment( Limit : 100 )",
                  border: OutlineInputBorder(),
                ),
                controller: commentCon,
              ),
              SizedBox(
                height: 25,
              ),
              RaisedButton(
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                child: Text("S U B M I T"),
                onPressed: () {
                  String writer = writerCon.text;
                  String text = commentCon.text;
                  if (writer.length >= 20) {
                    writer = writer.substring(0, 19);
                  }
                  if (text.length >= 20) {
                    text = text.substring(0, 99);
                  }
                  insert(<String, dynamic>{"writer": writer, "text": text});
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _guestbookList(BuildContext context, Size size, QueryResult result) {
  List guestbooks = result.data['allGuestbook'];
  int length = guestbooks.length;
  return Container(
    color: Theme.of(context).primaryColor,
    child: ListView.builder(
      itemCount: length,
      itemBuilder: (BuildContext context, int index) {
        String writer = result.data['allGuestbook'][index]['writer'];
        String text = result.data['allGuestbook'][index]['text'];
        String date = result.data['allGuestbook'][index]['date'];
        List<String> splited = date.split("T");
        return Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(),
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            width: size.width,
            height: 190,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  width: size.width,
                  child: Text(writer),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(text),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.bottomRight,
                  child: Text(splited[0]),
                ),
              ],
            ));
      },
    ),
  );
}
