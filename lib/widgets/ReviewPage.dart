import 'package:dynamic_reveiw_app/model/ReviewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'StarDisplay.dart';

class ReviewPage extends StatefulWidget {
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

Stream<QuerySnapshot> getReviewCount() {
  var querySnapshot = Firestore.instance.collection('reviews').snapshots();
  return querySnapshot;
}

//This is used to get the number of reviews from Firebase Storage

Widget _getReviewCount(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: getReviewCount(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Text(
          "${snapshot.data.documents.length} Reviews",
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        );
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    },
  );
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Reviews')),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Reviews',
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.black,
                  fontFamily: 'Arial',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: IconTheme(
                    data: IconThemeData(
                      color: Colors.amber,
                      size: 26,
                    ),
                    child: StarDisplay(value: 3),
                  ),
                ),
              ),
              Container(
                child: _getReviewCount(context),
              )
            ],
          ),
          Divider(
            thickness: 1,
          ),
          Expanded(child: _buildBody(context))
        ],
      ),
    );
  }
}

Widget _buildBody(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance.collection('reviews').snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) return LinearProgressIndicator();

      return _buildList(context, snapshot.data.documents);
    },
  );
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
    children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  final record = ReviewModel.fromSnapshot(data);
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
    child: Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12))),
      child: ListTile(
        title: Row(
          children: <Widget>[
            IconTheme(
              data: IconThemeData(
                color: Colors.amber,
                size: 16,
              ),
              child: StarDisplay(value: record.points),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                record.date,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        leading: /*Column(
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(
                ),
                width: 45.0,
                height: 45.0,
                decoration:
                new BoxDecoration(shape: BoxShape.circle, image: new DecorationImage(image: AssetImage(record.imageURL)))
            ),

          ],
        )*/CircleAvatar(backgroundImage: AssetImage("assets/images/image_10.png") /*NetworkImage(record.imageURL)*/),
        subtitle: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text(
            record.comment.replaceAll("_n", "\n"),
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    ),
  );
}
