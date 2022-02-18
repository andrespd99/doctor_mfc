import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_mfc/constants.dart';
import 'package:doctor_mfc/models/entity_type.dart';
import 'package:doctor_mfc/models/problem.dart';
import 'package:doctor_mfc/models/user_request.dart';
import 'package:doctor_mfc/models/request_type.dart';
import 'package:doctor_mfc/models/solution.dart';
import 'package:doctor_mfc/models/system.dart';
import 'package:doctor_mfc/services/database.dart';
import 'package:doctor_mfc/services/mfc_auth_service.dart';
import 'package:doctor_mfc/widgets/custom_bullet.dart';
import 'package:doctor_mfc/widgets/future_loading_indicator.dart';

import 'package:doctor_mfc/widgets/page_template.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This is the page for user requests where the user selects the type of request
/// and entity they want to change, and shows the fields depending on the user's
/// selection to create the request.
class UserRequestPage extends StatefulWidget {
  UserRequestPage({Key? key}) : super(key: key);

  @override
  State<UserRequestPage> createState() => _UserRequestPageState();
}

class _UserRequestPageState extends State<UserRequestPage> {
  RequestType? selectedRequestType;
  EntityType? selectedEntityType;

  // Controllers for all possible inputs.
  final systemNameController = TextEditingController();
  final systemBrandController = TextEditingController();

  final requestTitleController = TextEditingController();
  final requestDescriptionController = TextEditingController();
  String? selectedSystemId;
  System? selectedSystem;
  String? selectedProblemId;
  Problem? selectedProblem;
  String? selectedSolutionId;
  Solution? selectedSolution;

  bool? formIsValid;

  @override
  void initState() {
    /// Add listeners to the text fields.
    requestTitleController.addListener(() => setState(() {}));
    requestDescriptionController.addListener(() => setState(() {}));
    systemNameController.addListener(() => setState(() {}));
    systemBrandController.addListener(() => setState(() {}));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: 'Request changes',
      scrollable: true,
      children: [
        SizedBox(height: kDefaultPadding),
        ...selectRequestTypeSection(),
        SizedBox(height: kDefaultPadding),
        if (selectedRequestType != null) ...entitiesListSection(),
        SizedBox(height: kDefaultPadding * 1.5),
        if (selectedEntityType != null) ...[
          Text(
            'Request details',
            style: Theme.of(context).textTheme.headline4,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: kDefaultPadding * 1.5),
          ...formWidgets(),
        ],
        SizedBox(height: kDefaultPadding * 3),
      ],
    );
  }

  /// Shows the section for selecting the type of request, which can be either
  /// Add or Update.
  List<Widget> selectRequestTypeSection() {
    return [
      inputDescription('What type of request you want to do?'),
      SizedBox(height: kDefaultPadding / 2),
      requestTypeButton(RequestType.ADD),
      requestTypeButton(RequestType.UPDATE),
    ];
  }

  /// Shows request form widgets, which change depending of the combination
  /// of entity type and request type selected.
  List<Widget> formWidgets() {
    /// If user selects option "add".
    if (selectedRequestType == RequestType.ADD) {
      return [
        /// If user selects to Add System, show system details widget to fill
        /// the information of the system he wants to be added.
        if (selectedEntityType == EntityType.SYSTEM) ...[
          ...systemDetailsSection(),
          SizedBox(height: kDefaultPadding),
        ],

        /// If user selects to Add Problem, show system selector to choose the
        /// system he wants to add the problem to.
        if (selectedEntityType == EntityType.PROBLEM) ...[
          ...systemSelectionWidgets(),
          SizedBox(height: kDefaultPadding),
        ],

        /// If user selects to Add Solution, show system selector to choose the
        /// system, and the problem selector to choose the problem he wants to
        /// add the solution to.
        if (selectedEntityType == EntityType.SOLUTION) ...[
          ...systemSelectionWidgets(),
          SizedBox(height: kDefaultPadding),
          ...problemSelectionWidgets(),
          SizedBox(height: kDefaultPadding),
        ],

        ...titleSection(),
        SizedBox(height: kDefaultPadding),
        ...descriptionSection(),
        SizedBox(height: kDefaultPadding),
        submitButton(),
        SizedBox(height: kDefaultPadding * 3),
      ];
    } else {
      return [
        if (selectedEntityType == EntityType.SYSTEM)
          ...systemSelectionWidgets(),
        if (selectedEntityType == EntityType.PROBLEM) ...[
          ...systemSelectionWidgets(),
          SizedBox(height: kDefaultPadding),
          ...problemSelectionWidgets(),
        ],
        if (selectedEntityType == EntityType.SOLUTION) ...[
          ...systemSelectionWidgets(),
          SizedBox(height: kDefaultPadding),
          ...problemSelectionWidgets(),
          SizedBox(height: kDefaultPadding),
          ...solutionSelectionWidgets(),
        ],
        SizedBox(height: kDefaultPadding),
        ...titleSection(),
        SizedBox(height: kDefaultPadding),
        ...descriptionSection(),
        SizedBox(height: kDefaultPadding),
        submitButton(),
        SizedBox(height: kDefaultPadding * 3),
      ];
    }
  }

  /// Shows a dropdown button to select an existing system.
  List<Widget> systemSelectionWidgets() {
    return [
      inputDescription('Select system'),
      SizedBox(height: kDefaultPadding / 2),
      StreamBuilder<QuerySnapshot<System>>(
        stream: Database().getAllSystemsSnapshots(),
        builder: (context, snapshot) {
          List<System> systems = [];
          if (snapshot.hasData) {
            // When snapshot has loaded, add systems to list.
            systems
                .addAll(snapshot.data!.docs.map((doc) => doc.data()).toList());
          }
          return Container(
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(kDefaultBorderRadius),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String?>(
                  value: selectedSystemId,
                  items: [
                    if (snapshot.hasData) ...systemsDropdownItems(systems)
                  ],
                  onChanged: (systemId) {
                    selectedSystemId = systemId;
                    selectedSystem =
                        systems.firstWhere((system) => system.id == systemId);
                    clearSelectedProblem();
                    setState(() {});
                  },
                ),
              ),
            ),
          );
        },
      ),
    ];
  }

  /// Shows a dropdown to select a problem from the list of problems of the selected system.
  List<Widget> problemSelectionWidgets() {
    return [
      inputDescription('Select problem'),
      SizedBox(height: kDefaultPadding / 2),
      Container(
        constraints: BoxConstraints(minHeight: 60.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<String?>(
              isExpanded: true,
              value: selectedProblemId,
              items: problemsDropdownItems(selectedSystem?.problems),
              // Builder for selected item, with max lines set to 1 in order
              // for it to fit in the dropdown properly.
              selectedItemBuilder: (context) {
                if (selectedSystem == null)
                  return [];
                else
                  return selectedSystem!.problems
                      .map(
                        (problem) => Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            problem.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList();
              },
              onChanged: (problemId) {
                selectedProblemId = problemId;
                selectedProblem = selectedSystem?.problems
                    .firstWhere((problem) => problem.id == problemId);
                clearSelectedSolution();
                setState(() {});
              },
            ),
          ),
        ),
      ),
    ];
  }

  /// Returns a dropdown to select a solution for the problem selected.
  List<Widget> solutionSelectionWidgets() {
    return [
      inputDescription('Select solution'),
      SizedBox(height: kDefaultPadding / 2),
      Container(
        constraints: BoxConstraints(minHeight: 60.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton<String?>(
              isExpanded: true,
              value: selectedSolutionId,
              items: solutionsDropdownItems(selectedProblem?.solutions),
              // Builder for selected item, with max lines set to 1 in order
              // for it to fit in the dropdown properly.
              selectedItemBuilder: (context) {
                if (selectedSolution == null)
                  return [];
                else
                  return selectedProblem!.solutions
                      .map(
                        (solution) => Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            solution.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList();
              },
              onChanged: (solutionId) {
                selectedSolutionId = solutionId;
                selectedSolution = selectedProblem?.solutions
                    .firstWhere((solution) => solution.id == solutionId);
                setState(() {});
              },
            ),
          ),
        ),
      ),
    ];
  }

  /// Input description widget. It's a text with style of `bodyText1`.
  Widget inputDescription(String title) {
    return Text(
      '$title',
      style: Theme.of(context).textTheme.bodyText1,
    );
  }

  /// Shows a list of entities which the user can select from.
  List<Widget> entitiesListSection() {
    String requestTypeToStr =
        (selectedRequestType == RequestType.ADD) ? 'add' : 'update';
    return [
      inputDescription('What do you want to $requestTypeToStr?'),
      entityButton(EntityType.SYSTEM),
      entityButton(EntityType.PROBLEM),
      entityButton(EntityType.SOLUTION),
      if (selectedRequestType == RequestType.ADD)
        entityButton(EntityType.DOCUMENTATION),
      if (selectedRequestType == RequestType.ADD)
        entityButton(EntityType.GUIDE),
    ];
  }

  /// Shows a button to select the request type. This button opacity will change
  /// if the opposite request type is selected.
  Widget requestTypeButton(RequestType type) {
    bool isSelected =
        selectedRequestType == null || selectedRequestType == type;

    String typeToStr = type == RequestType.ADD ? 'Add' : 'Update';
    double opacity = (isSelected) ? 1 : 0.3;

    return InkWell(
      onTap: () => onRequestTypeChanged(type),
      child: Opacity(
        opacity: opacity,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
          child: customTile(
            typeToStr: '$typeToStr content',
            isSelected: isSelected,
            noSelection: selectedEntityType == null,
          ),
        ),
      ),
    );
  }

  /// Shows a button to select the entity type. This button opacity will change
  /// if any other entity type is selected.
  Widget entityButton(EntityType type) {
    bool isSelected = selectedEntityType == null || selectedEntityType == type;

    Map<EntityType, String> typeToStrMap = {
      EntityType.SYSTEM: 'System',
      EntityType.PROBLEM: 'Problem',
      EntityType.SOLUTION: 'Solution',
      EntityType.DOCUMENTATION: 'Documentation',
      EntityType.GUIDE: 'Guide',
    };

    double opacity = (isSelected) ? 1 : 0.3;

    return InkWell(
      onTap: () => onEntityTypeChanged(type),
      child: Opacity(
        opacity: opacity,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
          child: customTile(
            typeToStr: typeToStrMap[type]!,
            isSelected: isSelected,
            noSelection: selectedEntityType == null,
          ),
        ),
      ),
    );
  }

  Widget submitButton() {
    return ElevatedButton(
      child: Text('Submit'),
      onPressed: canSubmit() ? () => onSubmit() : null,
    );
  }

  Row customTile({
    required String typeToStr,
    required bool isSelected,
    required bool noSelection,
  }) {
    return Row(
      children: [
        CustomBullet(),
        SizedBox(width: kDefaultPadding),
        Text(
          '$typeToStr',
          style: TextStyle(
            shadows: <Shadow>[
              if (isSelected && !noSelection)
                Shadow(
                  blurRadius: 10.0,
                  color: kSecondaryColor,
                ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> titleSection() {
    return [
      inputDescription('Title for your request'),
      SizedBox(height: kDefaultPadding / 2),
      TextField(
        controller: requestTitleController,
        maxLines: null,
      ),
    ];
  }

  List<Widget> descriptionSection() {
    return [
      inputDescription('Description for your request'),
      SizedBox(height: kDefaultPadding / 2),
      TextField(
        controller: requestDescriptionController,
        maxLines: null,
        minLines: 3,
      ),
    ];
  }

  /// Shows two textfields; one for system's brand and other for system's name
  List<Widget> systemDetailsSection() {
    return [
      inputDescription('System details'),
      SizedBox(height: kDefaultPadding / 2),
      Column(
        children: [
          TextField(
            controller: systemNameController,
            decoration: InputDecoration(hintText: 'Name'),
          ),
          SizedBox(height: kDefaultPadding / 2),
          TextField(
            controller: systemBrandController,
            decoration: InputDecoration(hintText: 'Brand (optional)'),
          ),
        ],
      ),
    ];
  }

  /// Dropdown items for system selection.
  List<DropdownMenuItem<String?>> systemsDropdownItems(List<System> systems) {
    return systems.map((system) {
      return DropdownMenuItem<String?>(
        value: system.id,
        child: Text(system.description),
      );
    }).toList();
  }

  /// Dropdown items for problem selection.
  List<DropdownMenuItem<String?>> problemsDropdownItems(
      List<Problem>? problems) {
    if (problems == null) {
      return [];
    } else
      return problems.map((problem) {
        return DropdownMenuItem<String?>(
          value: problem.id,
          child: Text(problem.description),
        );
      }).toList();
  }

  /// Dropdown items for solution selection.
  List<DropdownMenuItem<String?>> solutionsDropdownItems(
      List<Solution>? solutions) {
    if (solutions == null) {
      return [];
    } else
      return solutions.map((solution) {
        return DropdownMenuItem<String?>(
          value: solution.id,
          child: Text(solution.description),
        );
      }).toList();
  }

  /// Clears all fields and variables from system-related, to problem-related and solution-related.
  /// This clears:
  /// `selectedSystem`
  /// `selectedSystemId`
  /// `selectedProblem`
  /// `selectedProblemId`
  /// `selectedSolution` and
  /// `selectedSolutionId`
  void clearSelectedSystem() {
    selectedSystem = null;
    selectedSystemId = null;
    selectedProblem = null;
    selectedProblemId = null;
    selectedSolution = null;
    selectedSolutionId = null;
  }

  /// Clears all fields and variables from problem-related and solution-related.
  /// This clears:
  /// `selectedProblem`
  /// `selectedProblemId`
  /// `selectedSolution` and
  /// `selectedSolutionId`
  void clearSelectedProblem() {
    selectedProblem = null;
    selectedProblemId = null;
    selectedSolution = null;
    selectedSolutionId = null;
  }

  /// Clears all fields and variables from solution-related.
  /// This clears:
  /// `selectedSolution` and
  /// `selectedSolutionId`
  void clearSelectedSolution() {
    selectedSolution = null;
    selectedSolutionId = null;
  }

  void clearAllFields() {
    requestTitleController.clear();
    requestDescriptionController.clear();
    systemNameController.clear();
    systemBrandController.clear();
    clearSelectedSystem();
  }

  /// Fired when request type is changed.
  void onRequestTypeChanged(RequestType type) {
    selectedRequestType = type;
    selectedEntityType = null;
    clearAllFields();
    setState(() {});
  }

  /// Fired when entity type is changed.
  void onEntityTypeChanged(EntityType type) {
    selectedEntityType = type;
    clearAllFields();
    setState(() {});
  }

  /// Checks, depending on the selected request type and entity type, if all the
  /// shown fields are filled.
  bool canSubmit() {
    // Assert that the selected request type and entity type are not null.
    assert(selectedRequestType != null && selectedEntityType != null);

    /// Title and description of the request has to be filled, always.
    if (requestTitleController.text.isEmpty ||
        requestDescriptionController.text.isEmpty) {
      return false;
    }
    if (selectedRequestType == RequestType.ADD) {
      // If the request is to add a system, all system information has to be filled.
      if (selectedEntityType == EntityType.SYSTEM) {
        if (systemNameController.text.isEmpty) {
          return false;
        } else
          return true;
      } else if (selectedEntityType == EntityType.PROBLEM) {
        // If the request is to add a problem to a system, a system has to be selected.
        if (selectedSystem == null) {
          return false;
        } else
          return true;
      } else if (selectedEntityType == EntityType.SOLUTION) {
        // If the request is to add a solution, a system  and a problem have to
        // be selected.
        if (selectedSystem == null || selectedProblem == null) {
          return false;
        } else
          return true;
      } else
        // If entity type is documentation or guide, no further checks are needed.
        return true;
    } else if (selectedRequestType == RequestType.UPDATE) {
      /// If the request is to update a system, a system has to be selected.
      if (selectedEntityType == EntityType.SYSTEM) {
        if (selectedSystem == null) {
          return false;
        } else
          return true;
        // If the request is to update a problem, a system and a problem have to
        // be selected.
      } else if (selectedEntityType == EntityType.PROBLEM) {
        if (selectedSystem == null || selectedProblem == null) {
          return false;
        } else
          return true;
        // If the request is to update a solution, a system, a problem and a solution
        // have to be selected.
      } else if (selectedEntityType == EntityType.SOLUTION) {
        if (selectedSystem == null ||
            selectedProblem == null ||
            selectedSolution == null) {
          return false;
        } else
          return true;
      } else

        /// As documentation and guide are not an option when the request type
        /// is update, should throw an error.
        throw Exception('Invalid entity type');
    } else
      // If request type is not add or update, should throw an error.
      throw Exception('Invalid request type');
  }

  /// Submits the request.
  void onSubmit() {
    User? user = Provider.of<MFCAuthService>(context, listen: false).user;
    // Assert current user is not null.
    assert(user != null);

    if (canSubmit()) {
      futureLoadingIndicator(
        context,
        Database().addRequest(
          UserRequest(
            userId: user!.uid,
            userEmail: user.email!,
            requestType: selectedRequestType!,
            entityType: selectedEntityType!,
            requestTitle: requestTitleController.text,
            requestDescription: requestDescriptionController.text,
            systemToUpdate: selectedSystem,
            problemToUpdate: selectedProblem,
            solutionToUpdate: selectedSolution,
            systemNameToAdd: systemNameController.text,
            systemBrandToAdd: systemBrandController.text,
          ),
        ),
      ).then((value) {
        clearAllFields();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Request submitted. Thank you.')),
        );
      });
    }
  }
}
