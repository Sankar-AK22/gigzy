import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/worker_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ==================== WORKERS ====================

  /// Add a new worker to the 'workers' collection
  Future<DocumentReference> addWorker(Map<String, dynamic> data) {
    return _db.collection('workers').add(data);
  }

  /// Stream all workers (real-time)
  Stream<List<WorkerModel>> getWorkersStream() {
    return _db
        .collection('workers')
        .orderBy('registeredAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WorkerModel.fromFirestore(doc))
            .toList());
  }

  /// Get a single worker by document ID
  Future<WorkerModel?> getWorkerById(String id) async {
    final doc = await _db.collection('workers').doc(id).get();
    if (doc.exists) {
      return WorkerModel.fromFirestore(doc);
    }
    return null;
  }

  /// Real-time stream for a single worker
  Stream<WorkerModel?> getWorkerStream(String id) {
    return _db.collection('workers').doc(id).snapshots().map((doc) {
      if (doc.exists) {
        return WorkerModel.fromFirestore(doc);
      }
      return null;
    });
  }

  /// Update a worker document
  Future<void> updateWorker(String id, Map<String, dynamic> data) {
    return _db.collection('workers').doc(id).update(data);
  }

  /// Delete a worker document
  Future<void> deleteWorker(String id) {
    return _db.collection('workers').doc(id).delete();
  }

  // ==================== CLAIMS ====================

  Stream<List<Map<String, dynamic>>> getClaimsStream() {
    return _db
        .collection('claims')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList());
  }

  Stream<List<Map<String, dynamic>>> getUserClaimsStream(String userId) {
    return _db
        .collection('claims')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList());
  }

  // ==================== DATA SEEDING ====================

  Future<void> seedTestData() async {
    final workers = [
      {
        'name': 'Rahul Kumar',
        'phone': '9876543210',
        'city': 'Mumbai',
        'platform': 'Swiggy',
        'vehicleType': 'Bike',
        'zone': 'Andheri West',
        'avgDailyIncome': 850.0,
        'workingHours': 9,
        'preferredCoverage': 1200.0,
        'registeredAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Priya Singh',
        'phone': '9123456780',
        'city': 'Delhi',
        'platform': 'Zomato',
        'vehicleType': 'Scooter',
        'zone': 'South Delhi',
        'avgDailyIncome': 700.0,
        'workingHours': 8,
        'preferredCoverage': 1000.0,
        'registeredAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Amit Patel',
        'phone': '9988776655',
        'city': 'Ahmedabad',
        'platform': 'Blinkit',
        'vehicleType': 'Bike',
        'zone': 'Navrangpura',
        'avgDailyIncome': 600.0,
        'workingHours': 7,
        'preferredCoverage': 800.0,
        'registeredAt': FieldValue.serverTimestamp(),
      }
    ];

    List<String> workerIds = [];

    // Add Workers
    for (var w in workers) {
      final docRef = await _db.collection('workers').add(w);
      workerIds.add(docRef.id);
    }

    if (workerIds.isEmpty) return;

    // Add Claims for the workers
    final claims = [
      {
        'userId': workerIds[0],
        'disruptionType': 'rainfall',
        'lostHours': 4.5,
        'hourlyRate': 95.0,
        'payoutAmount': 427.5,
        'claimStatus': 'paid',
        'fraudScore': 0.1,
        'autoTriggered': true,
        'createdAt': FieldValue.serverTimestamp(),
        'dateString': '18 Mar',
      },
      {
        'userId': workerIds[0],
        'disruptionType': 'heatwave',
        'lostHours': 3.0,
        'hourlyRate': 95.0,
        'payoutAmount': 285.0,
        'claimStatus': 'approved',
        'fraudScore': 0.05,
        'autoTriggered': true,
        'createdAt': FieldValue.serverTimestamp(),
        'dateString': '15 Mar',
      },
      {
        'userId': workerIds[1],
        'disruptionType': 'pollution',
        'lostHours': 5.0,
        'hourlyRate': 87.5,
        'payoutAmount': 437.5,
        'claimStatus': 'review',
        'fraudScore': 0.8,
        'autoTriggered': true,
        'createdAt': FieldValue.serverTimestamp(),
        'dateString': '17 Mar',
      },
      {
        'userId': workerIds[2],
        'disruptionType': 'flood',
        'lostHours': 8.0,
        'hourlyRate': 85.0,
        'payoutAmount': 680.0,
        'claimStatus': 'paid',
        'fraudScore': 0.0,
        'autoTriggered': true,
        'createdAt': FieldValue.serverTimestamp(),
        'dateString': '10 Mar',
      }
    ];

    for (var c in claims) {
      await _db.collection('claims').add(c);
    }
  }
}
