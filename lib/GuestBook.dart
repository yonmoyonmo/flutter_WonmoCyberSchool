import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'HexColor.dart';

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
  TextEditingController writerCon = TextEditingController();
  TextEditingController commentCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Query(
        options: QueryOptions(
          documentNode: gql(query),
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
              child: Text("loading"),
            );
          }
          return Scaffold(
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
              backgroundColor: HexColor("#4e7791"),
            ),
            body: _guestbookList(context, size, result),
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
        appBar: AppBar(
          title: Text("일단있어봐"),
        ),
        body: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(hintText: "name"),
              controller: writerCon,
            ),
            TextField(
              decoration: InputDecoration(hintText: "comment"),
              controller: commentCon,
            ),
            RaisedButton(
              child: Text("Submit"),
              onPressed: () {
                insert(<String, dynamic>{
                  "writer": writerCon.text,
                  "text": commentCon.text,
                });
              },
            ),
          ],
        ),
      );
    },
  );
}

Widget _guestbookList(BuildContext context, Size size, QueryResult result) {
  List guestbooks = result.data['allGuestbook'];
  int length = guestbooks.length;
  return ListView.builder(
    itemCount: length,
    itemBuilder: (BuildContext context, int index) {
      String writer = result.data['allGuestbook'][index]['writer'];
      String text = result.data['allGuestbook'][index]['text'];
      String date = result.data['allGuestbook'][index]['date'];
      List<String> splited = date.split("T");
      return Container(
          width: size.width * 0.8,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("글쓴이 : " + writer),
              Text(text),
              Text(splited[0]),
            ],
          ));
    },
  );
}
