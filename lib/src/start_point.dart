import 'package:doctor_mfc/constants.dart';

import 'package:doctor_mfc/models/search_result.dart';
import 'package:doctor_mfc/services/search_engine.dart';
import 'package:doctor_mfc/src/device_selection_page.dart';
import 'package:doctor_mfc/src/request_changes_page.dart';
import 'package:doctor_mfc/widgets/custom_solution_result_card.dart';
import 'package:doctor_mfc/widgets/page_template.dart';
import 'package:doctor_mfc/widgets/search_result_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class StartPointPage extends StatefulWidget {
  static final routeName = 'startPoint';

  StartPointPage({Key? key}) : super(key: key);

  @override
  _StartPointPageState createState() => _StartPointPageState();
}

class _StartPointPageState extends State<StartPointPage> {
  late SearchEngine searchEngine = new SearchEngine();

  final searchBarController = FloatingSearchBarController();
  bool showClearButton = false;
  bool loading = false;

  String? query;

  List<SearchResult> results = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageTemplate(
            title: 'Tell us your problem',
            children: [
              Spacer(),
              TextButton(
                onPressed: () {
                  pushNewScreenWithRouteSettings(
                    context,
                    settings:
                        RouteSettings(name: DeviceSelectionPage.routeName),
                    screen: DeviceSelectionPage(),
                    withNavBar: true,
                  );
                },
                child: Text('Advanced search'),
              ),
            ],
          ),
          buildFloatingSearchBar(),
        ],
      ),
    );
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      controller: searchBarController,
      backgroundColor: kFontWhite,
      hintStyle: TextStyle(color: kFontBlack.withOpacity(0.5)),
      queryStyle: TextStyle(color: kFontBlack),
      iconColor: kFontBlack.withOpacity(0.5),
      margins: EdgeInsets.only(
        left: kDefaultPadding,
        right: kDefaultPadding,
        top: kDefaultPadding * 4,
      ),
      progress: loading,
      accentColor: kSecondaryColor,
      hint: 'Search...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 240),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: Duration(milliseconds: 250),
      onQueryChanged: (query) {
        this.query = query;
        if (query.isNotEmpty) {
          setState(() {
            loading = true;
            showClearButton = true;
          });
        } else {
          setState(() {
            loading = false;
            showClearButton = false;
          });
        }
        searchEngine
            .searchProblem(query)
            .then(
              (results) => setState(
                () {
                  this.results = results;
                },
              ),
            )
            .whenComplete(() => setState(() => loading = false));
      },

      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      automaticallyImplyBackButton: false,
      leadingActions: [FloatingSearchBarAction.back(showIfClosed: false)],
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.search),
            onPressed: () => searchBarController.open(),
          ),
        ),
        (showClearButton)
            ? FloatingSearchBarAction(
                showIfClosed: false,
                showIfOpened: true,
                child: CircularButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => searchBarController.close(),
                ),
              )
            : Container(),
      ],
      builder: (context, transition) {
        return ClipRRect(
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: results.length,
                itemBuilder: (context, i) => SearchResultContainer(results[i]),
                separatorBuilder: (context, i) =>
                    SizedBox(height: kDefaultPadding / 2),
              ),
              SizedBox(height: kDefaultPadding),
              if (!loading && query != null && query!.isNotEmpty)
                Container(
                    padding: EdgeInsets.all(kDefaultPadding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                      color: Colors.white38,
                    ),
                    child: Column(
                      children: [
                        Text("Can't find what you're looking for?"),
                        TextButton(
                            child: Text('Advanced Search'),
                            onPressed: () {
                              searchBarController.close();
                              pushNewScreen(
                                context,
                                screen: DeviceSelectionPage(),
                                withNavBar: false,
                              );
                            }),
                        TextButton(
                          child: Text('Request an addition'),
                          onPressed: () {
                            searchBarController.close();
                            pushNewScreen(
                              context,
                              screen: RequestChangePage(),
                              withNavBar: false,
                            );
                          },
                        ),
                      ],
                    )),
            ],
          ),
        );
      },
    );
  }
}
