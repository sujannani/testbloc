import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:textbloc/locations/bloc/locations_bloc.dart';

class Locations extends StatefulWidget {
  const Locations({Key? key}) : super(key: key);

  @override
  State<Locations> createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  final LocationsBloc locationsBloc = LocationsBloc();
  final controller = ScrollController();
  @override
  void initState() {
    locationsBloc.add(LocationsInitialFetchEvent());
    super.initState();
  }

  Future<void> refresh() async{
    locationsBloc.add(LocationsInitialFetchEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LocationsBloc, LocationsState>(
        bloc: locationsBloc,
        listenWhen: (previous, current) => current is LocationsActionState,
        buildWhen: (previous, current) => current is! LocationsActionState,
        listener: (context, state) {},
        builder: (context, state) {
          switch (state.runtimeType) {
            case LocationsFetchSuccessful:
              final successState = state as LocationsFetchSuccessful;
              return Container(
                child: RefreshIndicator(
                  onRefresh: refresh,
                  child: ListView.builder(
                      controller: controller,
                      itemCount: successState.items.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: Card(
                            child: Column(
                              children: [
                                Container(
                                  width: double.maxFinite,
                                  height: 150,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                    image: NetworkImage(
                                        successState.items[index].image),
                                  )),
                                ),
                                Card(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  IconData(0xe3ab,
                                                      fontFamily:
                                                          'MaterialIcons'),
                                                  size: 24.0,
                                                  color: Colors.green,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  successState
                                                      .items[index].startLoc,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  IconData(0xe3ab,
                                                      fontFamily:
                                                          'MaterialIcons'),
                                                  size: 24.0,
                                                  color: Colors.red,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  successState
                                                      .items[index].endLoc,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            locationsBloc.add(
                                                LocationsBookmarkEvent(
                                                    successState.items[index]));
                                          },
                                          child: Icon(
                                            (successState
                                                    .items[index].bookMarked)
                                                ? Icons.favorite
                                                : Icons.favorite_outline,
                                            color: Colors.red,
                                          ),
                                        )
                                      ]),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              );
            default:
              return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.animateTo(
            0.0,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        },
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}
