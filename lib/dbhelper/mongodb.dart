import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:jira_mobile/objects/sprint.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  // ignore: constant_identifier_names
  static  const String _MONGODB_URL = "mongodb+srv://jiraclone:group03@clonejira.yknhuht.mongodb.net/jira";
  static late DbCollection epicCollection;
  static late DbCollection epicIssuesCollection;
  static late DbCollection issueCollection;
  static late DbCollection userCollection;
  static late DbCollection projectCollection;
  static late DbCollection sprintCollection;
  static late DbCollection sprintIssueCollection;
  static late Db db;
  static connect() async {
    db =await Db.create(_MONGODB_URL);
    await db.open();
    inspect(db);
    epicCollection = db.collection("epics");
    epicIssuesCollection = db.collection("epic_issue");
    issueCollection = db.collection('issues');
    userCollection = db.collection('users');
    projectCollection = db.collection('projects');
    sprintIssueCollection = db.collection('sprint_issue');
    sprintCollection = db.collection('sprints');
  }
//get a document in epic collection
  static Future<Map<String, dynamic>> getEpic(ObjectId id) async {
    final epicData =  await epicCollection.findOne(where.eq("_id",id));
    return epicData!;
  }
//get a document in epic_issue collection
  static Future<Map<String, dynamic>?> getEpicIssues(ObjectId id) async {
    
    final epicIssues = await epicIssuesCollection.findOne(where.eq("epic_id",id));
    return epicIssues;
  } 
 //update one field of an document in collection 
  static Future<void> updateEpic(ObjectId id, String field, dynamic value) async {
    var res =  await epicCollection.updateOne(where.eq('_id',id), modify.set(field, value));
    
  }
//insert new document in issue collection and update in epic_issue collection
  static Future<void> insertChildissue(ObjectId epicId, List<ObjectId> issueId, String name) async {
    Map<String,dynamic>? epicIssueData = await epicIssuesCollection.findOne(where.eq("epic_id", epicId));
    if(epicIssueData == null) {
      epicIssuesCollection.insertOne({
        "epic_id": epicId,
        "issues": [],
      });
    }
    await issueCollection.insertOne({
      "_id":issueId[issueId.length - 1],
      "name":name,
      "description":'',
      'status':"TO DO",
      "assignee":null,
      'reporter':null,
      'start_date':'',
      'due_date':'',
      'sprint':null
    });

    await epicIssuesCollection.updateOne(where.eq('epic_id',epicId), modify.set('issues', issueId));
  }
//get a document in user collection
  static Future<Map<String,dynamic>> getUser(ObjectId id) async {
    final user = await userCollection.findOne(where.eq('_id', id));
    return user!;
  }
//get a document in project_member collection
  static Future<Map<String,dynamic>?> getProjectMemberIdByEpic(ObjectId projectId) async {
    final listMemberId = await projectCollection.findOne(where.eq('_id', projectId));
    return listMemberId;
  }
//get list documents in user collection have the id in project_member id
  static Future<List<Map<String,dynamic>>> getListMemberInProject(List<ObjectId> memberIds) async {
    List<Map<String,dynamic>> users = [];
    for(int i = 0; i< memberIds.length; i++){
      final member = await getUser(memberIds[i]);
      users.add(member);
    }
    return users;
   }
//get a document in issue collection
  static Future<Map<String,dynamic>> getIssue(ObjectId id) async {
    final issue = await issueCollection.findOne(where.eq('_id',id));
    return issue!;
  }
//get a doucment in epic_issue that epic is parent of issue
  static Future<Map<String,dynamic>?> getParentEpic(ObjectId issueId) async {
    final epicIssue = await epicIssuesCollection.findOne({"issues": issueId});
    
    if(epicIssue == null) {
      return null;
    }
    return getEpic(epicIssue['epic_id']);
  }
// 
  static Future<void> updateIssue(ObjectId id, String field, dynamic value) async {
    await issueCollection.updateOne(where.eq("_id",id), modify.set(field, value));
  }
//
  static Future<Map<String,dynamic>?> getSprint(ObjectId sprintId) async {
    final sprint = await sprintCollection.findOne({"_id": sprintId});
    return sprint;
  }
  static Future<Map<String,dynamic>?> getProjectMemberIdBySprint(ObjectId projectId) async {
    final listMemberId = await projectCollection.findOne(where.eq('_id', projectId));
    return listMemberId;
  }

//
  static Future<Map<String,dynamic>?> getSprintByIssueId(ObjectId issueId) async {
    var sprintIssues = await sprintIssueCollection.findOne({'issues': issueId});
    if(sprintIssues == null) {
      return null;
    }
    return getSprint(sprintIssues['sprint_id']);
  }
}