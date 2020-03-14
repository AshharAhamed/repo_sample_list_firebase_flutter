import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String imageURL, date, comment;
  final int points;
  final DocumentReference reference;


  ReviewModel.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['date'] != null),
        assert(map['comment'] != null),
        assert(map['points'] != null),
        imageURL = map['imageURL'],
        date = map['date'],
        comment = map['comment'],
        points = map['points'];

  ReviewModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
