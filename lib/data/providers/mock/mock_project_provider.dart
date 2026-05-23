import 'package:sejasa/core/wrappers/pagination_meta.dart';
import 'package:sejasa/core/wrappers/pagination_result.dart';
import 'package:sejasa/data/models/project_category_model.dart';
import 'package:sejasa/data/models/project_model.dart';
import 'package:sejasa/data/payloads/project_create_payload.dart';
import 'package:sejasa/data/payloads/project_update_payload.dart';
import 'package:sejasa/data/payloads/review_project_participant_payload.dart';
import 'package:sejasa/domain/value_objects/project_status.dart';
import 'package:sejasa/domain/providers/remote_project_provider.dart';

class MockProjectProvider extends RemoteProjectProvider {
  Future<List<ProjectModel>> searchProjects({
    required String keyword,
    String? sort,
    ProjectStatus? status,
    String? category,
  }) async {
    final allProjects = await getProjects(null, page: 1, limit: 10);
    return allProjects.data.where((project) {
      final matchesKeyword =
          project.name.toLowerCase().contains(keyword.toLowerCase()) ||
          (project.description?.toLowerCase().contains(keyword.toLowerCase()) ??
              false);
      final matchesStatus = status == null || project.status == status;
      final matchesCategory = category == null || project.category == category;

      return matchesKeyword && matchesStatus && matchesCategory;
    }).toList();
  }

  @override
  Future<PaginatedResult<ProjectModel>> getProjects(
    Map<String, dynamic>? queryParameters, {
    required int page,
    required int limit,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    final json = {
      "success": true,
      "status": 200,
      "message": "Get projects success!",
      "path": "/projects",
      "timestamp": "2025-12-09T06:58:02Z",
      "data": [
        {
          "id": "prj-7821-ab",
          "title": "Mengalahkan Raja Iblis",
          "address": "Kastil Raja Iblis, Benua Utara",
          "status": "hiring",
          "distance": "1000km",
          "participant": "3/4",
          "category": "Epic Quest",
          "description":
              "Dibutuhkan segera anggota party terakhir untuk menyusup ke kastil raja iblis. Bahaya sangat tinggi, namun bayaran sepadan.",
          "requirements": [
            "Warrior tahan banting",
            "Priest anti status buruk",
            "Leaderships",
            "Bisa menggunakan Zoltrak",
          ],
          "hastags": ["quest", "fantasy", "isekai"],
          "owner": "Himmel",
          "owner_rating": 5.0,
          "owner_image": "/user/himmel_hero.jpg",
          "bookmark": true,
        },
        {
          "id": "prj-9932-cd",
          "title": "Pengawalan Kereta Pedagang",
          "address": "Jalur Perdagangan Utama, Kota Auber",
          "status": "on_going",
          "distance": "45km",
          "participant": "2/2",
          "category": "Escort",
          "description":
              "Mengawal kereta berisi persediaan logistik sihir dari ibu kota menuju perbatasan.",
          "requirements": [
            "Memiliki sertifikat pengawal minimal rank C",
            "Bisa sihir pelindung (barrier)",
            "Membawa bekal sendiri",
          ],
          "hastags": ["escort", "travel", "safe"],
          "owner": "Kraft",
          "owner_rating": 4.5,
          "owner_image": "/user/kraft_merchant.jpg",
          "bookmark": false,
        },
        {
          "id": "prj-1124-ef",
          "title": "Membasmi Sarang Goblin",
          "address": "Gua Gelap Selatan",
          "status": "completed",
          "distance": "12km",
          "participant": "4/4",
          "category": "Extermination",
          "description":
              "Sekelompok goblin sering menyerang ladang petani di desa kami. Tolong basmi mereka sampai ke akarnya.",
          "requirements": [
            "Terbiasa di area gelap",
            "Membawa obor dan anti-racun",
            "Pengalaman membunuh monster kecil",
          ],
          "hastags": ["combat", "cave", "goblins"],
          "owner": "Kepala Desa Tua",
          "owner_rating": 4.8,
          "owner_image": "/user/village_chief.jpg",
          "bookmark": true,
        },
        {
          "id": "prj-5541-gh",
          "title": "Pencarian Grimoire Kuno",
          "address": "Perpustakaan Bawah Tanah Reruntuhan",
          "status": "cancled",
          "distance": "300km",
          "participant": "0/1",
          "category": "Exploration",
          "description":
              "Mencari buku sihir legendaris peninggalan penyihir agung Flammie. Lokasi belum dipastikan aman.",
          "requirements": [
            "Penyihir tingkat lanjut",
            "Bisa membaca huruf kuno",
            "Tahan terhadap sihir kutukan",
          ],
          "hastags": ["magic", "ruins", "knowledge"],
          "owner": "Serie",
          "owner_rating": 4.9,
          "owner_image": "/user/serie_mage.jpg",
          "bookmark": false,
        },
        {
          "id": "prj-2210-ij",
          "title": "Mencari Kucing Bangsawan Hilang",
          "address": "Distrik Bangsawan, Ibukota",
          "status": "hiring",
          "distance": "5km",
          "participant": "1/5",
          "category": "Investigation",
          "description":
              "Kucing peliharaan Tuan Duke bernama 'Buble' kabur dari mansion. Hadiah besar menanti bagi yang menemukannya tanpa lecet.",
          "requirements": [
            "Menyukai hewan",
            "Bisa memanjat pohon",
            "Mata jeli",
          ],
          "hastags": ["pet", "city", "easy"],
          "owner": "Duke Vollachia",
          "owner_rating": 3.5,
          "owner_image": "/user/duke_v.jpg",
          "bookmark": true,
        },
        {
          "id": "prj-3398-kl",
          "title": "Panen Rumput Penyembuh",
          "address": "Hutan Tepi Danau",
          "status": "hiring",
          "distance": "18km",
          "participant": "2/10",
          "category": "Gathering",
          "description":
              "Membutuhkan banyak tenaga untuk memanen rumput obat biru yang hanya mekar saat bulan purnama malam ini.",
          "requirements": [
            "Teliti dan sabar",
            "Tidak buta warna",
            "Membawa sarung tangan kulit",
          ],
          "hastags": ["gathering", "herb", "night"],
          "owner": "Apoteker Kota",
          "owner_rating": 4.2,
          "owner_image": "/user/apothecary.jpg",
          "bookmark": false,
        },
        {
          "id": "prj-8874-mn",
          "title": "Menjaga Gerbang Kota",
          "address": "Gerbang Timur Ibukota",
          "status": "hiring",
          "distance": "2km",
          "participant": "5/6",
          "category": "Guard",
          "description":
              "Dibutuhkan penjaga tambahan selama Festival Bintang jatuh. Tugas hanya berdiri dan memeriksa identitas pengunjung.",
          "requirements": [
            "Fisik kuat untuk berdiri lama",
            "Bisa membaca ID Card",
            "Tidak mudah mabuk",
          ],
          "hastags": ["guard", "festival", "city"],
          "owner": "Kapten Penjaga",
          "owner_rating": 4.0,
          "owner_image": "/user/guard_captain.jpg",
          "bookmark": true,
        },
        {
          "id": "prj-6652-op",
          "title": "Investigasi Anomali Sihir",
          "address": "Hutan Ilusi",
          "status": "hiring",
          "distance": "150km",
          "participant": "1/3",
          "category": "Investigation",
          "description":
              "Aliran mana di hutan ilusi menjadi sangat kacau. Butuh tim peneliti untuk mengecek pusat anomali.",
          "requirements": [
            "Deteksi Mana tingkat tinggi",
            "Pikiran yang tenang (tahan ilusi)",
            "Membawa alat ukur sihir",
          ],
          "hastags": ["magic", "investigation", "danger"],
          "owner": "Fern",
          "owner_rating": 4.7,
          "owner_image": "/user/fern_mage.jpg",
          "bookmark": false,
        },
        {
          "id": "prj-4411-qr",
          "title": "Melatih Prajurit Baru",
          "address": "Barak Pasukan Kerajaan",
          "status": "hiring",
          "distance": "8km",
          "participant": "0/2",
          "category": "Training",
          "description":
              "Dicari petualang veteran untuk memberikan sesi latihan tempur nyata kepada rekrutan prajurit baru kerajaan.",
          "requirements": [
            "Pengalaman bertarung > 10 tahun",
            "Bisa mengendalikan kekuatan (tidak membunuh murid)",
            "Memiliki sertifikat instruktur (opsional)",
          ],
          "hastags": ["training", "combat", "mentor"],
          "owner": "Komandan Eisen",
          "owner_rating": 4.9,
          "owner_image": "/user/eisen_commander.jpg",
          "bookmark": true,
        },
      ],
    };

    final data = json['data'] as List<Map<String, dynamic>>;

    final projects = data.map((e) => ProjectModel.fromJson(e)).toList();
    return PaginatedResult(
      data: projects,
      meta: PaginationMeta(
        currentPage: 1,
        limitPage: 1,
        totalItems: projects.length,
        totalPages: 1,
      ),
    );
  }

  @override
  Future<ProjectModel> getProject(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    final json = {
      "success": true,
      "status": 200,
      "message": "Get projects success!",
      "path": "/projects",
      "timestamp": "2025-12-09T06:58:02Z",
      "data": {
        "id": "prj-7821-ab",
        "title": "Mengalahkan Raja Iblis",
        "address": "Kastil Raja Iblis, Benua Utara",
        "status": "hiring",
        "distance": "1000km",
        "participant": "3/4",
        "category": "Epic Quest",
        "description":
            '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam egestas velit enim, sit amet dapibus libero elementum at. Quisque sit amet felis at eros tincidunt efficitur sed sed nibh. Mauris quis lacus a est elementum luctus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Pellentesque vel tristique ex. Praesent tincidunt enim in orci pharetra, vitae iaculis mi pulvinar. Praesent sed risus a ex dapibus interdum eu in purus. Maecenas varius tempor tincidunt. Donec pulvinar, elit et egestas dignissim, ligula metus semper est, et semper libero metus vitae orci. Aliquam feugiat ac ante at sollicitudin. Duis nulla nibh, venenatis sit amet velit sit amet, hendrerit consequat orci. Nam blandit augue eget magna mattis dignissim. Sed convallis lorem eu orci efficitur, sit amet convallis tortor placerat. Donec ac pretium sem. Aenean nulla mi, rutrum ac tempus at, pharetra sed tortor.

Vivamus ut volutpat leo, ut fermentum neque. Duis sit amet velit nisl. Curabitur tortor risus, consequat vel mauris eget, porta mollis elit. Pellentesque pellentesque erat quis convallis venenatis. Aenean egestas felis nibh, ac aliquam augue maximus eu. Donec maximus sit amet felis sit amet egestas. Phasellus ornare accumsan eros eu aliquam. Praesent feugiat tempor tortor ac finibus. Morbi consequat dui quis justo cursus, sit amet viverra felis porttitor.

Aliquam erat volutpat. Praesent convallis, nisi a posuere elementum, diam risus vehicula justo, a eleifend massa ante sit amet sapien. Vivamus odio neque, vestibulum in auctor eu, tincidunt id diam. Sed vitae velit purus. Vestibulum at neque nunc. Donec eget vehicula nisi, nec blandit mauris. Etiam ante arcu, rutrum id euismod sed, cursus eu odio. Cras a ligula efficitur, rutrum erat vitae, laoreet mi. Vestibulum ornare massa ac bibendum hendrerit. Nulla sed sodales purus, sed bibendum nisl. Nullam et urna eget urna ultrices interdum. Donec venenatis ligula vel luctus euismod. Proin facilisis, ante nec hendrerit dapibus, velit felis egestas nisi, sed venenatis metus odio non dui. Maecenas quis nisi sed elit vulputate dignissim eget vitae odio. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Maecenas libero velit, vulputate vel quam ut, ornare vestibulum diam. ''',
        "requirements": [
          "Warrior tahan banting",
          "Priest anti status buruk",
          "Leaderships",
          "Bisa menggunakan Zoltrak testing panjgan nih fasf fadsfdas ff asdf dasf ",
        ],
        "hastags": ["quest", "fantasy", "isekai"],
        "owner": "Himmel",
        "owner_rating": 5.0,
        "owner_image": "/user/himmel_hero.jpg",
        "bookmark": true,
      },
    };

    final data = json['data'] as Map<String, dynamic>;
    return ProjectModel.fromJson(data);
  }

  @override
  Future<ProjectModel> createProject(ProjectCreatePayload payload) {
    // TODO: implement createProject
    throw UnimplementedError();
  }

  @override
  Future<ProjectModel> updateProject(ProjectUpdatePayload payload) {
    // TODO: implement updateProject
    throw UnimplementedError();
  }

  @override
  Future<List<ProjectModel>> getUserProjects(
    Map<String, dynamic>? queryParameters, {
    required String userId,
  }) {
    // TODO: implement getUserProjects
    throw UnimplementedError();
  }

  @override
  Future<List<ProjectCategoryModel>> getAllCategory() {
    // TODO: implement getAllCategory
    throw UnimplementedError();
  }

  @override
  Future<({String chatId, String projectId, String userId})> applyPorject(
    String projectId,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return (
      chatId: '1',
      userId: 'mock_user_id',
      projectId: projectId,
    );
  }

  @override
  Future<void> applyProjectParticipant({
    required String projectId,
    required String participantId,
    required String status,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<void> reviewAllProjectParticipant({
    required String projectId,
    required double rating,
    required String review,
  }) {
    // TODO: implement reviewAllProjectParticipant
    throw UnimplementedError();
  }

  @override
  Future<void> reviewProject({
    required String projectId,
    required double rating,
    required String review,
  }) {
    // TODO: implement reviewProject
    throw UnimplementedError();
  }

  @override
  Future<void> reviewProjectParticipant(
    ReviewProjectParticipantPayload payload,
  ) {
    // TODO: implement reviewProjectParticipant
    throw UnimplementedError();
  }
}
