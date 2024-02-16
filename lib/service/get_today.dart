String getToday() {
  DateTime now = DateTime.now();

  //Feb 4, 2024, 16:57
  String strToday =
      "${monthNumToMonth(now.month)} ${now.day}, ${now.year}, ${now.hour}:${now.minute}";
  return strToday;
}

String monthNumToMonth(int month) {
  switch (month) {
    case 1:
      return "Jan";
    case 2:
      return "Feb";
    case 3:
      return "Mar";
    case 4:
      return "Apr";
    case 5:
      return "May";
    case 6:
      return "Jun";
    case 7:
      return "Jul";
    case 8:
      return "Aug";
    case 9:
      return "Sep";
    case 10:
      return "Oct";
    case 11:
      return "Nov";
    case 12:
      return "Dec";
    default:
      return "Error";
  }
}
