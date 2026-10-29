enum UserRole {
  user,
  artist,
  admin,
}

class User {
  final String id;
  final String name;
  final String email;
  final String password;

  UserRole role;

  bool hasCompletedCourse;
  bool artistApplicationPending;
  bool artistApplicationRejected;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.role = UserRole.user,
    this.hasCompletedCourse = false,
    this.artistApplicationPending = false,
    this.artistApplicationRejected = false,
  });

  bool get canApplyAsArtist {
    return hasCompletedCourse &&
        role == UserRole.user &&
        !artistApplicationPending;
  }

  bool get isArtist {
    return role == UserRole.artist;
  }

  bool get isAdmin {
    return role == UserRole.admin;
  }
}