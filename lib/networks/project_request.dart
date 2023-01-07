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

  static late Db db;

  static Future<void> getConnection() async {
    db = await Db.create(MONGO_URI);
    await db.open();
    log("Connected to server!!!");
  }

  static Future<DbCollection> loadCollection(String collectionName) async {
    var coll = db.collection(collectionName);
    return coll;
  }

  static Future<List<ProjectModel>> getMyProjects(String userId) async {
    var coll = await loadCollection('projects');
    List<ProjectModel> ls = [];
    if (userId == "") return ls;
    await coll.find(where).forEach(
      (element) {
        ProjectModel ref = ProjectModel();
        ref.fromJson(element);
        if (ref.members!.contains(stringToObjId(userId))) {
          ls.add(ref);
        }
      },
    );
    return ls;
  }

  static Future<String> addNewIssue(
      String summary, String type, String status) async {
    var coll = await loadCollection('issues');
    var objId = ObjectId();
    IssueModel newIssue = IssueModel.withName(objId, summary, type, status);
    await coll.insert(newIssue.toMap());
    return objId.toHexString();
  }

  static Future<void> addIssueToSprint(String sprintId, String issueId) async {
    var coll = await loadCollection('sprint_issue');
    var objId = stringToObjId(issueId);

    await coll.modernUpdate(where.eq('sprint_id', stringToObjId(sprintId)),
        ModifierBuilder().push('issues', objId));
  }

  static Future<void> changeStatusSprint(String cmd, String sprintId) async {
    var updateValue = cmd.startsWith("Start") ? "IN PROGRESS" : "DONE";

    var coll = await loadCollection('sprints');
    await coll.updateOne(where.eq('_id', stringToObjId(sprintId)),
        modify.set('status', updateValue));
  }

  static Future<List<SprintModel>> getMySprint(String projectId) async {
    List<SprintModel> ls = [];
    var coll = await loadCollection('sprints');
    await coll
        .find(where
            .eq('project_id', stringToObjId(projectId))
            .ne('status', 'DONE'))
        .forEach((element) {
      SprintModel ref = SprintModel();
      ref.fromJson(element);
      ls.add(ref);
    });

    return ls;
  }

  static Future<List<SprintModel>> getMyActiveSprint(String projectId) async {
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

  static Future<void> deleteSprint(String sprintId) async {
    var coll = await loadCollection('sprints');
    await coll.deleteOne(where.eq('_id', stringToObjId(sprintId)));
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

    //log("getIssueIdFromSprint ${res.length.toString()}");
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
