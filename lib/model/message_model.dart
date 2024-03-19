import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';


@JsonSerializable()
class Message{
  String from;
  String to;
  String type;
  String content;
  String timeStamp;
  String duration;
  bool? isPlaying;

  Message({
    required this.from,
    required this.to,
    required this.type,
    required this.content,
    required this.timeStamp,
    required this.duration,
    required this.isPlaying,
  });

  factory Message.fromDocument(DocumentSnapshot doc){
    String mFrom = doc.get('from');
    String mTo = doc.get('to');
    String mType = doc.get('type');
    String mContent = doc.get('content');
    String mTimeStamp = doc.get('timeStamp');
    String mDuration = doc.get('duration');
    bool mPlaying = doc.get('isPlaying');

    return Message(
        from: mFrom,
        to: mTo,
        type: mType,
        content: mContent,
        timeStamp: mTimeStamp,
        duration: mDuration,
        isPlaying: mPlaying,
    );
  }

  Map<String, dynamic> toJson(){
    var map = <String, dynamic>{};
    map['from'] = from;
    map['to'] = to;
    map['content'] = content;
    map['type'] = type;
    map['timeStamp'] = timeStamp;
    map['duration'] = duration;
    map['isPlaying'] = isPlaying;
    return map;
  }
}