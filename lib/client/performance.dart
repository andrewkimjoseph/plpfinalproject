/// Bar chart example
// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BarChartWithSecondaryAxis extends StatelessWidget {
  static const secondaryMeasureAxisId = 'secondaryMeasureAxisId';
  final List<charts.Series<OrdinalSales, String>> seriesList;
  final bool animate;

  const BarChartWithSecondaryAxis(this.seriesList,
      {super.key, required this.animate});

  factory BarChartWithSecondaryAxis.withSampleData(
      {required int amount, required int referrals}) {
    return BarChartWithSecondaryAxis(
      _createSampleData(totalAmountLoaned: amount, totalReferrals: referrals),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: 400,
      child: charts.BarChart(
        seriesList,
        animate: false,
        barGroupingType: charts.BarGroupingType.grouped,
        primaryMeasureAxis: const charts.NumericAxisSpec(
            tickProviderSpec:
                charts.BasicNumericTickProviderSpec(desiredTickCount: 3)),
        secondaryMeasureAxis: const charts.NumericAxisSpec(
            tickProviderSpec:
                charts.BasicNumericTickProviderSpec(desiredTickCount: 3)),
      ),
    );
  }

  /// Create series list with multiple series
  static List<charts.Series<OrdinalSales, String>> _createSampleData(
      {required int totalAmountLoaned, required int totalReferrals}) {
    final totalAmountLoanedData = [
      new OrdinalSales('Total Amount Loaned (KES)', totalAmountLoaned),
    ];

    final totalReferralsData = [
      new OrdinalSales('Total Referrals (Borrowers)', totalReferrals),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
        id: 'Total Amount Loaned',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: totalAmountLoanedData,
      ),
      new charts.Series<OrdinalSales, String>(
        id: 'Total Referrals',
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: totalReferralsData,
      )..setAttribute(charts.measureAxisIdKey, secondaryMeasureAxisId),
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
