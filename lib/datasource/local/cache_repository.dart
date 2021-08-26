import 'package:hive/hive.dart';
import 'package:seeds/datasource/local/member_model_cache_item.dart';
import 'package:seeds/datasource/remote/model/vote_model.dart';

// Hive box names

const String _proposalVoteBox = 'proposalVoteBox';
const String _membersBox = 'membersBox';

// Cache Repo
class CacheRepository {
  const CacheRepository();

  bool _boxIsClosed(Box box) => !box.isOpen;

  Future<MemberModelCacheItem?> getMemberCacheItem(String account) async {
    final box = await Hive.openBox<MemberModelCacheItem>(_membersBox);
    if (_boxIsClosed(box)) {
      return null;
    }
    return box.get(account);
  }

  Future<void> saveMemberCacheItem(String account, MemberModelCacheItem memberModelCacheItem) async {
    final box = await Hive.openBox<MemberModelCacheItem>(_membersBox);
    if (_boxIsClosed(box)) {
      return;
    }
    await box.put(account, memberModelCacheItem);
  }

  Future<VoteModel?> getProposalVote(String account, int proposalId) async {
    final box = await Hive.openBox<VoteModel>(_proposalVoteBox);
    if (_boxIsClosed(box)) {
      return null;
    }
    // Vote cache needs to support multiple accounts.
    // The vote cache needs to store what account the vote was for.
    return box.get('${account}_$proposalId');
  }

  Future<void> saveProposalVote(int proposalId, VoteModel voteModel) async {
    final box = await Hive.openBox<VoteModel>(_proposalVoteBox);
    if (_boxIsClosed(box)) {
      return;
    }
    await box.put(proposalId, voteModel);
  }
}
