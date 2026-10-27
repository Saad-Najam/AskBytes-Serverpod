import 'package:flutter/material.dart';

/// A non-lazy column whose children animate to their new position when the
/// list is re-ordered, and fade/slide in when first inserted. Intended for
/// lists of at most a few hundred items (a Q&A session).
class RankedList extends StatefulWidget {
  const RankedList({super.key, required this.children, this.spacing = 12});

  /// Each child must carry a stable [Key] (e.g. `ValueKey(question.id)`).
  final List<Widget> children;
  final double spacing;

  @override
  State<RankedList> createState() => _RankedListState();
}

class _RankedListState extends State<RankedList> {
  final _columnKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    for (var i = 0; i < widget.children.length; i++) {
      final child = widget.children[i];
      items.add(
        _FlipItem(
          key: child.key,
          columnKey: _columnKey,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: i == widget.children.length - 1 ? 0 : widget.spacing,
            ),
            child: child,
          ),
        ),
      );
    }
    return Column(
      key: _columnKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: items,
    );
  }
}

class _FlipItem extends StatefulWidget {
  const _FlipItem({super.key, required this.columnKey, required this.child});

  final GlobalKey columnKey;
  final Widget child;

  @override
  State<_FlipItem> createState() => _FlipItemState();
}

class _FlipItemState extends State<_FlipItem> with TickerProviderStateMixin {
  late final AnimationController _move = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 380),
  );
  late final AnimationController _enter = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  )..forward();

  double? _lastDy;
  double _deltaDy = 0;

  @override
  void dispose() {
    _move.dispose();
    _enter.dispose();
    super.dispose();
  }

  void _measure() {
    if (!mounted) return;
    final column = widget.columnKey.currentContext?.findRenderObject();
    final self = context.findRenderObject();
    if (column is! RenderBox || self is! RenderBox || !self.attached) return;
    final dy = self.localToGlobal(Offset.zero, ancestor: column).dy;
    final last = _lastDy;
    if (last != null && (last - dy).abs() > 1) {
      _deltaDy = last - dy;
      _move.forward(from: 0);
    }
    _lastDy = dy;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
    return AnimatedBuilder(
      animation: Listenable.merge([_move, _enter]),
      builder: (context, child) {
        final moveT = Curves.easeOutCubic.transform(_move.value);
        final enterT = Curves.easeOutBack.transform(_enter.value.clamp(0, 1));
        final dy = _deltaDy * (1 - moveT) + (1 - enterT) * -24;
        return Opacity(
          opacity: Curves.easeOut.transform(_enter.value),
          child: Transform.translate(offset: Offset(0, dy), child: child),
        );
      },
      child: widget.child,
    );
  }
}
