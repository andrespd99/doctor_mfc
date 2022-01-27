import 'package:doctor_mfc/constants.dart';
import 'package:doctor_mfc/models/attachment.dart';
import 'package:doctor_mfc/models/system.dart';
import 'package:doctor_mfc/src/pdf_viewer_page.dart';
import 'package:doctor_mfc/widgets/custom_list_tile.dart';
import 'package:doctor_mfc/widgets/page_template.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class DeviceDocumentationPage extends StatefulWidget {
  static final routeName = 'deviceDocumentation';
  final System system;
  final List<FileAttachment> documentationList;

  DeviceDocumentationPage({
    required this.system,
    required this.documentationList,
    Key? key,
  }) : super(key: key);

  @override
  State<DeviceDocumentationPage> createState() =>
      _DeviceDocumentationPageState();
}

class _DeviceDocumentationPageState extends State<DeviceDocumentationPage> {
  late final List<FileAttachment> documentationList = widget.documentationList;
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      scrollable: true,
      title: 'Documentation',
      children: [
        systemDescriptionSubtitle(),
        SizedBox(height: kDefaultPadding),
        ListView.separated(
          shrinkWrap: true,
          itemCount: documentationList.length,
          itemBuilder: (context, i) => CustomListTile(
            title: documentationList[i].title,
            onPressed: () => openDocumentation(documentationList[i]),
          ),
          separatorBuilder: (context, i) => SizedBox(height: kDefaultPadding),
        ),
      ],
    );
  }

  Center systemDescriptionSubtitle() {
    return Center(
      child: Text(
        '${widget.system.brand} ${widget.system.description}',
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  openDocumentation(FileAttachment attachment) {
    pushNewScreen(
      context,
      screen: PDFViewerCachedFromUrl(
          url: attachment.fileUrl, title: attachment.title),
      withNavBar: false,
    );
  }
}
