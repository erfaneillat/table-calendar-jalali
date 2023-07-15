import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:table_calendar_jalali/extensions/string.dart';

class JalaliTableCalendar extends StatefulWidget {
  const JalaliTableCalendar(
      {super.key,
      this.currentMonth,
      this.headerStyle,
      this.weekDaysStyle,
      this.selectedDay,
      this.selectedDayBuilder,
      this.currentDayBuilder,
      this.dayBuilder});

  final Jalali? currentMonth;
  final TextStyle? headerStyle;
  final TextStyle? weekDaysStyle;
  final Jalali? selectedDay;
  final Widget Function(BuildContext, Jalali)? dayBuilder;
  final Widget Function(BuildContext, Jalali)? selectedDayBuilder;
  final Widget Function(BuildContext, Jalali)? currentDayBuilder;
  @override
  State<JalaliTableCalendar> createState() => _JalaliTableCalendarState();
}

class _JalaliTableCalendarState extends State<JalaliTableCalendar> {
  late Jalali _currentMonth;
  late List<Jalali> _visibleDates;

  @override
  void initState() {
    super.initState();
    _currentMonth = widget.currentMonth ?? Jalali.now();
    _visibleDates = _getVisibleDates(_currentMonth);
  }

  static final List<String> weekDays = [
    'شنبه',
    'یکشنبه',
    'دوشنبه',
    'سه شنبه',
    'چهارشنبه',
    'پنجشنبه',
    'جمعه',
  ];
  bool isTheSame(Jalali first, Jalali second) {
    return first.day == second.day &&
        first.month == second.month &&
        first.year == second.year;
  }

  int getDaysInMonth(int year, int month) {
    if (month == 12) {
      final bool isLeapYear = Jalali(year).isLeapYear();
      if (isLeapYear) return 30;
      return 29;
    }
    const List<int> daysInMonth = <int>[
      31,
      31,
      31,
      31,
      31,
      31,
      30,
      30,
      30,
      30,
      30,
      -1
    ];
    return daysInMonth[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          _buildHeader(),
          _buildDaysName(),
          _buildCalendar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          splashRadius: 20,
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            setState(() {
              if (_currentMonth.month == 1) {
                _currentMonth = _currentMonth.copy(month: 12);
                _currentMonth =
                    _currentMonth.copy(year: _currentMonth.year - 1);
              } else {
                _currentMonth =
                    _currentMonth.copy(month: _currentMonth.month - 1);
              }
              _visibleDates = _getVisibleDates(_currentMonth);
            });
          },
        ),
        Text(_getFormattedMonthYear(_currentMonth),
            style:
                widget.headerStyle ?? Theme.of(context).textTheme.labelMedium),
        IconButton(
          splashRadius: 20,
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            setState(() {
              if (_currentMonth.month == 12) {
                _currentMonth = _currentMonth.copy(month: 1);
                _currentMonth =
                    _currentMonth.copy(year: _currentMonth.year + 1);
              } else {
                _currentMonth =
                    _currentMonth.copy(month: _currentMonth.month + 1);
              }
              _visibleDates = _getVisibleDates(_currentMonth);
            });
          },
        ),
      ],
    );
  }

  Widget _buildDaysName() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: weekDays
            .map((e) => Text(
                  e,
                  style: widget.weekDaysStyle ??
                      Theme.of(context)
                          .textTheme
                          .labelMedium!
                          .copyWith(fontSize: 12),
                ))
            .toList());
  }

  Widget _buildCalendar() {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1,
          crossAxisCount: 7,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0),
      itemCount: _visibleDates.length,
      itemBuilder: (context, index) {
        Jalali date = _visibleDates[index];

        Jalali firstDayOfMonth =
            Jalali(_currentMonth.year, _currentMonth.month, 1);
        int daysBeforeFirst = firstDayOfMonth.weekDay - 1;

        bool itsLastMonthDay = index < daysBeforeFirst;
        bool isSelected = widget.selectedDay != null
            ? isTheSame(widget.selectedDay!, date)
            : false;
        if (itsLastMonthDay) {
          return const SizedBox();
        }
        if (isTheSame(Jalali.now(), date)) {
          if (widget.currentDayBuilder != null) {
            return widget.currentDayBuilder!(context, date);
          }
          return Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text(date.day.toString().toFarsiNumber(),
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(fontSize: 16, color: Colors.white)),
            ),
          );
        }
        if (isSelected) {
          if (widget.selectedDayBuilder != null) {
            return widget.selectedDayBuilder!(context, date);
          }
          return Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text(date.day.toString().toFarsiNumber(),
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(fontSize: 16, color: Colors.white)),
            ),
          );
        }

        if (widget.dayBuilder != null) {
          return widget.dayBuilder!(context, date);
        }

        return Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: Text(date.day.toString().toFarsiNumber(),
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .copyWith(fontSize: 16, color: Colors.black)),
          ),
        );
      },
    );
  }

  List<Jalali> _getVisibleDates(Jalali month) {
    Jalali firstDayOfMonth = Jalali(month.year, month.month, 1);
    int daysBeforeFirst = firstDayOfMonth.weekDay - 1;

    Jalali startDate = firstDayOfMonth.addDays(daysBeforeFirst * -1);
    List<Jalali> visibleDates = [];
    for (int i = 0;
        i < getDaysInMonth(month.year, month.month) + daysBeforeFirst;
        i++) {
      visibleDates.add(startDate.addDays(i));
    }

    return visibleDates;
  }

  String _getFormattedMonthYear(Jalali month) {
    return '${month.formatter.mN} ${month.year}';
  }
}
