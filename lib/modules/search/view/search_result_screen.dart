import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:sejasa/core/widgets/my_text_field.dart';
import 'package:sejasa/core/widgets/project_item_widget.dart';
import 'package:sejasa/modules/search/bloc/search_bloc.dart';
import 'package:sejasa/modules/search/bloc/search_event.dart';
import 'package:sejasa/modules/search/bloc/search_state.dart';
import 'package:sejasa/modules/search/widgets/project_filter_bottom_sheet.dart';
import 'package:sejasa/modules/search/widgets/user_item_widget.dart';

class SearchResultScreen extends HookWidget {
  const SearchResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchBloc = context.read<SearchBloc>();
    final controller = useTextEditingController(
      text: searchBloc.state.lastKeyword,
    );

    void onSearch(String keyword) {
      if (keyword.trim().isNotEmpty) {
        searchBloc.add(PerformSearch(keyword.trim()));
      }
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leadingWidth: 40,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: MyTextField(
            title: "",
            hint: "Cari...",
            controller: controller,
            textInputAction: TextInputAction.search,
            onChanged: (val) {
              searchBloc.add(SearchKeywordChanged(val));
            },
            onFieldSubmitted: onSearch,
            isClearable: false,
            suffixIcon: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                return IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => BlocProvider.value(
                        value: searchBloc,
                        child: ProjectFilterBottomSheet(
                          initialSort: state.selectedSort,
                          initialStatus: state.selectedStatus,
                          initialCategory: state.selectedCategory,
                          onApply: (sort, status, category) {
                            searchBloc.add(
                              ApplyProjectFilter(
                                sort: sort,
                                status: status,
                                category: category,
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                  icon: Icon(LucideIcons.listFilter),
                );
              },
            ),
          ),
        ),
        actions: [
          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              return DropdownButton<bool>(
                value: state.isProject,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: true, child: Text("Proyek")),
                  DropdownMenuItem(value: false, child: Text("User")),
                ],
                onChanged: (val) {
                  if (val != null) {
                    searchBloc.add(SearchTypeChanged(val));
                    if (state.lastKeyword.isNotEmpty) {
                      searchBloc.add(PerformSearch(state.lastKeyword));
                    }
                  }
                },
              );
            },
          ),

          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state.status == SearchStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == SearchStatus.success) {
            if (state.isProject) {
              if (state.projectResults.isEmpty) {
                return const Center(child: Text("Hasil tidak ditemukan"));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.projectResults.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return ProjectItemWidget(
                    project: state.projectResults[index],
                  );
                },
              );
            } else {
              if (state.userResults.isEmpty) {
                return const Center(child: Text("Hasil tidak ditemukan"));
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.userResults.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return UserItemWidget(user: state.userResults[index]);
                },
              );
            }
          }

          if (state.status == SearchStatus.failure) {
            return Center(
              child: Text(state.errorMessage ?? "Terjadi kesalahan"),
            );
          }

          return const Center(child: Text("Mulai mencari..."));
        },
      ),
      // bottomNavigationBar: BlocBuilder<SearchBloc, SearchState>(
      //   builder: (context, state) {
      //     if (!state.isProject) return const SizedBox.shrink();
      //     return SafeArea(
      //       child: Padding(
      //         padding: const EdgeInsets.symmetric(
      //           horizontal: 16.0,
      //           vertical: 8.0,
      //         ),
      //         child: Row(
      //           children: [
      //             OutlinedButton(
      //               style: OutlinedButton.styleFrom(
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(8),
      //                 ),
      //                 padding: const EdgeInsets.all(12),
      //               ),
      //               onPressed: () {},
      //               child: const Icon(LucideIcons.chevronDown),
      //             ),
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
