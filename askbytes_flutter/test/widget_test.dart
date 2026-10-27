import 'package:askbytes_client/askbytes_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:askbytes_flutter/theme.dart';
import 'package:askbytes_flutter/widgets/question_card.dart';
import 'package:askbytes_flutter/widgets/ranked_list.dart';
import 'package:askbytes_flutter/widgets/recap_view.dart';

Question _q(int id, String text, {int votes = 0, String? note}) => Question(
  id: id,
  sessionId: 1,
  text: text,
  voteCount: votes,
  mergeNote: note,
  postedById: 'x',
  createdAt: DateTime(2026),
);

Widget _host(Widget child) => MaterialApp(
  theme: buildTheme(),
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

void main() {
  testWidgets('QuestionCard shows text, votes and the merge badge', (t) async {
    await t.pumpWidget(
      _host(
        QuestionCard(
          question: _q(1, 'How do streams work?', votes: 7, note: '+2 merged'),
          rank: 1,
        ),
      ),
    );
    expect(find.text('How do streams work?'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
    expect(find.text('+2 merged'), findsOneWidget);
  });

  testWidgets('VoteButton fires its callback', (t) async {
    var taps = 0;
    await t.pumpWidget(
      _host(VoteButton(count: 3, voted: false, onPressed: () => taps++)),
    );
    await t.tap(find.byType(VoteButton));
    expect(taps, 1);
  });

  testWidgets('RankedList re-orders children when votes change', (t) async {
    List<Widget> items(List<int> order) => [
      for (final id in order)
        SizedBox(key: ValueKey(id), height: 40, child: Text('item $id')),
    ];

    await t.pumpWidget(_host(RankedList(children: items([1, 2, 3]))));
    await t.pumpAndSettle();
    expect(
      t.getTopLeft(find.text('item 1')).dy <
          t.getTopLeft(find.text('item 3')).dy,
      isTrue,
    );

    await t.pumpWidget(_host(RankedList(children: items([3, 1, 2]))));
    await t.pumpAndSettle();
    expect(
      t.getTopLeft(find.text('item 3')).dy <
          t.getTopLeft(find.text('item 1')).dy,
      isTrue,
    );
  });

  testWidgets('MarkdownText renders headings, bullets and bold', (t) async {
    await t.pumpWidget(
      _host(const MarkdownText('## Themes\n- one **bold** thing\n1. first')),
    );
    expect(find.text('Themes'), findsOneWidget);
    expect(find.textContaining('bold', findRichText: true), findsWidgets);
    expect(find.text('•'), findsOneWidget);
    expect(find.text('1.'), findsOneWidget);
  });
}
