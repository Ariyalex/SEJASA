import 'package:equatable/equatable.dart';
import 'package:sejasa/data/value_objects/project_status.dart';

class ProjectEntity extends Equatable {
  final String id;
  final String title;
  final String address;
  final String? detailAddress;
  final double? latitude;
  final double? longitude;
  final ProjectStatus status;
  final String distance;
  final String participant;
  final String category;
  final String? description;
  final List<String>? requirements;
  final List<String>? hastags;
  final String ownerName;
  final double ownerRating;
  final String? ownerImagePath;
  final bool isBookmark;

  const ProjectEntity({
    required this.id,
    required this.title,
    required this.address,
    this.detailAddress,
    this.latitude,
    this.longitude,
    required this.status,
    required this.distance,
    required this.participant,
    required this.category,
    this.description,
    this.requirements,
    this.hastags,
    required this.ownerName,
    required this.ownerRating,
    this.ownerImagePath,
    required this.isBookmark,
  });

  ProjectEntity copyWith({
    final String? title,
    final String? address,
    final String? detailAddress,
    final double? latitude,
    final double? longitude,
    final ProjectStatus? status,
    final String? distance,
    final String? participant,
    final String? category,
    final String? description,
    final List<String>? requirements,
    final List<String>? hastags,
    final String? ownerName,
    final double? ownerRating,
    final String? ownerImagePath,
    final bool? isBookmark,
  }) {
    return ProjectEntity(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      address: address ?? this.address,
      detailAddress: detailAddress ?? this.detailAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      distance: distance ?? this.distance,
      participant: participant ?? this.participant,
      category: category ?? this.category,
      hastags: hastags ?? this.hastags,
      requirements: requirements ?? this.requirements,
      ownerName: ownerName ?? this.ownerName,
      ownerRating: ownerRating ?? this.ownerRating,
      ownerImagePath: ownerImagePath ?? this.ownerImagePath,
      isBookmark: isBookmark ?? this.isBookmark,
    );
  }

  static ProjectEntity dummyProject() {
    return const ProjectEntity(
      id: 'dummy',
      title: 'Judul Project Skeleton',
      address: 'Alamat Skeleton, Jakarta',
      detailAddress: 'Blok A No. 123',
      latitude: -6.2088,
      longitude: 106.8456,
      status: ProjectStatus.hiring,
      distance: '10 km',
      participant: '0',
      category: 'Kategori Dummy',
      ownerName: 'Nama Owner Skeleton',
      ownerRating: 5.0,
      isBookmark: false,
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
    title,
    description,
    address,
    detailAddress,
    latitude,
    longitude,
    status,
    distance,
    participant,
    category,
    hastags,
    requirements,
    ownerName,
    ownerRating,
    ownerImagePath,
    isBookmark,
  ];
}
