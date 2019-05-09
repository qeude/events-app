import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

@immutable
class Event {
  final String id;
  final String image;
  final String name;
  final String description;
  final DateTime date;
  final bool hasLocation;
  
  Event(this.name, this.date, this.image, {String description='', String id, bool hasLocation = false})
    : this.description =description,
      this.id = id ?? Uuid().v4(),
      this.hasLocation = hasLocation;

  Event copyWith({String id, String name,String image, String description, DateTime date, bool hasLocation}){
    return Event(
        name ?? this.name,
        date ?? this.date,
        image ?? this.image,
        description: description ?? this.description,
        id: id ?? this.id,
        hasLocation: hasLocation ?? this.hasLocation
    );
  }

  factory Event.fromDatabaseJson(Map<String, dynamic> data) => Event(
      data['name'],
      DateTime.parse(data['date']),
      data['image'],
      id:data['id'], 
      description: data['description'],
      hasLocation: data['haslocation'] == 0 ? false: true
  );

  Map<String, dynamic> toDatabaseJson() => {
    "id": this.id,
    "name":this.name,
    "image": this.image,
    "description": this.description,
    "date":this.date.toString(), 
    "haslocation": this.hasLocation == false ? 0 : 1
  };
  @override
  int get hashCode =>  name.hashCode ^ date.hashCode ^ image.hashCode ^ hasLocation.hashCode ^description.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Event &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          image == other.image &&
          date == other.date &&
          description == other.description &&
          hasLocation == other.hasLocation &&
          id == other.id;
}