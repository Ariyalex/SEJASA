import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:sejasa/core/di/dependency_injection.dart';
import 'package:sejasa/core/routes/route_named.dart';
import 'package:sejasa/core/services/location_service.dart';
import 'package:sejasa/core/widgets/my_visual_chip.dart';
import 'package:sejasa/core/widgets/project_location_view_sheet.dart';
import 'package:sejasa/domain/entities/project_entity.dart';
import 'package:sejasa/modules/auth/bloc/auth_bloc.dart';
import 'package:sejasa/modules/project_detail/bloc/project_detail_bloc.dart';
import 'package:sejasa/modules/project_detail/bloc/project_detail_event.dart';
import 'package:sejasa/modules/project_detail/bloc/project_detail_state.dart';
import 'package:sejasa/modules/project_detail/widgets/requirement_text_item.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProjectDetailScreen extends HookWidget {
  final String id;
  final bool isOwner;
  final bool isReadMore;
  const ProjectDetailScreen({
    super.key,
    required this.id,
    this.isOwner = false,
    this.isReadMore = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scrollController = useScrollController();

    final projectDetailBloc = context.read<ProjectDetailBloc>();
    final locationService = getIt<LocationService>();

    final seeMoreDescription = useState<bool>(false);
    final isScrolled = useState<bool>(false);

    final project = context.select(
      (ProjectDetailBloc bloc) => bloc.state.project,
    );
    final projectAddressState = useState<String>("");

    useEffect(() {
      if (project != null && project.detailAddress == null) {
        locationService
            .getAddressFromLatLng(
              LatLng(project.latitude, project.longitude),
            )
            .then((value) {
              projectAddressState.value = value;
            });
      } else {
        projectAddressState.value = "";
      }
      return null;
    }, [project?.latitude, project?.longitude, project?.detailAddress]);

    useEffect(() {
      projectDetailBloc.add(
        LoadProject(
          id,
          isAuthenticated:
              context.read<AuthBloc>().state.user != null,
        ),
      );
      return null;
    }, [id]);

    final currentDescription = context.select(
      (ProjectDetailBloc bloc) => bloc.state.project?.description,
    );

    // Quill Controller hook
    final quillController = useMemoized(() {
      final description = projectDetailBloc.state.project?.description;
      late QuillController controller;
      if (description != null) {
        try {
          final doc = Document.fromJson(jsonDecode(description));
          controller = QuillController(
            document: doc,
            selection: const TextSelection.collapsed(offset: 0),
            readOnly: true,
          );
        } catch (_) {
          controller = QuillController.basic()..document.insert(0, description);
        }
      } else {
        controller = QuillController.basic();
      }
      controller.readOnly = true;

      return controller;
    }, [currentDescription]);

    useEffect(() {
      return () => quillController.dispose();
    }, [quillController]);

    useEffect(() {
      void scrollListener() {
        if (scrollController.offset > 50 && !isScrolled.value) {
          isScrolled.value = true;
        } else if (scrollController.offset <= 50 && isScrolled.value) {
          isScrolled.value = false;
        }
      }

      scrollController.addListener(scrollListener);

      return () => scrollController.removeListener(scrollListener);
    }, [scrollController]);

    final hasLongDescription = useMemoized(() {
      final description = projectDetailBloc.state.project?.description;
      if (description == null) return false;

      final plainText = quillController.document.toPlainText();
      final textPainter = TextPainter(
        text: TextSpan(text: plainText, style: theme.textTheme.bodyMedium),
        maxLines: 5,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: MediaQuery.of(context).size.width - 16);

      return textPainter.didExceedMaxLines;
    }, [currentDescription, quillController]);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        shadowColor: theme.focusColor,
        leadingWidth: 50,
        titleSpacing: 4,
        title:
            BlocSelector<ProjectDetailBloc, ProjectDetailState, ProjectEntity?>(
              selector: (state) {
                return state.project;
              },
              builder: (context, project) {
                if (project == null) return SizedBox.shrink();

                if (isScrolled.value) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.name,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge,
                      ),
                      Row(
                        spacing: 4,
                        children: [
                          Icon(Icons.person, size: 18),
                          Expanded(
                            child: Text(
                              project.ownerName,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
                return SizedBox.shrink();
              },
            ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(LucideIcons.share2, color: theme.colorScheme.primary),
          ),
          if (isOwner)
            IconButton(
              onPressed: () {
                context.pushNamed(
                  RouteNamed.editProject,
                  extra: projectDetailBloc.state.project,
                );
              },
              icon: Icon(Icons.edit, color: theme.colorScheme.primary),
            ),
          if (!isOwner)
            IconButton(
              onPressed: () {},
              icon: Icon(LucideIcons.flag, color: theme.colorScheme.error),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          controller: scrollController,
          child: BlocBuilder<ProjectDetailBloc, ProjectDetailState>(
            builder: (context, state) {
              if (state.status == ProjectDetailStatus.error) {
                return Center(child: Text("Terjadi error: ${state.message}"));
              } else {
                final project = state.project ?? ProjectEntity.dummyProject();
                final isSkeleton =
                    state.status != ProjectDetailStatus.success &&
                    state.project == null;

                final projectAddress = project.detailAddress ?? projectAddressState.value;

                return Skeletonizer(
                  enabled: isSkeleton,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.name,
                            style: theme.textTheme.headlineMedium,
                            overflow: TextOverflow.visible,
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.route_outlined,
                                      size: 24,
                                      color: theme.colorScheme.primary,
                                    ),
                                    if (project.distance != null)
                                      Expanded(
                                        child: Text(
                                          "${round(project.distance! / 1000, decimals: 2)} KM",
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.bodyLarge,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer
                                      .withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "${project.currentParticipant}/${project.maxParticipant} Pelamar",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  project.detailAddress ?? projectAddress,
                                  style: theme.textTheme.bodyLarge,
                                ),
                              ),
                              const SizedBox(width: 8),
                              FilledButton.icon(
                                onPressed: () {
                                  showProjectLocationView(
                                    context: context,
                                    projectLocation: LatLng(
                                      project.latitude,
                                      project.longitude,
                                    ),
                                    projectAddress:
                                        project.detailAddress ?? projectAddress,
                                    projectName: project.name,
                                  );
                                },
                                style: FilledButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                                icon: const Icon(LucideIcons.map, size: 16),
                                label: const Text("Lokasi"),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            spacing: 6,
                            children: [
                              MyVisualChip(
                                title: project.status.display,
                                textColor: project.status.getTextColor(theme),
                                backgroundColor: project.status
                                    .getBackgroundColor(theme),
                              ),
                              MyVisualChip(
                                title: project.category.name,
                                backgroundColor: theme.colorScheme.primary
                                    .withValues(alpha: 0.1),
                                textColor: theme.colorScheme.primary,
                              ),
                            ],
                          ),

                          SizedBox(height: 12),
                          Row(
                            spacing: 10,
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundColor: Colors.grey,
                                child: Icon(
                                  Icons.person,
                                  size: 38,
                                  color: Colors.white,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    project.ownerName,
                                    style: theme.textTheme.titleMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    spacing: 6,
                                    children: [
                                      RatingBarIndicator(
                                        itemBuilder: (context, index) {
                                          return Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          );
                                        },
                                        itemCount: 5,

                                        rating: project.ownerRating,
                                        itemSize: 24,
                                      ),
                                      Text(
                                        project.ownerRating.toString(),
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(
                                              color: theme
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Deskripsi", style: theme.textTheme.titleLarge),
                          SizedBox(height: 6),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: ShaderMask(
                              shaderCallback: (rect) {
                                return LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black,
                                    (hasLongDescription &&
                                            !seeMoreDescription.value)
                                        ? Colors.transparent
                                        : Colors.black,
                                  ],
                                  stops: const [0.8, 1.0],
                                ).createShader(
                                  Rect.fromLTRB(0, 0, rect.width, rect.height),
                                );
                              },
                              blendMode: BlendMode.dstIn,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      (hasLongDescription &&
                                          !seeMoreDescription.value)
                                      ? 120
                                      : double.infinity,
                                ),
                                child: QuillEditor.basic(
                                  controller: quillController,
                                  config: const QuillEditorConfig(
                                    readOnlyMouseCursor: MouseCursor.defer,
                                    scrollable: false,
                                    showCursor: false,
                                    autoFocus: false,
                                    expands: false,
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (hasLongDescription && !seeMoreDescription.value)
                            TextButton(
                              style: ButtonStyle(
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      8,
                                    ),
                                  ),
                                ),
                              ),
                              onPressed: () => seeMoreDescription.value = true,
                              child: Text(
                                "Lihat Selengkapnya",
                                style: theme.textTheme.titleMedium!.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Persyaratan",
                            style: theme.textTheme.titleLarge,
                          ),
                          SizedBox(height: 6),
                          Column(
                            children:
                                project.requirements?.map((e) {
                                  return RequirementTextItem(text: e);
                                }).toList() ??
                                [],
                          ),
                        ],
                      ),
                      Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hastags", style: theme.textTheme.titleLarge),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children:
                                project.hastags
                                    ?.map<Widget>(
                                      (e) => MyVisualChip(title: "#$e"),
                                    )
                                    .toList() ??
                                [],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: isReadMore
          ? null
          : SafeArea(
              child: BlocBuilder<ProjectDetailBloc, ProjectDetailState>(
                builder: (context, state) {
                  if (state.status == ProjectDetailStatus.error) {
                    return Center(
                      child: Text("Terjadi error: ${state.message}"),
                    );
                  } else {
                    final bool isSkeleton =
                        state.status != ProjectDetailStatus.success &&
                        state.project == null;

                    // If not owner and not authenticated, hide the button
                    if (!isOwner && !state.isAuthenticated) {
                      return const SizedBox.shrink();
                    }

                    return Skeletonizer(
                      enabled: isSkeleton,
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 12,
                        ),
                        width: double.infinity,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (!isOwner) {
                              context.pushNamed(
                                RouteNamed.chat,
                                pathParameters: {"id": '1'},
                                extra: {
                                  "name": state.project?.ownerName,
                                  "project_id": state.project?.id,
                                },
                              );
                            }
                          },
                          child: Text(
                            isOwner ? "List pelamar" : "Hubungi sekarang",
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
    );
  }
}
