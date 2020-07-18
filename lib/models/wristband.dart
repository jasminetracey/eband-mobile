class Wristband {
  bool activated;
  int credits;
  String address;
  String phoneNumber;

  Wristband({
    this.activated = false,
    this.credits = 0,
    this.address,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'activated': activated,
      'credits': credits,
      'address': address,
      'phoneNumber': phoneNumber,
    };
  }
}
