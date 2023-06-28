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
  initialRoute: '/',
  routes: {
    '/': (context) => ResponsiveLayout(mobileBody: GroupChatList(isEmpty: false), tabletBody: GroupChatTablet(isEmpty: false)),
    '/chatpage': (context) => ChatScreen(group: group),
  },
);

MaterialApp appEmptyGroups = MaterialApp(
  title: 'Community',
  initialRoute: '/',
  routes: {
    '/': (context) => ResponsiveLayout(mobileBody: GroupChatList(isEmpty: true), tabletBody: GroupChatTablet(isEmpty: true)),
    '/chatpage': (context) => ChatScreen(group: group),
  },
);


void main() {
  late TestWidgetsFlutterBinding binding;

  setUp(() {
    binding = TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets("Render Screen", (tester) async {
    binding.window.physicalSizeTestValue = Size(1280, 900);
    binding.window.devicePixelRatioTestValue = 1.0;
    
    await tester.pumpWidget(appGroups);
    await tester.pumpAndSettle();

    final title = find.text("Group chat");
    expect(title, findsOneWidget);
  });

  testWidgets("No groups", (tester) async {
    binding.window.physicalSizeTestValue = Size(1280, 900);
    binding.window.devicePixelRatioTestValue = 1.0;
    
    await tester.pumpWidget(appEmptyGroups);
    await tester.pumpAndSettle();

    final noGroup = find.byKey(Key("noGroupFound"));
    expect(noGroup, findsOneWidget);
  });

   testWidgets("Click a group", (tester) async {
    binding.window.physicalSizeTestValue = Size(1280, 900);
    binding.window.devicePixelRatioTestValue = 1.0;
    
    await tester.pumpWidget(appGroups);
    await tester.pumpAndSettle();

    final group = find.text('name1');
    expect(group, findsOneWidget);
    await tester.tap(group);
    await tester.pumpAndSettle(); // select a group

    final selectedGroupName = find.byKey(Key("selectedGroupName"));
    expect(selectedGroupName, findsOneWidget);

    final groupInfoButton = find.byKey(Key("groupInfoButton"));
    expect(groupInfoButton, findsOneWidget);
    await tester.tap(groupInfoButton);
    await tester.pumpAndSettle(); // open group info dialog

    final groupInfoIcon = find.byKey(Key("groupInfoIcon"));
    expect(groupInfoIcon, findsOneWidget);

    final groupName = find.byKey(Key("groupName"));
    expect(groupName, findsOneWidget);

    final groupMembers = find.byKey(Key("groupMembers"));
    expect(groupMembers, findsOneWidget);

    final closeButton = find.byKey(Key("closeButton"));
    expect(closeButton, findsOneWidget);
    await tester.tap(closeButton);
    await tester.pumpAndSettle(); // close group info dialog
    
  });

}