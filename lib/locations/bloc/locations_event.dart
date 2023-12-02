part of 'locations_bloc.dart';

@immutable
abstract class LocationsEvent {}

class LocationsInitialFetchEvent extends LocationsEvent {}

class LocationsBookmarkEvent extends LocationsEvent {
  final Data item;
  LocationsBookmarkEvent(this.item);
}
