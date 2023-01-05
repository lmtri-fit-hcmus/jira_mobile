import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:jira_mobile/objects/project.dart';
import 'package:jira_mobile/objects/sprint.dart';
import 'package:jira_mobile/objects/epic.dart';
import 'package:jira_mobile/objects/issue.dart';

class RequestData {
  // ignore: constant_identifier_names
  static const String MONGO_URI =
      "mongodb+srv://jiraclone:group03@clonejira.yknhuht.mongodb.net/jira";

  static RequestData? _instance;
  Db? db;

  RequestData._();

  factory RequestData() {
    _instance ??= RequestData._();
    return _instance!;
  }

  Future<Db?> getConnection() async {
    if (db == null) {
      try {
        db = await Db.create(MONGO_URI);
        await db!.open();
        log("Connected to server!!!");
      } catch (e) {
        print(e);
      }
    }
    return db;
  }

  static Future<DbCollection> loadCollection(String collectionName) async {
    _instance ??= await RequestData();
    _instance!.db = await _instance!.getConnection();
    var coll = _instance!.db!.collection(collectionName);
    return coll;
  }

  static Future<List<ProjectModel>> getMyProjects(String userId) async {
    var coll = await loadCollection('projects').then((value) => value);
    List<ProjectModel> ls = [];
    await coll.find(where).forEach(
      (element) {
        ProjectModel ref = ProjectModel();
        ref.fromJson(element);
        if (ref.members!.contains(stringToObjId(userId))) {
          ls.add(ref);
        }
      },
    );
    print(ls.length);
    return ls;
  }

  static Future<List<SprintModel>> getMySprint(String projectId) async {
    List<SprintModel> ls = [];
    var coll = await loadCollection('sprints');
    await coll
        .find(where
            .eq('project_id', stringToObjId(projectId))
            .eq('status', 'IN PROGRESS'))
        .forEach((element) {
      SprintModel ref = SprintModel();
      ref.fromJson(element);
      ls.add(ref);
    });

    return ls;
  }

  static Future<List<EpicModel>> getMyEpic(String projectId) async {
    List<EpicModel> ls = [];
    var coll = await loadCollection('epics');
    await coll
        .find(where
            .eq('project_id', stringToObjId(projectId))
            .eq('status', 'IN PROGRESS'))
        .forEach((element) {
      EpicModel ref = EpicModel();
      ref.fromJson(element);
      ls.add(ref);
    });

    return ls;
  }

  static Future<List<IssueModel>> getMyIssue(List<String> strIds) async {
    List<ObjectId> objIds = [];
    for (var v in strIds) {
      objIds.add(stringToObjId(v));
    }

    List<IssueModel> ls = [];
    var coll = await loadCollection('issues');
    await coll.find(where.oneFrom("_id", objIds)).forEach((element) {
      IssueModel ref = IssueModel();
      ref.fromJson(element);
      ls.add(ref);
    });

    return ls;
  }

  static Future<List<String>> getIssueIdFromSprint(String sprintId) async {
    List<String> res = [];

    var coll = await loadCollection('sprint_issue');

    await coll
        .find(where.eq('sprint_id', stringToObjId(sprintId)))
        .forEach((element) {
      var tmp = element['issues'];
      for (var v in tmp) {
        res.add(v.toHexString());
      }
    });

    return res;
  }

  static Future<List<String>> getIssueIdFromEpic(String epicId) async {
    List<String> res = [];

    var coll = await loadCollection('epic_issue');

    await coll
        .find(where.eq('epic_id', stringToObjId(epicId)))
        .forEach((element) {
      var tmp = element['issues'];
      for (var v in tmp) {
        res.add(v.toHexString());
      }
    });

    return res;
  }
}

ObjectId stringToObjId(String str) {
  return ObjectId.fromHexString(str);
}
