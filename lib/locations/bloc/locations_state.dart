part of 'locations_bloc.dart';

@immutable
abstract class LocationsState {}

abstract class LocationsActionState extends LocationsState {}

class LocationsInitial extends LocationsState {}

class LocationsFetchSuccessful extends LocationsState {
  final List<Data> items;

  LocationsFetchSuccessful(this.items);
}

class LocationBookmarkChanged extends LocationsActionState {}
