import 'dart:core';

const _oneMinuteInMillis = 60000;
const _oneHourInMillis = 3600000;

/// convert millisecondsSinceEpoch to readable Date time
extension ToDateTime on int {
  String toReadableDateTime([int? currentTimeMill]) {
    final nowDTime = currentTimeMill == null
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(
            currentTimeMill); // currentTimeMill for testing only
    final nowInt = nowDTime.millisecondsSinceEpoch;
    if (nowInt < this) {
      return 'From Future';
    }
    if ((nowInt - this) < _oneMinuteInMillis) {
      return 'Just now';
    } else if ((nowInt - this) < _oneHourInMillis) {
      return ('${(nowInt - this) ~/ _oneMinuteInMillis} min ago');
    } else {
      final thisDTime = DateTime.fromMillisecondsSinceEpoch(this);
      if (thisDTime.year == nowDTime.year) {
        if (thisDTime.month == nowDTime.month) {
          if (nowDTime.difference(thisDTime).inDays < 7) {
            if (thisDTime.day == nowDTime.day) {
              return 'Today, ${thisDTime.getDateTimeInAmPm()}';
            } else if (thisDTime.difference(nowDTime).inDays == 1) {
              return 'Yesterday, ${thisDTime.getDateTimeInAmPm()}';
            }
            return '${_weekDayName(thisDTime.weekday)}, ${thisDTime.getDateTimeInAmPm()}';
          } else {
            return '${thisDTime.day}-${_monthName(thisDTime.month)}, ${thisDTime.getDateTimeInAmPm()}';
          }
        } else {
          return '${thisDTime.day}-${_monthName(thisDTime.month)}, ${thisDTime.getDateTimeInAmPm()}';
        }
      } else {
        return '${thisDTime.day}-${_monthName(thisDTime.month)}, ${thisDTime.year}';
      }
    }
  }
}

extension GetTimeInAmPm on DateTime {
  String getDateTimeInAmPm() {
    final hour = this.hour;
    final minuteStr = minute.toString().padLeft(2, '0');
    if (hour == 0) {
      return '12:$minuteStr am';
    }
    if(hour == 12) {
      return '12:$minuteStr pm';
    }
    if (hour > 12 && hour < 24) {
      return '${hour - 12}:$minuteStr pm';
    }
    return '$hour:$minuteStr am';
  }
}

_monthName(int month) => _monthNames[month] ?? 'Invalid';

_weekDayName(int weekday) => _weekDayNames[weekday] ?? 'Invalid';


const _monthNames = {
  1: 'Jan',
  2: 'Feb',
  3: 'Mar',
  4: 'Apr',
  5: 'May',
  6: 'Jun',
  7: 'Jul',
  8: 'Aug',
  9: 'Sep',
  10: 'Oct',
  11: 'Nov',
  12: 'Dec',
};

const _weekDayNames = {
  1: 'Mon',
  2: 'Tue',
  3: 'Wed',
  4: 'Thu',
  5: 'Fri',
  6: 'Sat',
  7: 'Sun',
};