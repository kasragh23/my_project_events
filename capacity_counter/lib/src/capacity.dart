import 'package:flutter/material.dart';
export './capacity.dart';

class Capacity extends StatefulWidget {
  final int totalCapacity;
  final int initialValue;
  final void Function(int) onChanged;

  const Capacity({
    super.key,
    required this.totalCapacity,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  _CapacityState createState() => _CapacityState();
}

class _CapacityState extends State<Capacity> {
  int _tickets = 1;
  @override
  void initState() {
    super.initState();
    _tickets = widget.initialValue;
  }


  void _incrementTickets() {
    if (_tickets < widget.totalCapacity) {
      setState(() {
        _tickets++;
        widget.onChanged(_tickets);
      });
    }
  }

  void _decrementTickets() {
    if (_tickets > 1) {
      setState(() {
        _tickets--;
        widget.onChanged(_tickets);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: _decrementTickets,
            ),
            Text('$_tickets'),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: _incrementTickets,
            ),
          ],
        ),
      ],
    );
  }
}
