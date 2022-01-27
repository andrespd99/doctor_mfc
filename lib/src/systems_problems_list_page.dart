import 'package:doctor_mfc/constants.dart';
import 'package:doctor_mfc/models/attachment.dart';
import 'package:doctor_mfc/models/system.dart';
import 'package:doctor_mfc/services/database.dart';
import 'package:doctor_mfc/src/device_documentation_page.dart';
import 'package:doctor_mfc/src/solutions_page.dart';
import 'package:doctor_mfc/widgets/bullet.dart';
import 'package:doctor_mfc/widgets/custom_list_tile.dart';
import 'package:doctor_mfc/widgets/page_template.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class SystemsProblemsListPage extends StatefulWidget {
  static final routeName = 'systemsProblemsList';

  final System system;

  SystemsProblemsListPage(this.system, {Key? key}) : super(key: key);

  @override
  State<SystemsProblemsListPage> createState() =>
      _SystemsProblemsListPageState();
}

class _SystemsProblemsListPageState extends State<SystemsProblemsListPage> {
  late System system = widget.system;

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: 'Select problem',
      scrollable: true,
      children: [
        seeDocumentationButton(),
        SizedBox(height: kDefaultPadding * 1.2),
        problemsList(),
        SizedBox(height: kDefaultPadding),
      ],
    );
  }

  Widget seeDocumentationButton() {
    return Container(
      height: 32.0,
      alignment: Alignment.center,
      child: FutureBuilder<List<FileAttachment>>(
        future: Database().getDocumentationBySystemId(system.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty)
              return TextButton(
                child: Text('See documentation'),
                onPressed: () => pushNewScreenWithRouteSettings(
                  context,
                  settings:
                      RouteSettings(name: DeviceDocumentationPage.routeName),
                  screen: DeviceDocumentationPage(
                    system: system,
                    documentationList: snapshot.data!,
                  ),
                ),
              );
            else
              return Text(
                'No documentation available',
                style: Theme.of(context).textTheme.caption,
              );
          } else
            return Text(
              'Looking for documentation...',
              style: Theme.of(context).textTheme.caption,
            );
        },
      ),
    );
  }

  Container problemsList() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: system.problems.length,
        itemBuilder: (context, i) {
          return CustomListTile(
            title: '${system.problems[i].description}',
            onPressed: () => pushNewScreenWithRouteSettings(
              context,
              settings: RouteSettings(name: SolutionsPage.routeName),
              screen: SolutionsPage(system.problems[i]),
              withNavBar: true,
            ),
          );
        },
        separatorBuilder: (context, i) => SizedBox(height: kDefaultPadding),
      ),
    );
  }
}
