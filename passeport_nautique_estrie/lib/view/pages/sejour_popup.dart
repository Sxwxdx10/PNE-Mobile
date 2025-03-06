import 'package:flutter/material.dart';

class SejourPopup {
  static Future<Duration?> showSejourDialog(BuildContext context) async {
    int selectedDays = 0;
    int selectedHours = 0;
    int selectedMinutes = 0;

    return showDialog<Duration>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Durée du séjour'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Veuillez indiquer la durée prévue de votre séjour:'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildNumberPicker("Jours", 0, 30, (val) => selectedDays = val),
                  _buildNumberPicker("Heures", 0, 23, (val) => selectedHours = val),
                  _buildNumberPicker("Minutes", 0, 59, (val) => selectedMinutes = val),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Duration selectedDuration = Duration(
                  days: selectedDays,
                  hours: selectedHours,
                  minutes: selectedMinutes,
                );
                Navigator.of(context).pop(selectedDuration);
              },
              child: const Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }

  static Widget _buildNumberPicker(String label, int min, int max, Function(int) onSelected) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(
          height: 100,
          width: 60,
          child: ListWheelScrollView.useDelegate(
            itemExtent: 40,
            diameterRatio: 1.2,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: onSelected,
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) => Center(child: Text(index.toString())),
              childCount: max - min + 1,
            ),
          ),
        ),
      ],
    );
  }
}
