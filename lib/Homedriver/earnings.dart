import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'profiledriver.dart';

class Earnings extends StatelessWidget {
  Earnings({super.key});
  final List<double> earnings = [100.0, 120.0, 80.0, 91.12, 110.0, 150.0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor:  Colors.grey[200],
     appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        
        title:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tomnaia',
              style: TextStyle(
                fontFamily: 'Sail',
                fontSize: 30,
                color: Color.fromARGB(255, 38, 37, 136),
              ),
            ),
            CircleAvatar(backgroundImage:    const AssetImage(
              'images/serologo.png',
              
            ) 
            ,  child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Profiledriver(),
                      ),
                    );
                  },
                ),)
          
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
             
              const WalletBalanceSection(),
              const SizedBox(height: 20),
              EarningsChartSection(earnings: earnings),
              const SizedBox(height: 20),
              const EarningsDetailsSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class WalletBalanceSection extends StatelessWidget {
  const WalletBalanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Wallet Balance', style: TextStyle(fontSize: 16)),
              Text('\$100',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          ElevatedButton(style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(const Color(0xFF043860)),
          ),
            onPressed: () {},
            child: const Text('Withdraw',style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }
}

class EarningsChartSection extends StatelessWidget {
  final List<double> earnings;

  const EarningsChartSection({super.key, required this.earnings});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('\$1950.15',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          const Text('Dec 7 - 14', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 1.7,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barGroups: earnings.asMap().entries.map((entry) {
                  int index = entry.key;
                  double value = entry.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: value,
                        color: Colors.blue,
                      ),
                    ],
                  );
                }).toList(),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const style = TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        );
                        Widget text;
                        switch (value.toInt()) {
                          case 0:
                            text = const Text('S', style: style);
                            break;
                          case 1:
                            text = const Text('M', style: style);
                            break;
                          case 2:
                            text = const Text('T', style: style);
                            break;
                          case 3:
                            text = const Text('W', style: style);
                            break;
                          case 4:
                            text = const Text('T', style: style);
                            break;
                          case 5:
                            text = const Text('F', style: style);
                            break;
                          default:
                            text = const Text('', style: style);
                            break;
                        }
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 4.0,
                          child: text,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EarningsDetailsSection extends StatelessWidget {
  const EarningsDetailsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: 18),
              Column(
                children: [
                  Text('Total trips', style: TextStyle(fontSize: 16)),
                  Text('140',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(width: 10),
              Column(
                children: [
                  Text('Time online', style: TextStyle(fontSize: 16)),
                  Text('6d 10h',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(width: 10),
              Column(
                children: [
                  Text('Total Distance', style: TextStyle(fontSize: 16)),
                  Text('45 km',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
          Divider(),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Earnings', style: TextStyle(fontSize: 16)),
              Text('\$1804.15',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Trip Earnings', style: TextStyle(fontSize: 16)),
              Text('\$1904.15',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Taxes', style: TextStyle(fontSize: 16)),
              Text('\$100',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
