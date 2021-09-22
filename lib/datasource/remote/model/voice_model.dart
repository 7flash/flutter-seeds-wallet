class VoiceModel {
  final int amount;

  const VoiceModel(this.amount);

  factory VoiceModel.fromJson(Map<String, dynamic> json) {
    if (json['rows'].isNotEmpty) {
      return VoiceModel(json['rows'][0]['balance'] as int);
    } else {
      return const VoiceModel(0);
    }
  }

  factory VoiceModel.fromBalanceJson(Map<String, dynamic> balanceJson) {
    if (balanceJson["rows"].isNotEmpty) {
      return VoiceModel(balanceJson["rows"][0]["voice"] as int);
    } else {
      return const VoiceModel(0);
    }
  }
}
