import 'package:doctor_mfc/constants.dart';
import 'package:doctor_mfc/models/search_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

/// This is the container for the search results.
///
/// The search result's content will depend on the type of result.
class SearchResultContainer extends StatefulWidget {
  final SearchResult result;
  const SearchResultContainer(
    this.result, {
    Key? key,
  }) : super(key: key);

  @override
  State<SearchResultContainer> createState() => _SearchResultContainerState();
}

class _SearchResultContainerState extends State<SearchResultContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(kDefaultPadding),
        constraints: BoxConstraints(
          minHeight: 80.00,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.result.description,
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: kDefaultPadding / 2),
                  ...body()
                ],
              ),
            ),
            Flexible(
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black38,
              ),
            ),
          ],
        ),
      ),
      onTap: () => Navigator.of(context, rootNavigator: true).pushNamed(
        'searchResult',
        arguments: widget.result,
      ),
    );
  }

  List<Widget> body() {
    SearchResult result = widget.result;

    if (result is DocumentationSearchResult) {
      print(result.attachment.systemBrand);
      return [
        Text(
          '${result.attachment.systemBrand!} ${result.attachment.systemDescription!}',
          style: Theme.of(context).textTheme.caption,
        ),
        // Text(
        //   widget.result.description,
        //   style: TextStyle(color: kFontBlack.withOpacity(0.7)),
        // ),
      ];
    } else if (result is GuideSearchResult) {
      return [
        Text(
          '${result.description}',
          style: TextStyle(
            color: kFontBlack.withOpacity(0.7),
          ),
        ),
        // SizedBox(height: kDefaultPadding / 2),
        // Text(
        //   '${(widget.result as ProblemSearchResult).systemBrand} ${(widget.result as ProblemSearchResult).systemDescription}',
        //   style: TextStyle(
        //     color: kFontBlack.withOpacity(0.7),
        //   ),
        // ),
      ];
    } else if (result is ProblemSearchResult) {
      return [
        Text(
          '${result.description}',
          style: TextStyle(
            color: kFontBlack.withOpacity(0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: kDefaultPadding / 2),
        Text(
          '${result.systemBrand} ${result.systemDescription}',
          style: TextStyle(
            color: kFontBlack.withOpacity(0.7),
          ),
        ),
      ];
    } else {
      throw Exception('Unknown search result type');
    }
  }
}
