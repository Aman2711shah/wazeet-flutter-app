class FreezoneCost {
  final String freezoneName;
  final String licenseType; // Commercial/Professional/Industrial
  final int noOfActivity;   // 1..10
  final num cost;           // AED

  FreezoneCost({
    required this.freezoneName,
    required this.licenseType,
    required this.noOfActivity,
    required this.cost,
  });

  factory FreezoneCost.fromJson(Map<String, dynamic> j) => FreezoneCost(
        freezoneName: j['freezone_name'] as String,
        licenseType: j['license_type'] as String,
        noOfActivity: j['no_of_activity'] as int,
        cost: j['cost'] as num,
      );
}
