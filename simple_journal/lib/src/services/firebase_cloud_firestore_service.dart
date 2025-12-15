import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class FirebaseCloudFirestoreService extends BaseService
    with
        NoSQLDbAccessor<
          QuerySnapshot<Map<String, dynamic>>,
          DocumentReference<Map<String, dynamic>>
        > {
  FirebaseCloudFirestoreService({required FirebaseFirestore db}) : _db = db;

  static const String serviceId = 'FIRESTORE_SERVICE';

  @override
  String get logId => serviceId;

  late final FirebaseFirestore _db;

  @override
  void dispose() {}

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> getCollection(
    String colectionId,
  ) async {
    try {
      final collection = await _db.collection(colectionId).get();

      return collection;
    } on FirebaseException catch (e) {
      debugPrint("$logId: $e");
      rethrow;
    }
  }

  @override
  Future<DocumentReference<Map<String, dynamic>>> getDocumentRef({
    required String collectionId,
    required String documentId,
  }) async {
    //  final collection = _db.collection(collectionId).doc(documentId);
    final docPath = '$collectionId/$documentId';
    final collection = _db.doc(docPath);

    return collection;
  }

  @override
  void init() {}
}

abstract class BaseService<C> {
  String get logId;

  void init();

  void dispose();
}

mixin NoSQLDbAccessor<C, D> {
  //The containers for documents
  Future<C> getCollection(String colectionId);

  //Documents: unit of storge , a record that contains fields, which map to values.
  Future<D> getDocumentRef({
    required String collectionId,
    required String documentId,
  });
}
