 import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExpenseTile extends StatelessWidget {
  final String name;
  final DateTime dateTime;
  final String amount;
  void Function(BuildContext)? onDelete;
  void Function(BuildContext)? onEdit;
  ExpenseTile({super.key, required this.name, required this.dateTime, required this.amount, required this.onDelete, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        motion: StretchMotion(),
        children: [
          SlidableAction(
            onPressed: onEdit,
            icon: Icons.edit,
            backgroundColor: Colors.blue.shade600,
            borderRadius: BorderRadius.circular(4),
          )
        ],
      ),
      endActionPane: ActionPane(
        motion: StretchMotion(),
        children: [
          SlidableAction(
            onPressed: onDelete,
            icon: Icons.delete,
            backgroundColor: Colors.red.shade600,
            borderRadius: BorderRadius.circular(4),
          )
        ],
      ),
      child: ListTile(
        title: Text(
            name
        ),
        subtitle: Text(
            '${dateTime.day} / ${dateTime.month} / ${dateTime.year}'
        ),
        trailing: Text(
            amount
        ),
      ),
    );
  }
}
