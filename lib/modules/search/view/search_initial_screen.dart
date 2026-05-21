import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:sejasa/core/routes/route_named.dart';
import 'package:sejasa/core/widgets/my_text_field.dart';
import 'package:sejasa/modules/search/bloc/search_bloc.dart';
import 'package:sejasa/modules/search/bloc/search_event.dart';
import 'package:sejasa/modules/search/bloc/search_state.dart';

class SearchInitialScreen extends HookWidget {
  const SearchInitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchBloc = context.read<SearchBloc>();
    final focusNode = useFocusNode();
    final controller = useTextEditingController();

    useEffect(() {
      focusNode.requestFocus();
      return null;
    }, []);

    void onSearch(String keyword) {
      if (keyword.trim().isNotEmpty) {
        searchBloc.add(PerformSearch(keyword.trim()));
        context.pushNamed(RouteNamed.searchResult);
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
            focusNode: focusNode,
            controller: controller,
            textInputAction: TextInputAction.search,
            onChanged: (val) {
              searchBloc.add(SearchKeywordChanged(val));
            },
            onFieldSubmitted: onSearch,
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
          if (state.history.isEmpty) {
            return const Center(child: Text("Belum ada riwayat pencarian"));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Riwayat Pencarian",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => searchBloc.add(ClearHistory()),
                      child: const Text("Hapus Semua"),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.history.length,
                  itemBuilder: (context, index) {
                    final item = state.history[index];
                    return ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(item),
                      trailing: const Icon(Icons.north_west, size: 16),
                      onTap: () {
                        searchBloc.add(PerformSearch(item));
                        context.pushNamed(RouteNamed.searchResult);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
