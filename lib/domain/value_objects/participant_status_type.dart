enum ParticipantStatusType {
  pending('pending', 'Menunggu diterima'),
  accepted('accepted', 'Diterima'),
  rejected('rejected', 'ditolak');

  final String jsonValue;
  final String display;
  const ParticipantStatusType(this.jsonValue, this.display);

  static ParticipantStatusType fromJson(String json) {
    return ParticipantStatusType.values.firstWhere(
      (element) => element.jsonValue == json,
      orElse: () => throw Exception('invalid status value: $json'),
    );
  }
}
