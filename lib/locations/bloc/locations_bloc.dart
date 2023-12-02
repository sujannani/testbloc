import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:textbloc/locations/repos/locationsRepo.dart';

import '../model/dataModel.dart';

part 'locations_event.dart';
part 'locations_state.dart';

class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  LocationsBloc() : super(LocationsInitial()) {
    on<LocationsInitialFetchEvent>(locationsInitialFetchEvent);
    on<LocationsBookmarkEvent>(locationsBookmarkEvent);
  }

  FutureOr<void> locationsInitialFetchEvent(
      LocationsInitialFetchEvent event, Emitter<LocationsState> emit) async {
    List<Data> items = await LocationsRepo.fetchLocations();
    emit(LocationsFetchSuccessful(items));
  }

  FutureOr<void> locationsBookmarkEvent(
      LocationsBookmarkEvent event, Emitter<LocationsState> emit) async {
    print("Hello");
    print(event.item);
    await LocationsRepo.changeBookmark(event.item);
    emit(LocationBookmarkChanged());
  }
}
