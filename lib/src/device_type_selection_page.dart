import 'package:doctor_mfc/constants.dart';
import 'package:doctor_mfc/models/device_type.dart';
import 'package:doctor_mfc/services/database.dart';
import 'package:doctor_mfc/widgets/device_selection_widget.dart';
import 'package:doctor_mfc/widgets/page_template.dart';
import 'package:flutter/material.dart';

class DeviceTypeSelectionPage extends StatefulWidget {
  DeviceTypeSelectionPage({Key? key}) : super(key: key);

  @override
  _DeviceTypeSelectionPageState createState() =>
      _DeviceTypeSelectionPageState();
}

class _DeviceTypeSelectionPageState extends State<DeviceTypeSelectionPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return PageTemplate(
      title: 'Select the failing device',
      children: [
        SizedBox(height: kDefaultPadding * 1.5),
        cantFindDeviceText(),
        requestAdditionButton(),
        SizedBox(height: kDefaultPadding * 1.5),
        whatTypeOfDeviceQuestion(),
        SizedBox(height: kDefaultPadding * 0.5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: FutureBuilder<List<String>>(
            future: Database().getSystemTypes(),
            builder: (context, snapshot) {
              if (snapshot.hasData == false) {
                return Center(
                  child: CircularProgressIndicator(
                    color: kSecondaryLightColor,
                  ),
                );
              } else {
                final List<String> systemTypes = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: systemTypes.length,
                  itemBuilder: (context, i) =>
                      deviceTypeSelector(systemTypes[i]),
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
      child: Text('What type of device are you looking for?'),
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

  Widget deviceTypeSelector(String deviceName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DeviceSelectionWidget(
          text: deviceName,
          onTap: () {
            Navigator.pushNamed(
              context,
              'deviceSelection',
              arguments: DeviceType('$deviceName'),
            );
          },
        ),
        SizedBox(height: kDefaultPadding * 0.5),
      ],
    );
  }
}
