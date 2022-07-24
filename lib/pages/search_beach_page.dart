import 'package:blue_waves/api/api_service.dart';
import 'package:blue_waves/constants.dart';
import 'package:blue_waves/generated/l10n.dart';
import 'package:blue_waves/models/beach.dart';
import 'package:blue_waves/pages/components/loader.dart';
import 'package:blue_waves/states/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:string_extensions/string_extensions.dart';

class SearchBeachPage extends StatefulWidget {
  const SearchBeachPage({
    required this.onSearchItemTap,
    Key? key,
  }) : super(key: key);

  final Function(Beach) onSearchItemTap;
  @override
  State<SearchBeachPage> createState() => _SearchBeachPageState();
}

class _SearchBeachPageState extends State<SearchBeachPage> {
  final FocusNode _searchTextFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SizedBox(
            height: constraints.maxHeight,
            width: 1.sw,
            child: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      log.wtf('getting back');
                      Get.back();
                    },
                    child: Container(
                      color: ThemeState.of(context, listen: true).isDark
                          ? kColorBlueDark2
                          : const Color(0xffd8d0a8),
                    ),
                  ),
                ),
                TypeAheadField<Beach>(
                  minCharsForSuggestions: 3,
                  loadingBuilder: (context) => const Loader(),
                  suggestionsBoxVerticalOffset: 0,
                  textFieldConfiguration: TextFieldConfiguration(
                    autofocus: true,
                    focusNode: _searchTextFocus
                      ..addListener(() {
                        if (!_searchTextFocus.hasFocus) {
                          Get.back();
                        }
                      }),
                    style: kStyleDefault.copyWith(
                      color: kColorBlack,
                    ),
                    cursorColor: kColorBlueDark,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                  suggestionsCallback: (pattern) =>
                      Api.instance.searchBeach(name: pattern.replaceGreek!),
                  itemBuilder: (context, Beach suggestion) {
                    return ListTile(
                      tileColor: Colors.white,
                      title: Text(suggestion.name),
                      subtitle: Text(suggestion.nameEn ?? suggestion.name),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(S.current.rating),
                          if (suggestion.averageRating != 0.0)
                            Text(suggestion.averageRating.toString())
                          else
                            const Text('N/A')
                        ],
                      ),
                    );
                  },
                  noItemsFoundBuilder: (c) => ListTile(
                    tileColor: Colors.white,
                    title: Text(S.current.no_beaches_found),
                  ),
                  onSuggestionSelected: (suggestion) async {
                    Get.back();
                    widget.onSearchItemTap(suggestion);
                  },
                  suggestionsBoxDecoration: SuggestionsBoxDecoration(
                    shadowColor: ThemeState.of(context, listen: true).isDark
                        ? const Color(0xffd8d0a8)
                        : kColorBlueDark2.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
