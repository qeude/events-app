
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

@immutable
class Event {
  final bool complete;
  final String id;
  final String name;
  final String description;
  final DateTime date;

  Event(this.name, this.date, {this.complete = false, String description='', String id})
    : this.description =description,
      this.id = id ?? Uuid().v4();

  Event copyWith({bool complete, String id, String name, String description, DateTime date}){
    return Event(
        name ?? this.name,
        date ?? this.date,
        description: description ?? this.description,
        complete:complete??this.complete,
        id: id ?? this.id
    );
  }


  @override
  int get hashCode => complete.hashCode ^ name.hashCode ^ date.hashCode ^ description.hashCode ^ complete.hashCode ^ id.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Event &&
          runtimeType == other.runtimeType &&
          complete == other.complete &&
          name == other.name &&
          date == other.date &&
          description == other.description &&
          id == other.id;
}