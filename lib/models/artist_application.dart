enum ApplicationStatus {
  pending,
  approved,
  rejected,
}

class ArtistApplication {
  final String id;
  final String userId;
  final String bio;
  final String specialization;
  final String portfolio;
  ApplicationStatus status;

  ArtistApplication({
    required this.id,
    required this.userId,
    required this.bio,
    required this.specialization,
    required this.portfolio,
    this.status = ApplicationStatus.pending,
  });

  // ============================================================
  // CONVERT FIRESTORE DATA TO ARTIST APPLICATION
  // ============================================================

  factory ArtistApplication.fromFirestore(
    String documentId,
    Map<String, dynamic> data,
  ) {
    final statusString =
        data['status']?.toString() ?? 'pending';

    ApplicationStatus applicationStatus;

    switch (statusString) {
      case 'approved':
        applicationStatus = ApplicationStatus.approved;
        break;

      case 'rejected':
        applicationStatus = ApplicationStatus.rejected;
        break;

      default:
        applicationStatus = ApplicationStatus.pending;
    }

    return ArtistApplication(
      id: documentId,
      userId: data['userId']?.toString() ?? '',
      bio: data['bio']?.toString() ?? '',
      specialization:
          data['specialization']?.toString() ?? '',
      portfolio: data['portfolio']?.toString() ?? '',
      status: applicationStatus,
    );
  }

  // ============================================================
  // CONVERT ARTIST APPLICATION TO FIRESTORE DATA
  // ============================================================

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'bio': bio,
      'specialization': specialization,
      'portfolio': portfolio,
      'status': status.name,
    };
  }
}