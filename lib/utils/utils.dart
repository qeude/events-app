



String getTimeUntilEvent(DateTime eventDate){
   int differenceInDay = eventDate.difference(DateTime.now()).inDays;
  int differenceInHours = eventDate.difference(DateTime.now()).inHours;
  int differenceInMinutes = eventDate.difference(DateTime.now()).inMinutes;
  int differenceToPrint;
  String unit;
  if(differenceInDay > 0){
    differenceToPrint = differenceInDay;
    unit = "day";
  }
  else if(differenceInHours > 0){
    differenceToPrint = differenceInHours;
    unit = "hour";
  }
  else{
    differenceToPrint = differenceInMinutes;
    unit = "minute";
  }
  if(differenceToPrint > 1)
    unit = "${unit}s";
  return "$differenceToPrint $unit";
}