import 'package:sejasa/domain/models/project_model.dart';
import 'package:sejasa/domain/providers/remote_project_provider.dart';

class MockProjectProvider extends RemoteProjectProvider {
  @override
  Future<List<ProjectModel>> getProjects() async {
    await Future.delayed(const Duration(seconds: 2));

    final json = {
      "success": true,
      "status": 200,
      "message": "Logour success!",
      "path": "/logout",
      "timestamp": "2025-12-09T06:58:02Z",
      "data": [
        {
          "id": "duhfjsahkdfhas",
          "title": "mengalahkan raja iblis",
          "address": "kastil raja iblis",
          "status": "hiring",
          "distance": "100km",
          "participant": "3/4",
          "category": "quest",
          "description": "bla bla bla",
          "requirements": [
            "warior tahan banting",
            "priest anti status buruk",
            "leaderships",
            "bisa menggunakan zoltrak",
          ],
          "hastags": ["quest", "fantasy", "isekai"],
          "owner": "serie",
          "owner_rating": 5.0,
          "owner_image": "/user/fjhskahdfs.jpg",
        },
        {
          "id": "duhfjsahkdfhas",
          "title": "mengalahkan raja iblis",
          "address": "kastil raja iblis",
          "status": "hiring",
          "distance": "100km",
          "participant": "3/4",
          "category": "quest",
          "description": "bla bla bla",
          "requirements": [
            "warior tahan banting",
            "priest anti status buruk",
            "leaderships",
            "bisa menggunakan zoltrak",
          ],
          "hastags": ["quest", "fantasy", "isekai"],
          "owner": "serie",
          "owner_rating": 5.0,
          "owner_image": "/user/fjhskahdfs.jpg",
        },
        {
          "id": "duhfjsahkdfhas",
          "title": "mengalahkan raja iblis",
          "address": "kastil raja iblis",
          "status": "hiring",
          "distance": "100km",
          "participant": "3/4",
          "category": "quest",
          "description": "bla bla bla",
          "requirements": [
            "warior tahan banting",
            "priest anti status buruk",
            "leaderships",
            "bisa menggunakan zoltrak",
          ],
          "hastags": ["quest", "fantasy", "isekai"],
          "owner": "serie",
          "owner_rating": 5.0,
          "owner_image": "/user/fjhskahdfs.jpg",
        },
      ],
    };

    final data = json['data'] as List<Map<String, dynamic>>;

    return data.map((e) => ProjectModel.fromJson(e)).toList();
  }
}
