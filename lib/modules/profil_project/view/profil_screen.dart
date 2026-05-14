import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:sejasa/modules/profil_project/bloc/profil_project_bloc.dart';
import 'package:sejasa/modules/profil_project/bloc/profil_project_event.dart';
import 'package:sejasa/modules/profil_project/bloc/profil_project_state.dart';
import 'package:sejasa/core/widgets/build_project_list_widget.dart';
import 'package:sejasa/core/widgets/profil_information.dart';

class ProfilScreen extends HookWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabBarController = useTabController(initialLength: 3);
    final theme = Theme.of(context);

    final profilBloc = context.read<ProfilProjectBloc>();

    useEffect(() {
      profilBloc.add(LoadMyUploadedProjects());
      profilBloc.add(LoadMyTakenProjects());
      profilBloc.add(LoadAllMyProjects());
      return null;
    }, []);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              leading: FlutterLogo(),
              title: Text("SeJasa"),
              floating: true,
              snap: true,
              pinned: true,
              surfaceTintColor: Colors.transparent,
              actions: [
                IconButton.filled(
                  onPressed: () {},
                  icon: Icon(
                    LucideIcons.bookmark,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(width: 8), 
                // Tombol Share
                IconButton.filled(
                  onPressed: () {},
                  icon: Icon(
                    LucideIcons.share2,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(width: 8), 
                // Tombol Edit
                IconButton.filled(
                  onPressed: () {},
                  icon: Icon(
                    LucideIcons.pencil,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(width: 8), 
                // Tombol Setelan / Opsi
                IconButton.filled(
                  onPressed: () {},
                  icon: Icon(
                    LucideIcons.settings,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                // Memberi sedikit jarak di tepi kanan agar tidak terlalu menempel ke layar
                const SizedBox(width: 8), 
              ],
            ),

            SliverToBoxAdapter(
              child: UserProfileHeaderWidget(),
            ),

            SliverAppBar(
              pinned: true,
              primary: false,
              toolbarHeight: 0, // Sembunyikan area toolbar default
              surfaceTintColor: theme.scaffoldBackgroundColor,
              backgroundColor: theme.scaffoldBackgroundColor,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: TabBar(
                  controller: tabBarController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(text: "Semua"),
                    Tab(text: "Diselesaikan"),
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
              return Center(child: Text("Error: ${state.message}"));
            } else {
              return TabBarView(
                controller: tabBarController,
                children: [
                  BuildProjectListWidget(
                    projects: state.takenProjects,
                    onRefresh: () async {
                      profilBloc.add(LoadMyTakenProjects());
                    },
                    isLoading:
                        state.status != ProfilProjectStatus.error &&
                        state.isFetchingProjectTaken,
                  ),
                  BuildProjectListWidget(
                    projects: state.takenProjects,
                    onRefresh: () async {
                      profilBloc.add(LoadMyTakenProjects());
                    },
                    isLoading:
                        state.status != ProfilProjectStatus.error &&
                        state.isFetchingProjectTaken,
                  ),
                  BuildProjectListWidget(
                    projects: state.uploadedProjects,
                    isMyProjects: true,
                    onRefresh: () async {
                      profilBloc.add(LoadMyUploadedProjects());
                    },
                    isLoading:
                        state.status != ProfilProjectStatus.error &&
                        state.isFetchingProjectUploaded,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}