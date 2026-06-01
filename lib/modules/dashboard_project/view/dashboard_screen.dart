import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:sejasa/core/routes/route_named.dart';
import 'package:sejasa/core/widgets/logo_widget.dart';
import 'package:sejasa/core/widgets/my_outline_button.dart';
import 'package:sejasa/modules/dashboard_project/bloc/dashboard_project_bloc.dart';
import 'package:sejasa/modules/dashboard_project/bloc/dashboard_project_event.dart';
import 'package:sejasa/modules/dashboard_project/bloc/dashboard_project_state.dart';
import 'package:sejasa/core/widgets/build_project_list_fetch_page_widget.dart';
import 'package:sejasa/modules/auth/bloc/auth_bloc.dart';
import 'package:sejasa/modules/auth/bloc/auth_state.dart';
import 'package:sejasa/modules/dashboard_project/widgets/location_picker_trigger.dart';
import 'package:sejasa/core/widgets/global_location_picker_sheet.dart';

class DashboardScreen extends HookWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabBarController = useTabController(initialLength: 3);
    final theme = Theme.of(context);

    final dashboardBloc = context.read<DashboardProjectBloc>();
    final authBloc = context.read<AuthBloc>();

    useEffect(() {
      // Handle initial location for authenticated users
      final authState = authBloc.state;
      if (authState.user != null) {
        dashboardBloc.add(
          UpdateDashboardLocationEvent(
            latitude: authState.user!.latitude,
            longitude: authState.user!.longitude,
            address: authState.user!.address ?? "Lokasi Anda",
          ),
        );
      }

      dashboardBloc.add(
        LoadInitialProjectsEvent(tabType: DashboardProjectTabType.latest),
      );
      dashboardBloc.add(
        LoadInitialProjectsEvent(tabType: DashboardProjectTabType.popular),
      );
      return null;
    }, []);

    void showLocationPicker() {
      showGlobalLocationPicker(
        context: context,
        initialLocation: dashboardBloc.state.latitude != null
            ? LatLng(
                dashboardBloc.state.latitude!,
                dashboardBloc.state.longitude!,
              )
            : null,
        initialAddress: dashboardBloc.state.address,
        onLocationSelected: (location, address) {
          dashboardBloc.add(
            UpdateDashboardLocationEvent(
              latitude: location.latitude,
              longitude: location.longitude,
              address: address,
            ),
          );
        },
      );
    }

    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  leading: LogoWidget(),
                  title: Text(
                    "SEJASA",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  floating: true,
                  snap: true,
                  pinned: true,
                  surfaceTintColor: Colors.transparent,
                  actionsPadding: EdgeInsets.symmetric(horizontal: 8.w),
                  actions: [
                    IconButton.filled(
                      onPressed: () {
                        context.pushNamed(RouteNamed.searchInitial);
                      },
                      icon: Icon(
                        LucideIcons.search,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    if (authState.user == null)
                      MyOutlineButton(
                        onPressed: () {
                          context.pushNamed(RouteNamed.login);
                        },
                        child: const Text("Masuk"),
                      ),
                  ],
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(50.h),
                    child: SizedBox(
                      height: 50.h,
                      child: Row(
                        spacing: 4.w,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: TabBar(
                              controller: tabBarController,
                              isScrollable: true,
                              tabAlignment: TabAlignment.start,
                              splashBorderRadius: BorderRadius.only(
                                topRight: Radius.circular(8.r),
                                topLeft: Radius.circular(8.r),
                              ),
                              dividerColor: Colors.transparent,
                              tabs: const [
                                Tab(text: "Terdekat"),
                                Tab(text: "Terbaru"),
                                Tab(text: "Terpopuler"),
                              ],
                            ),
                          ),
                          BlocBuilder<
                            DashboardProjectBloc,
                            DashboardProjectState
                          >(
                            builder: (context, state) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  top: 6.h,
                                  bottom: 6.h,
                                  right: 8.w,
                                ),
                                child: LocationPickerTrigger(
                                  address: state.address ?? "Pilih Lokasi",
                                  onTap: showLocationPicker,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: BlocBuilder<DashboardProjectBloc, DashboardProjectState>(
              builder: (context, state) {
                if (state.status == DashboardProjectStatus.error) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.alertTriangle,
                          size: 64.r,
                          color: Colors.red,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          "Terjadi kesalahan",
                          style: theme.textTheme.titleLarge,
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: Text(
                            state.message ??
                                "Terjadi kesalahan yang tidak diketahui",
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        ElevatedButton.icon(
                          onPressed: () {
                            dashboardBloc.add(
                              const LoadInitialProjectsEvent(
                                tabType: DashboardProjectTabType.latest,
                              ),
                            );
                            dashboardBloc.add(
                              const LoadInitialProjectsEvent(
                                tabType: DashboardProjectTabType.popular,
                              ),
                            );
                            if (state.latitude != null &&
                                state.longitude != null) {
                              dashboardBloc.add(
                                const LoadInitialProjectsEvent(
                                  tabType: DashboardProjectTabType.closest,
                                ),
                              );
                            }
                          },
                          icon: const Icon(LucideIcons.refreshCw),
                          label: const Text("Muat Ulang"),
                        ),
                      ],
                    ),
                  );
                } else {
                  return TabBarView(
                    controller: tabBarController,
                    children: [
                      state.latitude == null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    LucideIcons.mapPinOff,
                                    size: 64.r,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16.h),
                                  Text(
                                    "Lokasi belum ditentukan",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  const Text(
                                    "Tentukan lokasi Anda untuk melihat project terdekat",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(height: 24.h),
                                  ElevatedButton.icon(
                                    onPressed: showLocationPicker,
                                    icon: const Icon(LucideIcons.mapPin),
                                    label: const Text("Pilih Lokasi"),
                                  ),
                                ],
                              ),
                            )
                          : BuildProjectListFetchPageWidget(
                              projects: state.closest.projects,
                              hasReachedMax: state.closest.hasReachedMax,
                              isFetchingMore: state.closest.isFetchingMore,
                              isLoading: state.closest.isFetchingInitial,
                              onRefresh: () async {
                                dashboardBloc.add(
                                  LoadInitialProjectsEvent(
                                    tabType: DashboardProjectTabType.closest,
                                  ),
                                );
                              },
                              onLoadMore: () {
                                dashboardBloc.add(
                                  LoadMoreProjectsEvent(
                                    tabType: DashboardProjectTabType.closest,
                                  ),
                                );
                              },
                            ),
                      BuildProjectListFetchPageWidget(
                        projects: state.latest.projects,
                        hasReachedMax: state.latest.hasReachedMax,
                        isFetchingMore: state.latest.isFetchingMore,
                        isLoading: state.latest.isFetchingInitial,
                        onRefresh: () async {
                          dashboardBloc.add(
                            LoadInitialProjectsEvent(
                              tabType: DashboardProjectTabType.latest,
                            ),
                          );
                        },
                        onLoadMore: () {
                          dashboardBloc.add(
                            LoadMoreProjectsEvent(
                              tabType: DashboardProjectTabType.latest,
                            ),
                          );
                        },
                      ),
                      BuildProjectListFetchPageWidget(
                        projects: state.popular.projects,
                        hasReachedMax: state.popular.hasReachedMax,
                        isFetchingMore: state.popular.isFetchingMore,
                        isLoading: state.popular.isFetchingInitial,
                        onRefresh: () async {
                          dashboardBloc.add(
                            LoadInitialProjectsEvent(
                              tabType: DashboardProjectTabType.popular,
                            ),
                          );
                        },
                        onLoadMore: () {
                          dashboardBloc.add(
                            LoadMoreProjectsEvent(
                              tabType: DashboardProjectTabType.popular,
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
