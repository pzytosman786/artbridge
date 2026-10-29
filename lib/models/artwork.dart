enum ArtworkStatus {
  pending,
  approved,
  rejected,
}

class Artwork {
  final String id;
  final String artistId;
  final String artistName;
  final String title;
  final String description;
  final double price;
  final String category;
  final String image;

  ArtworkStatus status;

  Artwork({
    required this.id,
    required this.artistId,
    required this.artistName,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.image,
    this.status = ArtworkStatus.approved,
  });

  // ============================================================
  // FROM FIRESTORE
  // ============================================================

  factory Artwork.fromFirestore(
    String documentId,
    Map<String, dynamic> data,
  ) {
    final statusString =
        data['status']?.toString() ?? 'approved';

    ArtworkStatus artworkStatus;

    switch (statusString) {
      case 'pending':
        artworkStatus = ArtworkStatus.pending;
        break;

      case 'rejected':
        artworkStatus = ArtworkStatus.rejected;
        break;

      case 'approved':
      default:
        artworkStatus = ArtworkStatus.approved;
        break;
    }

    return Artwork(
      id: documentId,
      artistId: data['artistId']?.toString() ?? '',
      artistName:
          data['artistName']?.toString() ?? 'ArtBridge Artist',
      title: data['title']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      price: _toDouble(data['price']),
      category: data['category']?.toString() ?? '',
      image: data['image']?.toString() ?? '',
      status: artworkStatus,
    );
  }

  // ============================================================
  // TO FIRESTORE
  // ============================================================

  Map<String, dynamic> toFirestore() {
    return {
      'artistId': artistId,
      'artistName': artistName,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'image': image,
      'status': status.name,
    };
  }

  // ============================================================
  // HELPER - CONVERT NUMBER TO DOUBLE
  // ============================================================

  static double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0.0;
  }
}