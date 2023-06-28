import 'package:dima_project/Atest_lib/settings_page.dart';
import 'package:dima_project/Atest_lib/widgets/settings/edit_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNavigationObserver extends Mock implements NavigatorObserver {}

MaterialApp app = MaterialApp(
  title: 'Community',
  // Start the app with the "/" named route. In this case, the app starts
  // on the FirstScreen widget.
  initialRoute: '/',
  routes: {
    // When navigating to the "/" route, build the FirstScreen widget.
    '/': (context) => SettingsScreen(switchValue: false, enableNotification: true),
  },
);

MaterialApp appSwitchTrue = MaterialApp(
  title: 'Community',
  // Start the app with the "/" named route. In this case, the app starts
  // on the FirstScreen widget.
  initialRoute: '/',
  routes: {
    // When navigating to the "/" route, build the FirstScreen widget.
    '/': (context) => SettingsScreen(switchValue: true, enableNotification: true),
  },
);

MaterialApp appNotificationFalse = MaterialApp(
  title: 'Community',
  // Start the app with the "/" named route. In this case, the app starts
  // on the FirstScreen widget.
  initialRoute: '/',
  routes: {
    // When navigating to the "/" route, build the FirstScreen widget.
    '/': (context) => SettingsScreen(switchValue: false, enableNotification: false),
  },
);



void main() {
  late TestWidgetsFlutterBinding binding;

  setUp(() {
    binding = TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets("Render Screen", (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final title = find.byKey(Key("Profile"));
    expect(title, findsOneWidget);

    final toggleThemeButton = find.byKey(Key('toggleThemeButton'));
    expect(toggleThemeButton, findsOneWidget);
    await tester.tap(toggleThemeButton);
    await tester.pumpAndSettle(); // toggle theme

    final profilePic = find.byKey(Key("profilePic"));
    expect(profilePic, findsOneWidget);

    final username = find.byKey(Key("username"));
    expect(username, findsOneWidget);

    final email = find.byKey(Key("email"));
    expect(email, findsOneWidget);

    final usernameField = find.byKey(Key("usernameField"));
    expect(usernameField, findsOneWidget);

    final firstNameField = find.byKey(Key("firstNameField"));
    expect(firstNameField, findsOneWidget);

    final lastNameField = find.byKey(Key("lastNameField"));
    expect(lastNameField, findsOneWidget);

    final editButton = find.byKey(Key("editButton"));
    expect(editButton, findsAtLeastNWidgets(3));

    final switchPosition = find.byKey(Key("switchPosition"));
    expect(switchPosition, findsOneWidget);

    final switchChat = find.byKey(Key("switchChat"));
    expect(switchChat, findsOneWidget);
  });


  testWidgets("Open bottom dialog", (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final profilePic = find.byKey(Key("profilePic"));
    expect(profilePic, findsOneWidget);
    await tester.tap(profilePic);
    await tester.pumpAndSettle(); // open bottom dialog

    final camera = find.byKey(Key("camera"));
    expect(camera, findsOneWidget);
    await tester.tap(camera);
    await tester.pumpAndSettle(); // open camera

    final gallery = find.byKey(Key("gallery"));
    expect(gallery, findsOneWidget);
    await tester.tap(gallery);
    await tester.pumpAndSettle(); // open gallery

    final delete = find.byKey(Key("delete"));
    expect(delete, findsOneWidget);

    final cancel = find.byKey(Key("cancel"));
    expect(cancel, findsOneWidget);
    await tester.tap(cancel);
    await tester.pumpAndSettle(); // close bottom dialog
  });

  testWidgets("Delete pic", (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final profilePic = find.byKey(Key("profilePic"));
    expect(profilePic, findsOneWidget);
    await tester.tap(profilePic);
    await tester.pumpAndSettle(); // open bottom dialog

    final delete = find.byKey(Key("delete"));
    expect(delete, findsOneWidget);
    await tester.tap(delete);
    await tester.pumpAndSettle(); // open delete dialog

    final deleteDialog = find.byKey(Key("deleteDialog"));
    expect(deleteDialog, findsOneWidget);

    final deleteButton = find.text('Yes');
    expect(deleteButton, findsOneWidget);

    final cancelButton = find.text('No');
    expect(cancelButton, findsOneWidget);

    await tester.tap(deleteButton);
    await tester.pumpAndSettle(); // delete pic
  });

    testWidgets("Choose avatar", (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final profilePic = find.byKey(Key("profilePic"));
    expect(profilePic, findsOneWidget);
    await tester.tap(profilePic);
    await tester.pumpAndSettle(); // open bottom dialog

    final avatar = find.byKey(Key("avatar"));
    expect(avatar, findsOneWidget);
    await tester.tap(avatar);
    await tester.pumpAndSettle(); // open dialog to choose avatar
    
    final avatar1 = find.text("Avatar1");
    expect(avatar1, findsOneWidget);
    await tester.tap(avatar1);
    await tester.pumpAndSettle(); // choose avatar
  });

  testWidgets("Cancel choose avatar", (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final profilePic = find.byKey(Key("profilePic"));
    expect(profilePic, findsOneWidget);
    await tester.tap(profilePic);
    await tester.pumpAndSettle(); // open bottom dialog

    final avatar = find.byKey(Key("avatar"));
    expect(avatar, findsOneWidget);
    await tester.tap(avatar);
    await tester.pumpAndSettle(); // open dialog to choose avatar
    
    final avatarCloseButton = find.byKey(Key("avatarCloseButton"));
    expect(avatarCloseButton, findsOneWidget);
    await tester.tap(avatarCloseButton);
    await tester.pumpAndSettle(); // close dialog to choose avatar
  });

  testWidgets("Edit field username", (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final editButton = find.byKey(Key("editButton")).first;
    expect(editButton, findsAtLeastNWidgets(1));
    await tester.tap(editButton);
    await tester.pumpAndSettle(); // enable edit field

    final usernameField = find.byKey(Key("usernameField"));
    await tester.enterText(usernameField, "username");
    var enteredText = tester.widget<EditFieldWidget>(usernameField).controller.text;
    expect(enteredText, "username");

    final saveButton = find.byKey(Key("saveButton"));
    expect(saveButton, findsAtLeastNWidgets(1));
    await tester.tap(saveButton);
    await tester.pumpAndSettle(); // save edit field
  });

  testWidgets("Edit field first name", (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final editButton = find.byKey(Key("editButton")).at(1);
    expect(editButton, findsAtLeastNWidgets(1));
    await tester.tap(editButton);
    await tester.pumpAndSettle(); // enable edit field

    final firstNameField = find.byKey(Key("firstNameField"));
    await tester.enterText(firstNameField, "firstname");
    var enteredText = tester.widget<EditFieldWidget>(firstNameField).controller.text;
    expect(enteredText, "firstname");

    final saveButton = find.byKey(Key("saveButton"));
    expect(saveButton, findsAtLeastNWidgets(1));
    await tester.tap(saveButton);
    await tester.pumpAndSettle(); // save edit field
  });

  testWidgets("Edit field last name", (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final editButton = find.byKey(Key("editButton")).last;
    expect(editButton, findsAtLeastNWidgets(1));
    await tester.tap(editButton);
    await tester.pumpAndSettle(); // enable edit field

    final lastNameField = find.byKey(Key("lastNameField"));
    await tester.enterText(lastNameField, "lastname");
    var enteredText = tester.widget<EditFieldWidget>(lastNameField).controller.text;
    expect(enteredText, "lastname");

    final saveButton = find.byKey(Key("saveButton"));
    expect(saveButton, findsAtLeastNWidgets(1));
    await tester.tap(saveButton);
    await tester.pumpAndSettle(); // save edit field
  });

    testWidgets("Cancel edit field username", (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final editButton = find.byKey(Key("editButton")).first;
    expect(editButton, findsAtLeastNWidgets(1));
    await tester.tap(editButton);
    await tester.pumpAndSettle(); // enable edit field

    final usernameField = find.byKey(Key("usernameField"));
    await tester.enterText(usernameField, "username");

    final cancelButton = find.byKey(Key("cancelButton"));
    expect(cancelButton, findsAtLeastNWidgets(1));
    await tester.tap(cancelButton);
    await tester.pumpAndSettle(); // cancel modification
  });

  testWidgets("Empty username", (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final editButton = find.byKey(Key("editButton")).first;
    expect(editButton, findsAtLeastNWidgets(1));
    await tester.tap(editButton);
    await tester.pumpAndSettle(); // enable edit field

    final usernameField = find.byKey(Key("usernameField"));
    await tester.enterText(usernameField, "");

    final saveButton = find.byKey(Key("saveButton"));
    expect(saveButton, findsAtLeastNWidgets(1));
    await tester.tap(saveButton);
    await tester.pumpAndSettle(); // save edit field

    final errorText = find.text("Please enter a username");
    expect(errorText, findsOneWidget);
  });

  testWidgets("Empty first name", (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final editButton = find.byKey(Key("editButton")).at(1);
    expect(editButton, findsAtLeastNWidgets(1));
    await tester.tap(editButton);
    await tester.pumpAndSettle(); // enable edit field

    final firstNameField = find.byKey(Key("firstNameField"));
    await tester.enterText(firstNameField, "");
    var enteredText = tester.widget<EditFieldWidget>(firstNameField).controller.text;
    expect(enteredText, "");

    final saveButton = find.byKey(Key("saveButton"));
    expect(saveButton, findsAtLeastNWidgets(1));
    await tester.tap(saveButton);
    await tester.pumpAndSettle(); // save edit field
  });

  testWidgets("Empty last name", (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final editButton = find.byKey(Key("editButton")).last;
    expect(editButton, findsAtLeastNWidgets(1));
    await tester.tap(editButton);
    await tester.pumpAndSettle(); // enable edit field

    final lastNameField = find.byKey(Key("lastNameField"));
    await tester.enterText(lastNameField, "");
    var enteredText = tester.widget<EditFieldWidget>(lastNameField).controller.text;
    expect(enteredText, "");

    final saveButton = find.byKey(Key("saveButton"));
    expect(saveButton, findsAtLeastNWidgets(1));
    await tester.tap(saveButton);
    await tester.pumpAndSettle(); // save edit field
  });

  testWidgets("Switch on position notification", (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final switchPosition = find.byKey(Key("switchPosition"));
    expect(switchPosition, findsOneWidget);
    await tester.tap(switchPosition);
    await tester.pumpAndSettle(const Duration(seconds: 2)); // switch notification

    final snackBar = find.text('Position notifications are enabled');
    expect(snackBar, findsAtLeastNWidgets(1)); // show snackbar

  });

  testWidgets("Cannot enable position notification", (tester) async {
    await tester.pumpWidget(appNotificationFalse);
    await tester.pumpAndSettle();

    final switchPosition = find.byKey(Key("switchPosition"));
    expect(switchPosition, findsOneWidget);
    await tester.tap(switchPosition);
    await tester.pumpAndSettle(const Duration(seconds: 2)); // switch notification

    final snackBar = find.text('Cannot enable notifications, please check your settings');
    expect(snackBar, findsAtLeastNWidgets(1)); // show snackbar

  });

  testWidgets("Switch off position notification", (tester) async {
    await tester.pumpWidget(appSwitchTrue);
    await tester.pumpAndSettle();

    final switchPosition = find.byKey(Key("switchPosition"));
    expect(switchPosition, findsOneWidget);
    await tester.tap(switchPosition);
    await tester.pumpAndSettle(const Duration(seconds: 2)); // switch notification

    final snackBar = find.text('Position notifications are disabled');
    expect(snackBar, findsAtLeastNWidgets(1)); // show snackbar

  });

    testWidgets("Switch on chat notification", (tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final switchPosition = find.byKey(Key("switchChat"));
    expect(switchPosition, findsOneWidget);
    await tester.tap(switchPosition);
    await tester.pumpAndSettle(const Duration(seconds: 2)); // switch notification

    final snackBar = find.text('Chat notifications are enabled');
    expect(snackBar, findsAtLeastNWidgets(1)); // show snackbar

  });

  testWidgets("Cannot enable chat notification", (tester) async {
    await tester.pumpWidget(appNotificationFalse);
    await tester.pumpAndSettle();

    final switchPosition = find.byKey(Key("switchChat"));
    expect(switchPosition, findsOneWidget);
    await tester.tap(switchPosition);
    await tester.pumpAndSettle(const Duration(seconds: 2)); // switch notification

    final snackBar = find.text('Cannot enable notifications, please check your settings');
    expect(snackBar, findsAtLeastNWidgets(1)); // show snackbar

  });

  testWidgets("Switch off chat notification", (tester) async {
    await tester.pumpWidget(appSwitchTrue);
    await tester.pumpAndSettle();

    final switchPosition = find.byKey(Key("switchChat"));
    expect(switchPosition, findsOneWidget);
    await tester.tap(switchPosition);
    await tester.pumpAndSettle(const Duration(seconds: 2)); // switch notification

    final snackBar = find.text('Chat notifications are disabled');
    expect(snackBar, findsAtLeastNWidgets(1)); // show snackbar

  });

   testWidgets("Render Tablet Screen", (tester) async {
    binding.window.physicalSizeTestValue = Size(1280, 900);
    binding.window.devicePixelRatioTestValue = 1.0;
    
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    final image = find.byKey(Key("settingsTabletImage"));
    expect(image, findsOneWidget);
  });

}
