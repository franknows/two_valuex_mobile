String timeAgoSw(String dateString, {bool numericDates = true}) {
  DateTime date = DateTime.parse(dateString);
  final date2 = DateTime.now();
  final difference = date2.difference(date);

  if ((difference.inDays / 365).floor() >= 2) {
    return 'Miaka ${(difference.inDays / 365).floor()} iliyopita';
  } else if ((difference.inDays / 365).floor() >= 1) {
    return (numericDates) ? 'Mwaka mmoja uliopita' : 'Mwaka jana';
  } else if ((difference.inDays / 30).floor() >= 2) {
    return 'Miezi ${(difference.inDays / 365).floor()} iliyopita';
  } else if ((difference.inDays / 30).floor() >= 1) {
    return (numericDates) ? 'Mwezi mmoja uliopita' : 'Mwezi jana';
  } else if ((difference.inDays / 7).floor() >= 2) {
    return 'Wiki ${(difference.inDays / 7).floor()} zilizopita';
  } else if ((difference.inDays / 7).floor() >= 1) {
    return (numericDates) ? 'Wiki moja iliyopita' : 'Wiki jana';
  } else if (difference.inDays >= 2) {
    return 'Siku ${difference.inDays} zilizopita';
  } else if (difference.inDays >= 1) {
    return (numericDates) ? 'Siku 1 iliyopita' : 'Jana';
  } else if (difference.inHours >= 2) {
    return 'Masaa ${difference.inHours} yaliyopita';
  } else if (difference.inHours >= 1) {
    return (numericDates) ? 'Lisaa 1 lililopita' : 'Lisaa limepita';
  } else if (difference.inMinutes >= 2) {
    return 'Dakika ${difference.inMinutes} zilizopita';
  } else if (difference.inMinutes >= 1) {
    return (numericDates) ? 'Dakika 1 iliyopita' : 'Dakika imepita';
  } else if (difference.inSeconds >= 3) {
    return 'Sekunde ${difference.inSeconds} zilizopita';
  } else {
    return 'Mda huu';
  }
}
