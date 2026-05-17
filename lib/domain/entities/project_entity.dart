import 'package:equatable/equatable.dart';
import 'package:sejasa/domain/value_objects/project_status.dart';

class ProjectEntity extends Equatable {
  final String id;
  final String name;
  final String? detailAddress;
  final double latitude;
  final double longitude;
  final ProjectStatus status;
  final double distance;
  final int maxParticipant;
  final int currentParticipant;
  final String category;
  final String? description;
  final List<String>? requirements;
  final List<String>? hastags;
  final String ownerId;
  final String ownerName;
  final double ownerRating;
  final String? ownerImagePath;

  const ProjectEntity({
    required this.id,
    required this.name,
    this.detailAddress,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.distance,
    required this.category,
    this.description,
    this.requirements,
    this.hastags,
    required this.ownerName,
    required this.ownerRating,
    this.ownerImagePath,
    required this.ownerId,
    required this.maxParticipant,
    required this.currentParticipant,
  });

  ProjectEntity copyWith({
    final String? name,
    final String? detailAddress,
    final double? latitude,
    final double? longitude,
    final ProjectStatus? status,
    final double? distance,
    final int? maxParticipant,
    final int? currentParticipant,
    final String? category,
    final String? description,
    final List<String>? requirements,
    final List<String>? hastags,
    final String? ownerId,
    final String? ownerName,
    final double? ownerRating,
    final String? ownerImagePath,
  }) {
    return ProjectEntity(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      detailAddress: detailAddress ?? this.detailAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      distance: distance ?? this.distance,
      currentParticipant: currentParticipant ?? this.currentParticipant,
      maxParticipant: maxParticipant ?? this.maxParticipant,
      category: category ?? this.category,
      hastags: hastags ?? this.hastags,
      requirements: requirements ?? this.requirements,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      ownerRating: ownerRating ?? this.ownerRating,
      ownerImagePath: ownerImagePath ?? this.ownerImagePath,
    );
  }

  static ProjectEntity dummyProject() {
    return const ProjectEntity(
      id: 'dummy',
      name: 'Judul Project Skeleton',
      detailAddress: 'Blok A No. 123',
      latitude: -6.2088,
      longitude: 106.8456,
      status: ProjectStatus.hiring,
      currentParticipant: 1,
      maxParticipant: 10,
      distance: 10000,
      ownerId: 'fasdfnasf',
      ownerImagePath: null,
      category: 'Kategori Dummy',
      ownerName: 'Nama Owner Skeleton',
      ownerRating: 5.0,
      description:
          '''Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam egestas velit enim, sit amet dapibus libero elementum at. Quisque sit amet felis at eros tincidunt efficitur sed sed nibh. Mauris quis lacus a est elementum luctus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Pellentesque vel tristique ex. Praesent tincidunt enim in orci pharetra, vitae iaculis mi pulvinar. Praesent sed risus a ex dapibus interdum eu in purus. Maecenas varius tempor tincidunt. Donec pulvinar, elit et egestas dignissim, ligula metus semper est, et semper libero metus vitae orci. Aliquam feugiat ac ante at sollicitudin. Duis nulla nibh, venenatis sit amet velit sit amet, hendrerit consequat orci. Nam blandit augue eget magna mattis dignissim. Sed convallis lorem eu orci efficitur, sit amet convallis tortor placerat. Donec ac pretium sem. Aenean nulla mi, rutrum ac tempus at, pharetra sed tortor. ''',
      hastags: ['skeleton', 'loading'],
      requirements: [
        "requirement yang pertama first ichi 1",
        "requirement yang pertama first ichi 2",
        "requirement yang pertama first ichi 3",
        "requirement yang pertama first ichi 4",
        "requirement yang pertama first ichi 5",
      ],
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    detailAddress,
    latitude,
    longitude,
    status,
    distance,
    category,
    hastags,
    requirements,
    ownerName,
    ownerRating,
    ownerImagePath,
    ownerId,
    currentParticipant,
    maxParticipant,
  ];
}
