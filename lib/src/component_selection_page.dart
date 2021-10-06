import 'package:doctor_mfc/constants.dart';
import 'package:doctor_mfc/models/component.dart';
import 'package:doctor_mfc/models/device_type.dart';
import 'package:doctor_mfc/models/system.dart';
import 'package:doctor_mfc/services/database.dart';
import 'package:doctor_mfc/src/troubleshooting_questions_page.dart';
import 'package:doctor_mfc/widgets/device_selection_widget.dart';
import 'package:doctor_mfc/widgets/page_template.dart';
import 'package:flutter/material.dart';

class ComponentSelectionPage extends StatefulWidget {
  final System system;

  ComponentSelectionPage(this.system, {Key? key}) : super(key: key);

  @override
  _ComponentSelectionPageSelectionPageState createState() =>
      _ComponentSelectionPageSelectionPageState();
}

class _ComponentSelectionPageSelectionPageState
    extends State<ComponentSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: 'Select the failing part',
      children: [
        SizedBox(height: kDefaultPadding * 1.5),
        cantFindDeviceText(),
        requestAdditionButton(),
        SizedBox(height: kDefaultPadding * 1.5),
        whatTypeOfDeviceQuestion(),
        SizedBox(height: kDefaultPadding * 0.5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: FutureBuilder<List<Component>>(
            future: Database().getComponents(widget.system.componentsIds),
            builder: (context, snapshot) {
              if (snapshot.hasData == false) {
                return Center(
                  child: CircularProgressIndicator(
                    color: kSecondaryLightColor,
                  ),
                );
              } else {
                final List<Component> components = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: components.length,
                  itemBuilder: (context, i) =>
                      deviceTypeSelector(components[i]),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Padding whatTypeOfDeviceQuestion() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Text('Select the component you are looking for'),
    );
  }

  Center requestAdditionButton() {
    return Center(
      child: TextButton(
        onPressed: () {},
        child: Text('Request addition'),
      ),
    );
  }

  Center cantFindDeviceText() =>
      Center(child: Text("Can't find the part you are looking for?"));

  Widget deviceTypeSelector(Component component) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DeviceSelectionWidget(
          text: component.description,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TroubleshootingQuestionsPage(component),
              ),
            );
          },
        ),
        SizedBox(height: kDefaultPadding * 0.5),
      ],
    );
  }
}
