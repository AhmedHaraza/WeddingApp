import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedding/features/auth/data/profile.dart';

class DataFetchingPhotographersCubit extends Cubit<List<Profile>> {
  DataFetchingPhotographersCubit() : super([]);

  void fetchData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('photographers').get();
      List<Profile> profiles = querySnapshot.docs.map((doc) => Profile.fromFirestore(doc)).toList();
      emit(profiles);
    } catch (e) {
      print(e);
    }
  }

}