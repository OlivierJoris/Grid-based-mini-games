import 'package:cloud_firestore/cloud_firestore.dart';

/// DB (Firestore) management.
class DbConnect {
  FirebaseFirestore firestore;

  DbConnect() {
    firestore = FirebaseFirestore.instance;
  }

  /// Updates the score and challenges of a given player for a given game.
  /// [gameName] game's name. MUST match document's name of the collection 'scores' in DB.
  /// [username] the username for which the score need to be updated.
  /// [newScore] the score of the [username] for the game [gameName].
  void updateScore(String gameName, String username, int newScore) async {
    // We need to check if the user already has a score for the game
    bool scoreCanBeUpdated = false;
    try {
      DocumentSnapshot ds =
          await firestore.collection('scores').doc(gameName).get();
      if (ds.exists) {
        var data = ds.data();
        if (data[username] != null) {
          // previous score. We need to check if the previous score was better or not
          if (newScore < data[username]) scoreCanBeUpdated = true;
        } else
          scoreCanBeUpdated = true; // no previous score

        if (scoreCanBeUpdated)
          await firestore
              .collection('scores')
              .doc(gameName)
              .update({username: newScore});

        DocumentSnapshot docSnap =
            await firestore.collection('challenges').doc(gameName).get();
        int challengeScore = docSnap.data()['challenge_score'];

        if (newScore < challengeScore) {
          await firestore.collection('challenges').doc(gameName).update({
            'successful_users': FieldValue.arrayUnion([username])
          });
        }
      }
    } catch (e) {}

    return;
  }

  /// Returns the username of each user.
  Future<List<String>> get listUsers async {
    List<String> users = [];
    QuerySnapshot qs = await firestore.collection('users').get();
    qs.docs.forEach((document) {
      if (document.exists) users.add(document.data()['username'].toString());
    });

    return users;
  }

  /// Returns the current maximum score to achieve in order to pass
  /// the challenge associated to the game with DB document [docName].
  Future<int> getChallengeScore(String docName) async {
    try {
      DocumentSnapshot ds =
          await firestore.collection('challenges').doc(docName).get();

      return ds.data()['challenge_score'];
    } catch (e) {
      return null;
    }
  }

  /// Returns true if the user corresponding to [username] has achieved the
  /// challenge of [docName].
  Future<bool> hasUserAchievedChallenge(String username, String docName) async {
    List<String> users = [];

    try {
      DocumentSnapshot ds =
          await firestore.collection('challenges').doc(docName).get();

      ds.data()['successful_users'].forEach((user) {
        users.add(user);
      });
    } catch (e) {}

    if (users.contains(username)) return true;
    return false;
  }
}
