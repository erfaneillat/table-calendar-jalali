<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

The table_calendar_jalali package is a Flutter package that provides a custom table calendar widget with support for the Jalali (Persian) calendar system. It allows users to navigate through different months, select specific days, and customize the appearance of the calendar.

This package utilizes the shamsi_date package to handle the Jalali calendar functionality and the table_calendar_jalali package to extend the String class for Farsi number conversion.

Example Usage:
To use the table_calendar_jalali package, follow these steps:

Add the package to your pubspec.yaml file:

```yaml
dependencies:
  table_calendar_jalali: ^lastVersion
```

Implement the JalaliTableCalendar widget in your Flutter widget tree:

```dart
  JalaliTableCalendar(
            currentMonth: Jalali.now(),
            headerStyle: TextStyle(color: Colors.blue),
            weekDaysStyle: TextStyle(fontSize: 12),
            selectedDay: Jalali.now().addDays(2),
            dayBuilder: (context, date) {
              // Custom day builder implementation
              return Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    date.day.toString().toFarsiNumber(),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              );
            },
            onDaySelected: (date) {
              // Handle day selection
              print('Selected date: $date');
            },
            headerText: (date) {
              // Custom header text implementation
              return '${date.formatter.mN} ${date.year}'.toFarsiNumber();
            },
            onMonthChanged: (date) {
              // Handle month change
              print('Current month: $date');
            },
          ),

```

This example demonstrates how to create a JalaliTableCalendar with custom styling, a selected day, and custom day and header builders. The onDaySelected callback and onMonthChanged callback are used to handle user interactions with the calendar.

Note: Make sure to wrap your widget tree with a MaterialApp or CupertinoApp widget to provide the required material or Cupertino design for the calendar.

That's it! You can now use the table_calendar_jalali package to add a Jalali table calendar to your Flutter application.
