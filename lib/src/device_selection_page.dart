import 'package:doctor_mfc/constants.dart';
import 'package:doctor_mfc/models/system.dart';
import 'package:doctor_mfc/services/database.dart';
import 'package:doctor_mfc/src/component_selection_page.dart';
import 'package:doctor_mfc/widgets/device_selection_widget.dart';
import 'package:doctor_mfc/widgets/page_template.dart';
import 'package:flutter/material.dart';

import 'package:doctor_mfc/models/device_type.dart';

class DeviceSelectionPage extends StatefulWidget {
  DeviceSelectionPage({Key? key}) : super(key: key);

  @override
  _DeviceSelectionPageState createState() => _DeviceSelectionPageState();
}

class _DeviceSelectionPageState extends State<DeviceSelectionPage> {
  @override
  Widget build(BuildContext context) {
    final deviceType = ModalRoute.of(context)!.settings.arguments as DeviceType;

    return PageTemplate(
      title: 'Select the failing device',
      children: [
        SizedBox(height: kDefaultPadding * 1.5),
        cantFindDeviceText(),
        requestAdditionButton(),
        SizedBox(height: kDefaultPadding * 2),
        deviceTypeText(),
        SizedBox(height: kDefaultPadding),
        Container(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: FutureBuilder<List<System>>(
            future: Database().getSystemsByType(deviceType.description),
            builder: (context, snapshot) {
              if (snapshot.hasData == false) {
                return Center(
                  child: CircularProgressIndicator(
                    color: kSecondaryLightColor,
                  ),
                );
              } else {
                List<System> systems = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: systems.length,
                  itemBuilder: (context, i) {
                    return deviceSelector(systems[i]);
                  },
                );
              }
            },
          ),
        )
      ],
    );
  }

  Row deviceSelector(System system) {
    return Row(
      children: [
        CircleAvatar(
          radius: 5,
          backgroundColor: kSecondaryLightColor,
        ),
        SizedBox(width: kDefaultPadding),
        DeviceSelectionWidget(
          text: system.description,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ComponentSelectionPage(system),
              ),
            );
          },
        ),
      ],
    );
  }

  Center deviceTypeText() {
    final args = ModalRoute.of(context)!.settings.arguments as DeviceType;

    return Center(
      child: Text(
        '${args.description}',
        style: Theme.of(context).textTheme.headline3,
      ),
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
      Center(child: Text("Can't find the device you are looking for?"));
}
