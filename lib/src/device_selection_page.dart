import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_mfc/constants.dart';
import 'package:doctor_mfc/models/device_type.dart';
import 'package:doctor_mfc/models/system.dart';
import 'package:doctor_mfc/services/database.dart';
import 'package:doctor_mfc/src/request_changes_page.dart';
import 'package:doctor_mfc/src/start_point.dart';
import 'package:doctor_mfc/src/systems_problems_list_page.dart';

import 'package:doctor_mfc/widgets/custom_progress_indicator.dart';
import 'package:doctor_mfc/widgets/device_selection_widget.dart';
import 'package:doctor_mfc/widgets/page_template.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

/// Displays the list of systems that the user can select to navigate to in order
/// to see all the problems related to it.
class DeviceSelectionPage extends StatefulWidget {
  static final String routeName = 'deviceTypeSelection';

  DeviceSelectionPage({Key? key}) : super(key: key);

  @override
  _DeviceSelectionPageState createState() => _DeviceSelectionPageState();
}

class _DeviceSelectionPageState extends State<DeviceSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      scrollable: true,
      title: 'Select device',
      children: [
        whatTypeOfDeviceQuestion(),
        SizedBox(height: kDefaultPadding * 1.5),
        body(),
        SizedBox(height: kDefaultPadding * 3),
        cantFindDeviceText(),
        requestAdditionButton(),
      ],
    );
  }

  Container body() {
    return Container(
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
            return ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: systemTypes.length,
              itemBuilder: (context, i) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      systemTypes[i],
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    Divider(color: Colors.white, thickness: 0.3),
                    StreamBuilder<QuerySnapshot<System>>(
                      stream:
                          Database().getSystemsSnapshotsByType(systemTypes[i]),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final systems = snapshot.data?.docs;
                          return ListView.separated(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: systems!.length,
                            itemBuilder: (context, i) =>
                                deviceSelector(systems[i].data()),
                            separatorBuilder: (context, i) =>
                                SizedBox(height: kDefaultPadding),
                          );
                        } else
                          return CustomProgressIndicator();
                      },
                    ),
                  ],
                );
              },
              separatorBuilder: (context, i) =>
                  SizedBox(height: kDefaultPadding),
            );
          }
        },
      ),
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
        child: Text('Request addition'),
        onPressed: () => pushNewScreen(
          context,
          screen: UserRequestPage(),
          withNavBar: false,
        ),
      ),
    );
  }

  Center cantFindDeviceText() => Center(
        child: Text("Can't find the device you are looking for?"),
      );

  Widget deviceTypeSelector(String deviceName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DeviceSelectionWidget(
          text: deviceName,
          onTap: () {
            pushNewScreenWithRouteSettings(
              context,
              settings: RouteSettings(
                name: DeviceSelectionPage.routeName,
                arguments: DeviceType('$deviceName'),
              ),
              screen: DeviceSelectionPage(),
            );
          },
        ),
        SizedBox(height: kDefaultPadding * 0.5),
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
            pushNewScreenWithRouteSettings(
              context,
              settings: RouteSettings(name: SystemsProblemsListPage.routeName),
              screen: SystemsProblemsListPage(system),
              withNavBar: true,
            );
          },
        ),
      ],
    );
  }
}
