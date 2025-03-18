import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SejourPopup {
  static Future<Duration?> showSejourDialog(BuildContext context) async {
    DateTime? startDate;
    DateTime? endDate;

    return showDialog<Duration>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Durée du séjour'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Sélectionnez la date de début et de fin de votre séjour :'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime now = DateTime.now();
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: now,
                        firstDate: now,
                        lastDate: DateTime(2100, 12, 31),
                      );
                      if (picked != null) {
                        setState(() {
                          startDate = picked;
                          if (endDate != null && endDate!.isBefore(startDate!)) {
                            endDate = null;
                          }
                        });
                      }
                    },
                    child: const Text('Choisir la date de début'),
                  ),
                  if (startDate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Début: ${startDate!.toLocal().toString().split(' ')[0]}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      if (startDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Veuillez choisir la date de début d’abord')),
                        );
                        return;
                      }
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: startDate!,
                        firstDate: startDate!,
                        lastDate: DateTime(2100, 12, 31),
                      );
                      if (picked != null) {
                        setState(() {
                          endDate = picked;
                        });
                      }
                    },
                    child: const Text('Choisir la date de fin'),
                  ),
                  if (endDate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Fin: ${endDate!.toLocal().toString().split(' ')[0]}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
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
                  onPressed: () async {
                    if (startDate != null && endDate != null && endDate!.isAfter(startDate!)) {
                      Duration selectedDuration = endDate!.difference(startDate!);

                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('dureeSejour', '${selectedDuration.inDays} jours');

                      Navigator.of(context).pop(selectedDuration);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Veuillez choisir des dates valides')),
                      );
                    }
                  },
                  child: const Text('Confirmer'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
