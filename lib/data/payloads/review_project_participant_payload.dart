class ReviewProjectParticipantPayload {
  final String projectId;
  final String participantId;
  final double rating;
  final String review;
  const ReviewProjectParticipantPayload({
    required this.projectId,
    required this.participantId,
    required this.rating,
    required this.review,
  });

  Map<String, dynamic> toJson() {
    return {'rating': rating, 'review': review};
  }
}
