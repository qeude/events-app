import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

@immutable
class Event {
  final bool complete;
  final String id;
  final Uint8List image;
  final String name;
  final String description;
  final DateTime date;

  Event(this.name, this.date, this.image, {this.complete = false, String description='', String id})
    : this.description =description,
      this.id = id ?? Uuid().v4();

  Event copyWith({bool complete, String id, String name,String image, String description, DateTime date}){
    return Event(
        name ?? this.name,
        date ?? this.date,
        image ?? this.image,
        description: description ?? this.description,
        complete:complete??this.complete,
        id: id ?? this.id
    );
  }

  factory Event.fromDatabaseJson(Map<String, dynamic> data) => Event(
      data['name'],
      DateTime.parse(data['date']),
      base64.decode(data['image']),
      id:data['id'], 
      description: data['description'],
      complete: data['complete'] == 0 ? false : true,
  );

  Map<String, dynamic> toDatabaseJson() => {
    "id": this.id,
    "name":this.name,
    "image": base64.encode(this.image),
    "description": this.description,
    "date":this.date.toString(), 
    "complete": this.complete ==false ? 0 : 1,
  };
  @override
  int get hashCode => complete.hashCode ^ name.hashCode ^ date.hashCode ^ image.hashCode ^ description.hashCode ^ complete.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Event &&
          runtimeType == other.runtimeType &&
          complete == other.complete &&
          name == other.name &&
          image == other.image &&
          date == other.date &&
          description == other.description &&
          id == other.id;
}