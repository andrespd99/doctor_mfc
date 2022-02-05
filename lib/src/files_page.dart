import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_mfc/constants.dart';
import 'package:doctor_mfc/models/attachment.dart';
import 'package:doctor_mfc/models/enum/attachment_types.dart';
import 'package:doctor_mfc/models/search_result.dart';
import 'package:doctor_mfc/models/system.dart';
import 'package:doctor_mfc/services/database.dart';
import 'package:doctor_mfc/services/search_engine.dart';
import 'package:doctor_mfc/src/pdf_viewer_page.dart';
import 'package:doctor_mfc/widgets/page_template.dart';
import 'package:doctor_mfc/widgets/search_result_container.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

enum FileType {
  DOCUMENTATION,
  GUIDE,
}

/// FilesPage is a general Widget for both Documentation a Guides Page.
class FilesPage extends StatefulWidget {
  final FileType fileType;

  FilesPage(this.fileType, {Key? key}) : super(key: key);

  @override
  _FilesPageState createState() => _FilesPageState();
}

class _FilesPageState extends State<FilesPage> {
  late final String pageTitle =
      widget.fileType == FileType.DOCUMENTATION ? 'Documentation' : 'Guides';

  late SearchEngine searchEngine = new SearchEngine();
  final searchBarController = FloatingSearchBarController();
  List<SearchResult> results = [];

  bool showClearButton = false;
  bool loading = false;

  late SearchEntityType searchEntityType;

  @override
  void initState() {
    if (widget.fileType == FileType.DOCUMENTATION) {
      searchEntityType = SearchEntityType.DOCUMENTATION_SEARCH_RESULT;
    } else {
      searchEntityType = SearchEntityType.GUIDE_SEARCH_RESULT;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageTemplate(
            scrollable: true,
            title: pageTitle,
            children: [
              SizedBox(height: kDefaultPadding * 3),
              StreamBuilder<QuerySnapshot<FileAttachment>>(
                stream: widget.fileType == FileType.DOCUMENTATION
                    ? Database().getAllDocumentationSnapshots()
                    : Database().getAllGuidesSnapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<FileAttachment> files =
                        snapshot.data!.docs.map((doc) => doc.data()).toList();

                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: files.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        if (widget.fileType == FileType.DOCUMENTATION)
                          return StreamBuilder<DocumentSnapshot<System?>>(
                            stream: Database()
                                .getSystemByIdSnapshot(files[i].systemId!),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                System system = snapshot.data!.data()!;
                                return fileCard(
                                  file: files[i],
                                  body: Text(
                                      '${system.brand} ${system.description}'),
                                );
                              } else
                                return Container();
                            },
                          );
                        else
                          return fileCard(file: files[i]);
                      },
                      separatorBuilder: (context, i) =>
                          SizedBox(height: kDefaultPadding),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              SizedBox(height: kDefaultPadding * 3),
            ],
          ),
          buildFloatingSearchBar(),
        ],
      ),
    );
  }

  Widget fileCard({required FileAttachment file, Widget? body}) {
    return GestureDetector(
      onTap: () => openFile(file),
      child: Container(
        height: 85.0,
        padding: EdgeInsets.all(kDefaultPadding * 0.90),
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(file.title,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(color: kSecondaryLightColor)),
            Spacer(),
            if (body != null) body,
          ],
        ),
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
            .searchWithEntityTypeFacetFilter(
              query,
              searchEntityType,
            )
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
          child: ListView.separated(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: results.length,
            itemBuilder: (context, i) => SearchResultContainer(results[i]),
            separatorBuilder: (context, i) =>
                SizedBox(height: kDefaultPadding / 2),
          ),
        );
      },
    );
  }

  void openFile(FileAttachment file) {
    pushNewScreen(context,
        screen: PDFViewerCachedFromUrl(
          title: file.title,
          url: file.fileUrl,
        ),
        withNavBar: false);
  }
}
