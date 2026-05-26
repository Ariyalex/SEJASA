import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sejasa/core/routes/route_named.dart';
import 'package:sejasa/core/services/storage_service.dart';
import 'package:sejasa/core/widgets/my_tab_chip.dart';
import 'package:sejasa/domain/entities/user_entity.dart';
import 'package:sejasa/domain/value_objects/gender_type.dart';
import 'package:sejasa/domain/value_objects/project_filter_type.dart';
import 'package:sejasa/modules/auth/bloc/auth_bloc.dart';
import 'package:sejasa/modules/auth/bloc/auth_event.dart';
import 'package:sejasa/modules/profil_project/bloc/profil_project_bloc.dart';
import 'package:sejasa/modules/profil_project/bloc/profil_project_event.dart';
import 'package:sejasa/modules/profil_project/bloc/profil_project_state.dart';
import 'package:sejasa/core/widgets/build_project_list_widget.dart';
import 'package:sejasa/modules/profil_project/widgets/profil_information.dart';

class ProfilScreen extends HookWidget {
  final String userId;
  const ProfilScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    // Dipanggil unconditionally di root build method untuk mematuhi aturan Hooks.
    // Jika isMyProfile == true, controller ini tidak akan dipasang ke TabBar/TabBarView.
    final tabBarController = useTabController(initialLength: 2);
    final theme = Theme.of(context);
    final profilBloc = context.read<ProfilProjectBloc>();
    final isMyProfile = userId == context.watch<AuthBloc>().state.user?.id;

    useEffect(() {
      profilBloc.add(LoadUserProfile(userId, isMyProfile: isMyProfile));
      profilBloc.add(LoadMyUploadedProjects(userId));
      profilBloc.add(LoadMyTakenProjects(userId));
      return null;
    }, [userId, isMyProfile]);

    return BlocBuilder<ProfilProjectBloc, ProfilProjectState>(
      builder: (context, state) {
        final isLoadingUser =
            state.isFetchingUserProfile || state.userProfile == null;

        // Define dummy user for Skeletonizer shimmer
        const dummyUser = UserEntity(
          id: 'dummy',
          name: 'Nama Lengkap Pengguna',
          email: 'email@dummy.com',
          gender: GenderType.male,
          rating: 5.0,
          description:
              'Deskripsi singkat profil pengguna yang memuat keahlian dan informasi lainnya...',
          contact: '081234567890',
          address: 'Alamat lengkap pengguna, Kota, Provinsi',
          latitude: -6.200000,
          longitude: 106.816666,
          skills: [],
        );

        final displayUser = state.userProfile ?? dummyUser;

        if (state.status == ProfilProjectStatus.error &&
            state.userProfile == null) {
          return Scaffold(
            appBar: AppBar(
              leading: isMyProfile
                  ? FlutterLogo()
                  : IconButton(
                      icon: const Icon(LucideIcons.arrowLeft),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
              title: Text(isMyProfile ? "Profile" : "User Profile"),
            ),
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(24.0.r),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.alertTriangle,
                      color: theme.colorScheme.error,
                      size: 48.r,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      state.message ?? "Terjadi kesalahan memuat data",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.error,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton.icon(
                      icon: Icon(LucideIcons.refreshCw, size: 16.r),
                      label: const Text("Coba Lagi"),
                      onPressed: () {
                        profilBloc.add(
                          LoadUserProfile(userId, isMyProfile: isMyProfile),
                        );
                        profilBloc.add(LoadMyUploadedProjects(userId));
                        profilBloc.add(LoadMyTakenProjects(userId));
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Skeletonizer(
          enabled: isLoadingUser,
          child: Scaffold(
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    leading: isMyProfile
                        ? const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: FlutterLogo(),
                          )
                        : IconButton(
                            icon: const Icon(LucideIcons.arrowLeft),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                    title: Text(isMyProfile ? "Profile" : "User Profile"),
                    floating: true,
                    snap: true,
                    pinned: true,
                    actionsPadding: const EdgeInsets.symmetric(horizontal: 8),
                    surfaceTintColor: Colors.transparent,
                    actions: [
                      PopupMenuButton<void>(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            onTap: () {},
                            child: const Row(
                              spacing: 12,
                              children: [
                                Icon(LucideIcons.share2, size: 20),
                                Text("Bagikan"),
                              ],
                            ),
                          ),
                          if (isMyProfile) ...[
                            PopupMenuItem(
                              onTap: () {
                                Future.delayed(Duration.zero, () {
                                  if (!context.mounted) return;
                                  context.pushNamed(RouteNamed.editProfile);
                                });
                              },
                              child: const Row(
                                spacing: 12,
                                children: [
                                  Icon(LucideIcons.pencil, size: 20),
                                  Text("Edit Profil"),
                                ],
                              ),
                            ),
                            const PopupMenuDivider(),
                            PopupMenuItem(
                              onTap: () {
                                // Tap handler for popup menu item: show confirmation dialog
                                Future.delayed(Duration.zero, () {
                                  if (!context.mounted) return;
                                  showDialog<void>(
                                    context: context,
                                    builder: (dialogContext) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        title: const Row(
                                          spacing: 8,
                                          children: [
                                            Icon(
                                              LucideIcons.logOut,
                                              color: Colors.red,
                                            ),
                                            Text(
                                              "Konfirmasi Logout",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        content: const Text(
                                          "Apakah Anda yakin ingin keluar dari akun Anda?",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(
                                              dialogContext,
                                            ).pop(),
                                            child: const Text("Batal"),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              // Ambil references sebelum async gap
                                              final authBloc = context
                                                  .read<AuthBloc>();
                                              final goRouter = GoRouter.of(
                                                context,
                                              );

                                              // Tutup dialog
                                              Navigator.of(dialogContext).pop();

                                              // Ambil refresh token dari StorageService
                                              final storage = context
                                                  .read<StorageService>();
                                              final refreshToken =
                                                  await storage.read(
                                                    'refresh_token',
                                                  ) ??
                                                  '';

                                              // Dispatch AuthLogoutRequested
                                              authBloc.add(
                                                AuthLogoutRequested(
                                                  refreshToken,
                                                ),
                                              );
                                              // Navigasi ke dashboard (/guest)
                                              goRouter.go('/guest');
                                            },
                                            child: const Text(
                                              "Log out",
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              },
                              child: const Row(
                                spacing: 12,
                                children: [
                                  Icon(
                                    LucideIcons.logOut,
                                    size: 20,
                                    color: Colors.red,
                                  ),
                                  Text(
                                    "Log out",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                        icon: Icon(
                          LucideIcons.ellipsisVertical,
                          color: theme.colorScheme.onPrimary,
                        ),
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SliverToBoxAdapter(
                    child: UserProfileHeaderWidget(user: displayUser),
                  ),

                  if (isMyProfile)
                    BlocBuilder<ProfilProjectBloc, ProfilProjectState>(
                      buildWhen: (previous, current) =>
                          previous.filterType != current.filterType,
                      builder: (context, state) {
                        return SliverToBoxAdapter(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Row(
                              children: ProjectFilterType.values.map((filter) {
                                final isSelected = state.filterType == filter;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: MyTabChip(
                                    title: filter.display,
                                    selected: isSelected,
                                    onSelected: (val) {
                                      if (val) {
                                        profilBloc.add(
                                          SetCompletedProjects(filter),
                                        );
                                      }
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    )
                  else
                    SliverAppBar(
                      pinned: true,
                      primary: false,
                      toolbarHeight: 0, // Sembunyikan area toolbar default
                      surfaceTintColor: Colors.transparent,
                      backgroundColor: theme.scaffoldBackgroundColor,
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(48),
                        child: TabBar(
                          controller: tabBarController,
                          indicatorSize: TabBarIndicatorSize.tab,
                          splashBorderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            topLeft: Radius.circular(8),
                          ),
                          tabs: const [
                            Tab(text: "Dikerjakan"),
                            Tab(text: "Diunggah"),
                          ],
                        ),
                      ),
                    ),
                ];
              },

              body: BlocBuilder<ProfilProjectBloc, ProfilProjectState>(
                builder: (context, state) {
                  if (state.status == ProfilProjectStatus.error) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LucideIcons.alertTriangle,
                              color: theme.colorScheme.error,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.message ?? "Terjadi kesalahan memuat data",
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              icon: const Icon(LucideIcons.refreshCw, size: 16),
                              label: const Text("Coba Lagi"),
                              onPressed: () {
                                profilBloc.add(
                                  LoadUserProfile(
                                    userId,
                                    isMyProfile: isMyProfile,
                                  ),
                                );
                                profilBloc.add(LoadMyUploadedProjects(userId));
                                profilBloc.add(LoadMyTakenProjects(userId));
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (isMyProfile) {
                    return BuildProjectListWidget(
                      projects: state.filteredUploadedProjects,
                      isMyProjects: true,
                      onRefresh: () async {
                        profilBloc.add(LoadMyUploadedProjects(userId));
                      },
                      isLoading: state.isFetchingProjectUploaded,
                    );
                  } else {
                    return TabBarView(
                      controller: tabBarController,
                      children: [
                        BuildProjectListWidget(
                          projects: state.takenProjects,
                          onRefresh: () async {
                            profilBloc.add(LoadMyTakenProjects(userId));
                          },
                          isLoading: state.isFetchingProjectTaken,
                        ),
                        BuildProjectListWidget(
                          projects: state.uploadedProjects,
                          onRefresh: () async {
                            profilBloc.add(LoadMyUploadedProjects(userId));
                          },
                          isLoading: state.isFetchingProjectUploaded,
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
