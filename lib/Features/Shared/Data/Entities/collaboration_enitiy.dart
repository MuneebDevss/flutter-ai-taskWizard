

import 'package:isar/isar.dart';
part 'collaboration_enitiy.g.dart';

@embedded
class Collaboration {
  late bool isShared;
  late List<String> sharedWith;

  Collaboration();
  factory Collaboration.fromMap(Map<String, dynamic> map) {
    return Collaboration()
      ..isShared = map['is_shared']
      ..sharedWith = List<String>.from(map['shared_with']);
  }

  Map<String, dynamic> toMap() => {
    'is_shared': isShared,
    'shared_with': sharedWith,
  };
}
