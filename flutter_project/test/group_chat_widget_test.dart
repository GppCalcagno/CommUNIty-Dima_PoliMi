import 'package:dima_project/Atest_lib/chat_page.dart';
import 'package:dima_project/Atest_lib/group_chat_list_page.dart';
import 'package:dima_project/Atest_lib/group_chat_tablet_page.dart';
import 'package:dima_project/classes/group_chat_model.dart';
import 'package:dima_project/responsive_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNavigationObserver extends Mock implements NavigatorObserver {}

GroupChatModel group = GroupChatModel(
  groupId: "groupId1", 
  name: "name1", 
  icon: "icon1",
);

MaterialApp appGroups = MaterialApp(
  title: 'Community',
  // Start the app with the "/" named route. In this case, the app starts
  // on the FirstScreen widget.
  initialRoute: '/',
  routes: {
    // When navigating to the "/" route, build the FirstScreen widget.
    '/': (context) => ResponsiveLayout(mobileBody: GroupChatList(isEmpty: false), tabletBody: GroupChatTablet(isEmpty: false)),
    // When navigating to the "/second" route, build the SecondScreen widget.
    '/chatpage': (context) => ChatScreen(group: group),
  },
);

MaterialApp appEmptyGroups = MaterialApp(
  title: 'Community',
  initialRoute: '/',
  routes: {
    '/': (context) => ResponsiveLayout(mobileBody: GroupChatList(isEmpty: true), tabletBody: GroupChatTablet(isEmpty: true)),    
  },
);

MaterialApp appChat = MaterialApp(
  title: 'Community',
  initialRoute: '/',
  routes: {
    '/': (context) => ChatScreen(group: group),    
  },
);

void main() {
  late TestWidgetsFlutterBinding binding;

  setUp(() {
    binding = TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets("Render Screen", (tester) async {
    await tester.pumpWidget(appGroups);
    await tester.pumpAndSettle();

    final chatTitle = find.byKey(Key("Groups"));
    expect(chatTitle, findsOneWidget);

    final translate = find.byKey(Key("translate"));
    expect(translate, findsOneWidget);

    final groupName = find.text("name1");
    expect(groupName, findsAtLeastNWidgets(1));

    final groupLastMessage = find.text("lastMessage1");
    expect(groupLastMessage, findsAtLeastNWidgets(1));

    final emptyLastMessage = find.byKey(Key("empty"));
    expect(emptyLastMessage, findsAtLeastNWidgets(1));

    final groupLastMessageTime1 = find.byKey(Key('timestamp1'));
    expect(groupLastMessageTime1, findsAtLeastNWidgets(1));

    final groupLastMessageTime2 = find.byKey(Key('timestamp2'));
    expect(groupLastMessageTime2, findsAtLeastNWidgets(1));

    final groupLastMessageSender = find.byKey(Key("lastSender"));
    expect(groupLastMessageSender, findsAtLeastNWidgets(1));
  });

  testWidgets("No groups", (tester) async {
    await tester.pumpWidget(appEmptyGroups);
    await tester.pumpAndSettle();

    final noGroup = find.byKey(Key('noGroup'));
    expect(noGroup, findsOneWidget);
  });

  testWidgets("Click a group", (tester) async {
    await tester.pumpWidget(appGroups);
    await tester.pumpAndSettle();

    final groupSelected = find.text("name1"); // tap on group
    expect(groupSelected, findsOneWidget);
    await tester.tap(groupSelected);
    await tester.pumpAndSettle();

    final title = find.byKey(Key('title'));
    expect(title, findsOneWidget);
  });

  testWidgets("Group info dialog", (tester) async {
    await tester.pumpWidget(appGroups);
    await tester.pumpAndSettle();

    final groupSelected = find.text("name1"); // tap on group
    expect(groupSelected, findsOneWidget);
    await tester.tap(groupSelected);
    await tester.pumpAndSettle();

    final infoIcon = find.byKey(Key('infoIcon'));
    expect(infoIcon, findsOneWidget);
    await tester.tap(infoIcon);
    await tester.pumpAndSettle(); // open dialog Group Info

    final groupIcon = find.byKey(Key('groupIcon'));
    expect(groupIcon, findsOneWidget);

    final groupInfo = find.byKey(Key('groupInfo'));
    expect(groupInfo, findsOneWidget);

    final dialogName = find.byKey(Key('dialogName'));
    expect(dialogName, findsOneWidget);

    final groupName = find.byKey(Key('groupName'));
    expect(groupName, findsOneWidget);

    final dialogMembers = find.byKey(Key('dialogMembers'));
    expect(dialogMembers, findsOneWidget);

    final numMembers = find.byKey(Key('numMembers'));
    expect(numMembers, findsOneWidget);

    final closeButton = find.byKey(Key('closeButton'));
    expect(closeButton, findsOneWidget);
    await tester.tap(closeButton);
    await tester.pumpAndSettle(); // close dialog Group Info
  });

  testWidgets("Chat screen", (tester) async {
    await tester.pumpWidget(appChat);
    await tester.pumpAndSettle();

    final messageList = find.byKey(Key('messageList'));
    expect(messageList, findsOneWidget);

    final messageField = find.byKey(Key('messageField'));
    expect(messageField, findsOneWidget);

    final gifButton = find.byKey(Key('gifButton'));
    expect(gifButton, findsOneWidget);
    await tester.tap(gifButton);
    await tester.pumpAndSettle();

    final sendButton = find.byKey(Key('sendButton'));
    expect(sendButton, findsOneWidget);
    await tester.tap(sendButton);
    await tester.pumpAndSettle();

    final messageIsMe = find.byKey(Key('messageIsMe'));
    expect(messageIsMe, findsAtLeastNWidgets(1));

    final dateIsMe = find.byKey(Key('dateIsMe'));
    expect(dateIsMe, findsAtLeastNWidgets(1));

    final gifIsMe = find.byKey(Key('gifIsMe'));
    expect(gifIsMe, findsAtLeastNWidgets(1));

    final messageIsNotMe = find.byKey(Key('messageIsNotMe'));
    expect(messageIsNotMe, findsAtLeastNWidgets(1));

    final dateIsNotMe = find.byKey(Key('dateIsNotMe'));
    expect(dateIsNotMe, findsAtLeastNWidgets(1));

    final gifIsNotMe = find.byKey(Key('gifIsNotMe'));
    expect(gifIsNotMe, findsAtLeastNWidgets(1));
  });

  testWidgets("Profile info dialog", (tester) async {
    await tester.pumpWidget(appChat);
    await tester.pumpAndSettle();

    final profileInfoButton = find.byKey(Key('profileInfoButton')).first;
    expect(profileInfoButton, findsAtLeastNWidgets(1));
    await tester.tap(profileInfoButton);
    await tester.pumpAndSettle(); // open dialog Profile Info

    final profileInfo = find.byKey(Key('profileInfo'));
    expect(profileInfo, findsOneWidget);

    final username = find.byKey(Key('username'));
    expect(username, findsOneWidget);

    final email = find.byKey(Key('email'));
    expect(email, findsOneWidget);

    final firstName = find.byKey(Key('firstName'));
    expect(firstName, findsOneWidget);

    final lastName = find.byKey(Key('lastName'));
    expect(lastName, findsOneWidget);

    final closeButton = find.byKey(Key('closeButton'));
    expect(closeButton, findsOneWidget);
    await tester.tap(closeButton);
    await tester.pumpAndSettle(); // close dialog Profile Info
  });




}
