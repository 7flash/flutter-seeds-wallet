import 'package:hive/hive.dart';

const String proposalVotesCacheBox = 'proposalVotesBox';
const String membersCacheBox = 'membersBox';

String buildVoteKey(String account, int proposalId) => '${account}_$proposalId';

class CacheRepository<T> {
  final Box _box;

  const CacheRepository(Box box) : _box = box;

  bool get boxIsClosed => !_box.isOpen;

  T? get(dynamic id) {
    if (boxIsClosed) {
      return null;
    }
    return _box.get(id);
  }

  Future<void> add(dynamic id, T object) async {
    if (boxIsClosed) {
      return;
    }
    await _box.put(id, object);
  }
}
