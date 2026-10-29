import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart'
    hide Order;

import '../models/user.dart';
import '../models/course.dart';
import '../models/enrollment.dart';
import '../models/artist_application.dart';
import '../models/artwork.dart';
import '../models/order.dart';

class AppState extends ChangeNotifier {
  // ============================================================
  // FIREBASE
  // ============================================================

  final firebase_auth.FirebaseAuth _auth =
      firebase_auth.FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  // ============================================================
  // USERS
  // ============================================================

  final List<User> users = [];

  User? currentUser;

  // ============================================================
  // COURSES
  // ============================================================

  final List<Course> courses = [
  // ============================================================
  // ART BOOKS
  // ============================================================

  Course(
    id: 'course_001',
    title: 'Abstract Art',
    description:
        'Explore colors, shapes, textures and creative expression through abstract art.',
    price: 15,
    type: CourseType.pdf,
    instructor: 'ArtBridge',
    duration: 'Art Book',
    image: 'assets/images/courses/abstract_art.jpg',
  ),

  Course(
    id: 'course_002',
    title: 'Henna Art',
    description:
        'Learn beautiful henna patterns, techniques and traditional decorative designs.',
    price: 15,
    type: CourseType.pdf,
    instructor: 'ArtBridge',
    duration: 'Art Book',
    image: 'assets/images/courses/henna_art.jpg',
  ),

  Course(
    id: 'course_003',
    title: 'Calligraphy Art',
    description:
        'Learn the fundamentals of artistic lettering and create beautiful calligraphy designs.',
    price: 15,
    type: CourseType.pdf,
    instructor: 'ArtBridge',
    duration: 'Art Book',
    image: 'assets/images/courses/calligraphy_art.jpg',
  ),

  Course(
    id: 'course_004',
    title: 'Pencil & Monochromatic Art',
    description:
        'Develop pencil drawing, shading, contrast and monochromatic artwork techniques.',
    price: 15,
    type: CourseType.pdf,
    instructor: 'ArtBridge',
    duration: 'Art Book',
    image: 'assets/images/courses/pencil_monochromatic_art.jpg',
  ),

  Course(
    id: 'course_005',
    title: 'Watercolor Art',
    description:
        'Learn watercolor techniques including blending, layering, composition and color.',
    price: 15,
    type: CourseType.pdf,
    instructor: 'ArtBridge',
    duration: 'Art Book',
    image: 'assets/images/courses/watercolor_art.jpg',
  ),

  Course(
    id: 'course_006',
    title: 'Fabric Painting Art',
    description:
        'Turn everyday fabric into beautiful artwork using creative fabric painting techniques.',
    price: 15,
    type: CourseType.pdf,
    instructor: 'ArtBridge',
    duration: 'Art Book',
    image: 'assets/images/courses/fabric_painting_art.jpg',
  ),

  Course(
    id: 'course_007',
    title: 'Mural Art',
    description:
        'Learn how to plan, design and create expressive artwork on large wall spaces.',
    price: 15,
    type: CourseType.pdf,
    instructor: 'ArtBridge',
    duration: 'Art Book',
    image: 'assets/images/courses/mural_art.jpg',
  ),

  // ============================================================
  // PHYSICAL CLASSES
  // ============================================================

  Course(
    id: 'course_008',
    title: 'Watercolor Painting',
    description:
        'Join an instructor-led physical class and learn watercolor painting through hands-on practice.',
    price: 30,
    type: CourseType.physical,
    instructor: 'ArtBridge Instructor',
    duration: 'Physical Class',
    image: 'assets/images/courses/watercolor_art.jpg',
  ),

  Course(
    id: 'course_009',
    title: 'Portrait Painting',
    description:
        'Learn portrait painting techniques through guided, hands-on practice in a physical class.',
    price: 30,
    type: CourseType.physical,
    instructor: 'ArtBridge Instructor',
    duration: 'Physical Class',
    image: 'assets/images/courses/pencil_monochromatic_art.jpg',
  ),
];

  // ============================================================
  // ENROLLMENTS
  // ============================================================

  final List<Enrollment> enrollments = [];

  // ============================================================
  // ARTIST APPLICATIONS
  // ============================================================

  final List<ArtistApplication> artistApplications = [];

  // ============================================================
  // ARTWORKS
  // ============================================================

  final List<Artwork> artworks = [
    Artwork(
      id: 'art_001',
      artistId: 'artist_001',
      artistName: 'Demo Artist',
      title: 'Dreamy Landscape',
      description:
          'A peaceful landscape inspired by nature.',
      price: 80,
      category: 'Painting',
      image: 'assets/images/art1.jpg',
      status: ArtworkStatus.approved,
    ),
    Artwork(
      id: 'art_002',
      artistId: 'artist_001',
      artistName: 'Demo Artist',
      title: 'Ocean Dreams',
      description:
          'A calming artwork inspired by the ocean.',
      price: 65,
      category: 'Painting',
      image: 'assets/images/art2.jpg',
      status: ArtworkStatus.approved,
    ),
  ];

  // ============================================================
  // ORDERS
  // ============================================================

  final List<Order> orders = [];

  // ============================================================
  // FIREBASE SIGN UP
  // ============================================================

  Future<bool> signupWithFirebase({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final cleanName = name.trim();
      final cleanEmail = email.trim().toLowerCase();

      final credential =
          await _auth.createUserWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );

      final firebaseUser = credential.user;

      if (firebaseUser == null) {
        return false;
      }

      await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .set({
        'name': cleanName,
        'email': cleanEmail,
        'role': 'user',
        'hasCompletedCourse': false,
        'artistApplicationPending': false,
        'artistApplicationRejected': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      final newUser = User(
        id: firebaseUser.uid,
        name: cleanName,
        email: cleanEmail,
        password: '',
        role: UserRole.user,
        hasCompletedCourse: false,
        artistApplicationPending: false,
        artistApplicationRejected: false,
      );

      users.removeWhere(
        (user) => user.id == firebaseUser.uid,
      );

      users.add(newUser);
      currentUser = newUser;

      // Load the user's Firebase data.
      await loadEnrollments();
      await loadArtistApplications();
      await loadArtworks();

      notifyListeners();

      return true;
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint(
        'Firebase signup error: ${e.code} - ${e.message}',
      );
      return false;
    } catch (e) {
      debugPrint('Signup error: $e');
      return false;
    }
  }

  // ============================================================
  // FIREBASE LOGIN
  // ============================================================

  Future<bool> loginWithFirebase(
    String email,
    String password,
  ) async {
    try {
      final cleanEmail = email.trim().toLowerCase();

      final credential =
          await _auth.signInWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );

      final firebaseUser = credential.user;

      if (firebaseUser == null) {
        return false;
      }

      final userRef = _firestore
          .collection('users')
          .doc(firebaseUser.uid);

      DocumentSnapshot<Map<String, dynamic>>
          userDocument = await userRef.get();

      // ----------------------------------------------------------
      // Create missing Firestore profile if necessary
      // ----------------------------------------------------------

      if (!userDocument.exists) {
        debugPrint(
          'Firestore user document missing. Creating profile...',
        );

        await userRef.set({
          'name':
              firebaseUser.displayName ?? 'ArtBridge User',
          'email':
              firebaseUser.email ?? cleanEmail,
          'role': 'user',
          'hasCompletedCourse': false,
          'artistApplicationPending': false,
          'artistApplicationRejected': false,
          'createdAt': FieldValue.serverTimestamp(),
        });

        userDocument = await userRef.get();
      }

      final data = userDocument.data();

      if (data == null) {
        debugPrint(
          'Firestore user profile could not be loaded.',
        );
        return false;
      }

      // ----------------------------------------------------------
      // Convert Firebase role to UserRole
      // ----------------------------------------------------------

      final roleString =
          data['role']?.toString() ?? 'user';

      UserRole role;

      switch (roleString) {
        case 'artist':
          role = UserRole.artist;
          break;

        case 'admin':
          role = UserRole.admin;
          break;

        default:
          role = UserRole.user;
      }

      // ----------------------------------------------------------
      // Create local user from Firebase data
      // ----------------------------------------------------------

      final firebaseAppUser = User(
        id: firebaseUser.uid,
        name: data['name']?.toString() ??
            'ArtBridge User',
        email: data['email']?.toString() ??
            firebaseUser.email ??
            cleanEmail,
        password: '',
        role: role,
        hasCompletedCourse:
            data['hasCompletedCourse'] == true,
        artistApplicationPending:
            data['artistApplicationPending'] == true,
        artistApplicationRejected:
            data['artistApplicationRejected'] == true,
      );

      users.removeWhere(
        (user) => user.id == firebaseUser.uid,
      );

      users.add(firebaseAppUser);

      currentUser = firebaseAppUser;

      // ----------------------------------------------------------
      // Load Firebase user data
      // ----------------------------------------------------------

      await loadEnrollments();
      await loadArtistApplications();
      await loadArtworks();

      notifyListeners();

      return true;
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint(
        'Firebase login error: ${e.code} - ${e.message}',
      );
      return false;
    } catch (e) {
      debugPrint(
        'Login error: $e',
      );
      return false;
    }
  }

  // ============================================================
  // FIREBASE LOGOUT
  // ============================================================

  Future<void> logoutFromFirebase() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint(
        'Firebase logout error: $e',
      );
    }

    currentUser = null;
    enrollments.clear();
    artistApplications.clear();

    notifyListeners();
  }

  // ============================================================
  // OLD LOGIN
  // ============================================================

  bool login(
    String email,
    String password,
  ) {
    try {
      final user = users.firstWhere(
        (user) =>
            user.email.toLowerCase() ==
                email.toLowerCase().trim() &&
            user.password == password,
      );

      currentUser = user;

      notifyListeners();

      return true;
    } catch (e) {
      return false;
    }
  }

  // ============================================================
  // OLD SIGNUP
  // ============================================================

  bool signup({
    required String name,
    required String email,
    required String password,
  }) {
    final cleanEmail = email.toLowerCase().trim();

    final emailExists = users.any(
      (user) =>
          user.email.toLowerCase() == cleanEmail,
    );

    if (emailExists) {
      return false;
    }

    final newUser = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      email: cleanEmail,
      password: password,
      role: UserRole.user,
    );

    users.add(newUser);

    currentUser = newUser;

    notifyListeners();

    return true;
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      debugPrint(
        'Logout error: $e',
      );
    }

    currentUser = null;
    enrollments.clear();
    artistApplications.clear();

    notifyListeners();
  }

  // ============================================================
  // COURSE ENROLLMENT - FIREBASE
  // ============================================================

  Future<bool> enrollInCourse(
    String courseId,
  ) async {
    if (currentUser == null) {
      return false;
    }

    try {
      // ----------------------------------------------------------
      // Check local state first
      // ----------------------------------------------------------

      final alreadyEnrolled = enrollments.any(
        (enrollment) =>
            enrollment.userId == currentUser!.id &&
            enrollment.courseId == courseId,
      );

      if (alreadyEnrolled) {
        return true;
      }

      // ----------------------------------------------------------
      // Check Firebase
      // ----------------------------------------------------------

      final existingSnapshot = await _firestore
          .collection('enrollments')
          .where(
            'userId',
            isEqualTo: currentUser!.id,
          )
          .where(
            'courseId',
            isEqualTo: courseId,
          )
          .limit(1)
          .get();

      if (existingSnapshot.docs.isNotEmpty) {
        final existingDocument =
            existingSnapshot.docs.first;

        final existingEnrollment =
            Enrollment.fromFirestore(
          existingDocument.id,
          existingDocument.data(),
        );

        enrollments.add(existingEnrollment);

        notifyListeners();

        return true;
      }

      // ----------------------------------------------------------
      // Create new enrollment
      // ----------------------------------------------------------

      final enrollmentRef = _firestore
          .collection('enrollments')
          .doc();

      final enrollment = Enrollment(
        id: enrollmentRef.id,
        userId: currentUser!.id,
        courseId: courseId,
        isCompleted: false,
        progress: 0,
      );

      // ----------------------------------------------------------
      // Save to Firebase
      // ----------------------------------------------------------

      await enrollmentRef.set({
        ...enrollment.toFirestore(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // ----------------------------------------------------------
      // Update local state
      // ----------------------------------------------------------

      enrollments.add(enrollment);

      notifyListeners();

      debugPrint(
        'Course enrollment saved successfully: '
        '${enrollment.id}',
      );

      return true;
    } on FirebaseException catch (e) {
      debugPrint(
        'Enroll Firebase error: '
        'code=${e.code}, message=${e.message}',
      );

      return false;
    } catch (e) {
      debugPrint(
        'Enroll in course error: $e',
      );

      return false;
    }
  }

  // ============================================================
  // LOAD ENROLLMENTS FROM FIREBASE
  // ============================================================

  Future<void> loadEnrollments() async {
    if (currentUser == null) {
      return;
    }

    try {
      final snapshot = await _firestore
          .collection('enrollments')
          .where(
            'userId',
            isEqualTo: currentUser!.id,
          )
          .get();

      enrollments.clear();

      for (final document in snapshot.docs) {
        final enrollment =
            Enrollment.fromFirestore(
          document.id,
          document.data(),
        );

        enrollments.add(enrollment);
      }

      debugPrint(
        'Loaded ${enrollments.length} enrollments.',
      );

      notifyListeners();
    } on FirebaseException catch (e) {
      debugPrint(
        'Load enrollments Firebase error: '
        'code=${e.code}, message=${e.message}',
      );
    } catch (e) {
      debugPrint(
        'Load enrollments error: $e',
      );
    }
  }

  // ============================================================
  // COMPLETE COURSE - FIREBASE
  // ============================================================

  Future<bool> completeCourse(
    String courseId,
  ) async {
    if (currentUser == null) {
      return false;
    }

    try {
      // ----------------------------------------------------------
      // Find enrollment
      // ----------------------------------------------------------

      Enrollment? enrollment;

      for (final item in enrollments) {
        if (item.userId == currentUser!.id &&
            item.courseId == courseId) {
          enrollment = item;
          break;
        }
      }

      // ----------------------------------------------------------
      // If not loaded locally, check Firebase
      // ----------------------------------------------------------

      if (enrollment == null) {
        final snapshot = await _firestore
            .collection('enrollments')
            .where(
              'userId',
              isEqualTo: currentUser!.id,
            )
            .where(
              'courseId',
              isEqualTo: courseId,
            )
            .limit(1)
            .get();

        if (snapshot.docs.isEmpty) {
          debugPrint(
            'Complete course error: Enrollment not found.',
          );

          return false;
        }

        final document = snapshot.docs.first;

        enrollment =
            Enrollment.fromFirestore(
          document.id,
          document.data(),
        );

        enrollments.add(enrollment);
      }

      // ----------------------------------------------------------
      // Update enrollment
      // ----------------------------------------------------------

      enrollment.isCompleted = true;
      enrollment.progress = 100;

      await _firestore
          .collection('enrollments')
          .doc(enrollment.id)
          .update({
        'isCompleted': true,
        'progress': 100,
      });

      // ----------------------------------------------------------
      // Update user's course completion status
      // ----------------------------------------------------------

      currentUser!.hasCompletedCourse = true;

      await _firestore
          .collection('users')
          .doc(currentUser!.id)
          .update({
        'hasCompletedCourse': true,
      });

      notifyListeners();

      debugPrint(
        'Course completed successfully: $courseId',
      );

      return true;
    } on FirebaseException catch (e) {
      debugPrint(
        'Complete course Firebase error: '
        'code=${e.code}, message=${e.message}',
      );

      return false;
    } catch (e) {
      debugPrint(
        'Complete course error: $e',
      );

      return false;
    }
  }

  // ============================================================
  // APPLY TO BECOME ARTIST - FIREBASE
  // ============================================================

  Future<bool> applyToBecomeArtist({
    required String bio,
    required String specialization,
    required String portfolio,
  }) async {
    if (currentUser == null) {
      return false;
    }

    if (!currentUser!.canApplyAsArtist) {
      return false;
    }

    try {
      final applicationRef = _firestore
          .collection('artistApplications')
          .doc();

      final application = ArtistApplication(
        id: applicationRef.id,
        userId: currentUser!.id,
        bio: bio.trim(),
        specialization:
            specialization.trim(),
        portfolio: portfolio.trim(),
        status: ApplicationStatus.pending,
      );

      // ----------------------------------------------------------
      // Save application to Firestore
      // ----------------------------------------------------------

      await applicationRef.set(
        application.toFirestore(),
      );

      // ----------------------------------------------------------
      // Update user's application status
      // ----------------------------------------------------------

      await _firestore
          .collection('users')
          .doc(currentUser!.id)
          .update({
        'artistApplicationPending': true,
        'artistApplicationRejected': false,
      });

      // ----------------------------------------------------------
      // Update local state
      // ----------------------------------------------------------

      artistApplications.add(application);

      currentUser!.artistApplicationPending = true;
      currentUser!.artistApplicationRejected = false;

      notifyListeners();

      return true;
    } on FirebaseException catch (e) {
      debugPrint(
        'Apply artist Firebase error: '
        'code=${e.code}, message=${e.message}',
      );

      return false;
    } catch (e) {
      debugPrint(
        'Apply artist Firebase error: $e',
      );

      return false;
    }
  }

  // ============================================================
  // LOAD ARTIST APPLICATIONS
  // ============================================================

  Future<void> loadArtistApplications() async {
    try {
      final snapshot = await _firestore
          .collection('artistApplications')
          .get();

      artistApplications.clear();

      for (final document in snapshot.docs) {
        final application =
            ArtistApplication.fromFirestore(
          document.id,
          document.data(),
        );

        artistApplications.add(application);
      }

      notifyListeners();
    } on FirebaseException catch (e) {
      debugPrint(
        'Load artist applications Firebase error: '
        'code=${e.code}, message=${e.message}',
      );
    } catch (e) {
      debugPrint(
        'Load artist applications error: $e',
      );
    }
  }

  // ============================================================
  // ADMIN APPROVES ARTIST
  // ============================================================

  Future<bool> approveArtistApplication(
    String applicationId,
  ) async {
    try {
      final applicationRef = _firestore
          .collection('artistApplications')
          .doc(applicationId);

      // ----------------------------------------------------------
      // Get application
      // ----------------------------------------------------------

      final applicationDocument =
          await applicationRef.get();

      if (!applicationDocument.exists) {
        debugPrint(
          'Approve error: Artist application not found.',
        );

        return false;
      }

      final applicationData =
          applicationDocument.data();

      if (applicationData == null) {
        debugPrint(
          'Approve error: Application data is empty.',
        );

        return false;
      }

      final application =
          ArtistApplication.fromFirestore(
        applicationDocument.id,
        applicationData,
      );

      if (application.userId.isEmpty) {
        debugPrint(
          'Approve error: Application has no userId.',
        );

        return false;
      }

      // ----------------------------------------------------------
      // Find user's Firebase document
      // ----------------------------------------------------------

      final userRef = _firestore
          .collection('users')
          .doc(application.userId);

      final userDocument =
          await userRef.get();

      if (!userDocument.exists) {
        debugPrint(
          'Approve error: User document not found: '
          '${application.userId}',
        );

        return false;
      }

      // ----------------------------------------------------------
      // Firestore batch
      // ----------------------------------------------------------

      final batch = _firestore.batch();

      // 1. Approve application.
      batch.update(
        applicationRef,
        {
          'status': 'approved',
        },
      );

      // 2. Change user role to artist.
      batch.update(
        userRef,
        {
          'role': 'artist',
          'artistApplicationPending': false,
          'artistApplicationRejected': false,
        },
      );

      await batch.commit();

      // ----------------------------------------------------------
      // Update local application
      // ----------------------------------------------------------

      final localApplication =
          _findLocalApplication(applicationId);

      if (localApplication != null) {
        localApplication.status =
            ApplicationStatus.approved;
      }

      // ----------------------------------------------------------
      // Update local user
      // ----------------------------------------------------------

      final localUser =
          _findLocalUser(application.userId);

      if (localUser != null) {
        localUser.role = UserRole.artist;
        localUser.artistApplicationPending =
            false;
        localUser.artistApplicationRejected =
            false;
      }

      // ----------------------------------------------------------
      // Update current user
      // ----------------------------------------------------------

      if (currentUser?.id == application.userId) {
        currentUser!.role = UserRole.artist;
        currentUser!.artistApplicationPending =
            false;
        currentUser!.artistApplicationRejected =
            false;
      }

      notifyListeners();

      debugPrint(
        'Artist approved successfully: '
        '${application.userId}',
      );

      return true;
    } on FirebaseException catch (e) {
      debugPrint(
        'Approve artist Firebase error: '
        'code=${e.code}, message=${e.message}',
      );

      return false;
    } catch (e) {
      debugPrint(
        'Approve artist unexpected error: $e',
      );

      return false;
    }
  }

  // ============================================================
  // ADMIN REJECTS ARTIST
  // ============================================================

  Future<bool> rejectArtistApplication(
    String applicationId,
  ) async {
    try {
      final applicationRef = _firestore
          .collection('artistApplications')
          .doc(applicationId);

      // ----------------------------------------------------------
      // Get application
      // ----------------------------------------------------------

      final applicationDocument =
          await applicationRef.get();

      if (!applicationDocument.exists) {
        debugPrint(
          'Reject error: Artist application not found.',
        );

        return false;
      }

      final applicationData =
          applicationDocument.data();

      if (applicationData == null) {
        debugPrint(
          'Reject error: Application data is empty.',
        );

        return false;
      }

      final application =
          ArtistApplication.fromFirestore(
        applicationDocument.id,
        applicationData,
      );

      if (application.userId.isEmpty) {
        debugPrint(
          'Reject error: Application has no userId.',
        );

        return false;
      }

      // ----------------------------------------------------------
      // Find user's Firebase document
      // ----------------------------------------------------------

      final userRef = _firestore
          .collection('users')
          .doc(application.userId);

      final userDocument =
          await userRef.get();

      if (!userDocument.exists) {
        debugPrint(
          'Reject error: User document not found: '
          '${application.userId}',
        );

        return false;
      }

      // ----------------------------------------------------------
      // Firestore batch
      // ----------------------------------------------------------

      final batch = _firestore.batch();

      // 1. Reject application.
      batch.update(
        applicationRef,
        {
          'status': 'rejected',
        },
      );

      // 2. Update user's application status.
      batch.update(
        userRef,
        {
          'artistApplicationPending': false,
          'artistApplicationRejected': true,
        },
      );

      await batch.commit();

      // ----------------------------------------------------------
      // Update local application
      // ----------------------------------------------------------

      final localApplication =
          _findLocalApplication(applicationId);

      if (localApplication != null) {
        localApplication.status =
            ApplicationStatus.rejected;
      }

      // ----------------------------------------------------------
      // Update local user
      // ----------------------------------------------------------

      final localUser =
          _findLocalUser(application.userId);

      if (localUser != null) {
        localUser.artistApplicationPending =
            false;
        localUser.artistApplicationRejected =
            true;
      }

      // ----------------------------------------------------------
      // Update current user
      // ----------------------------------------------------------

      if (currentUser?.id == application.userId) {
        currentUser!.artistApplicationPending =
            false;
        currentUser!.artistApplicationRejected =
            true;
      }

      notifyListeners();

      debugPrint(
        'Artist application rejected successfully: '
        '${application.userId}',
      );

      return true;
    } on FirebaseException catch (e) {
      debugPrint(
        'Reject artist Firebase error: '
        'code=${e.code}, message=${e.message}',
      );

      return false;
    } catch (e) {
      debugPrint(
        'Reject artist unexpected error: $e',
      );

      return false;
    }
  }

  // ============================================================
  // HELPER - FIND LOCAL APPLICATION
  // ============================================================

  ArtistApplication? _findLocalApplication(
    String applicationId,
  ) {
    for (final application in artistApplications) {
      if (application.id == applicationId) {
        return application;
      }
    }

    return null;
  }

  // ============================================================
  // HELPER - FIND LOCAL USER
  // ============================================================

  User? _findLocalUser(
    String userId,
  ) {
    for (final user in users) {
      if (user.id == userId) {
        return user;
      }
    }

    return null;
  }

  // ============================================================
  // ARTIST SUBMITS ARTWORK - FIREBASE
  // ============================================================

  Future<bool> submitArtwork({
    required String title,
    required String description,
    required double price,
    required String category,
    required String image,
  }) async {
    if (currentUser == null) {
      return false;
    }

    if (!currentUser!.isArtist) {
      return false;
    }

    try {
      final artworkRef =
          _firestore.collection('artworks').doc();

      final artwork = Artwork(
        id: artworkRef.id,
        artistId: currentUser!.id,

        // IMPORTANT:
        // Save the artist's actual name with the artwork.
        artistName: currentUser!.name,

        title: title.trim(),
        description: description.trim(),
        price: price,
        category: category.trim(),
        image: image.trim(),
        status: ArtworkStatus.approved,
      );

      await artworkRef.set(
        artwork.toFirestore(),
      );

      artworks.add(artwork);

      notifyListeners();

      debugPrint(
        'Artwork uploaded successfully: ${artwork.id}',
      );

      return true;
    } on FirebaseException catch (e) {
      debugPrint(
        'Submit artwork Firebase error: '
        'code=${e.code}, message=${e.message}',
      );

      return false;
    } catch (e) {
      debugPrint(
        'Submit artwork error: $e',
      );

      return false;
    }
  }

  // ============================================================
  // LOAD ARTWORKS FROM FIREBASE
  // ============================================================

  Future<void> loadArtworks() async {
    try {
      final snapshot = await _firestore
          .collection('artworks')
          .get();

      artworks.clear();

      for (final document in snapshot.docs) {
        final artwork =
            Artwork.fromFirestore(
          document.id,
          document.data(),
        );

        artworks.add(artwork);
      }

      debugPrint(
        'Loaded ${artworks.length} artworks.',
      );

      notifyListeners();
    } on FirebaseException catch (e) {
      debugPrint(
        'Load artworks Firebase error: '
        'code=${e.code}, message=${e.message}',
      );
    } catch (e) {
      debugPrint(
        'Load artworks error: $e',
      );
    }
  }

  // ============================================================
  // ADMIN APPROVES ARTWORK
  // ============================================================

  // Kept for compatibility with the existing admin screen.
  // New artist uploads are already approved automatically.

  Future<bool> approveArtwork(
    String artworkId,
  ) async {
    try {
      final artworkRef =
          _firestore.collection('artworks').doc(artworkId);

      await artworkRef.update({
        'status': 'approved',
      });

      for (final artwork in artworks) {
        if (artwork.id == artworkId) {
          artwork.status = ArtworkStatus.approved;
          break;
        }
      }

      notifyListeners();

      return true;
    } on FirebaseException catch (e) {
      debugPrint(
        'Approve artwork Firebase error: '
        'code=${e.code}, message=${e.message}',
      );

      return false;
    } catch (e) {
      debugPrint(
        'Approve artwork error: $e',
      );

      return false;
    }
  }

  // ============================================================
  // ADMIN REJECTS ARTWORK
  // ============================================================

  // Kept for compatibility.
  // The normal artist upload flow does not require approval.

  Future<bool> rejectArtwork(
    String artworkId,
  ) async {
    try {
      final artworkRef =
          _firestore.collection('artworks').doc(artworkId);

      await artworkRef.update({
        'status': 'rejected',
      });

      for (final artwork in artworks) {
        if (artwork.id == artworkId) {
          artwork.status = ArtworkStatus.rejected;
          break;
        }
      }

      notifyListeners();

      return true;
    } on FirebaseException catch (e) {
      debugPrint(
        'Reject artwork Firebase error: '
        'code=${e.code}, message=${e.message}',
      );

      return false;
    } catch (e) {
      debugPrint(
        'Reject artwork error: $e',
      );

      return false;
    }
  }

  // ============================================================
  // BUY ARTWORK
  // ============================================================

  // Orders are still local for now.
  // Artist cannot purchase their own artwork.
  // Returns true when purchase is successful.

  Future<bool> buyArtwork(
    String artworkId,
  ) async {
    if (currentUser == null) {
      debugPrint(
        'Buy artwork error: No logged-in user.',
      );

      return false;
    }

    try {
      // ----------------------------------------------------------
      // Find approved artwork
      // ----------------------------------------------------------

      final artwork = artworks.firstWhere(
        (artwork) =>
            artwork.id == artworkId &&
            artwork.status == ArtworkStatus.approved,
      );

      // ----------------------------------------------------------
      // Prevent artist from buying their own artwork
      // ----------------------------------------------------------

      if (artwork.artistId == currentUser!.id) {
        debugPrint(
          'Purchase blocked: Artist cannot buy their own artwork.',
        );

        return false;
      }

      // ----------------------------------------------------------
      // Create order
      // ----------------------------------------------------------

      final order = Order(
        id: DateTime.now()
            .millisecondsSinceEpoch
            .toString(),
        buyerId: currentUser!.id,
        artworkId: artwork.id,
        amount: artwork.price,
        createdAt: DateTime.now(),
      );

      // ----------------------------------------------------------
      // Save order locally
      // ----------------------------------------------------------

      orders.add(order);

      notifyListeners();

      debugPrint(
        'Artwork purchased successfully: ${artwork.title}',
      );

      return true;
    } catch (e) {
      debugPrint(
        'Buy artwork error: $e',
      );

      return false;
    }
  }
}