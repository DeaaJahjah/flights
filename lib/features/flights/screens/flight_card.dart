import 'package:flights/features/flights/models/flight.dart';
import 'package:flights/utils/r.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class FlightCard extends StatelessWidget {
  final Flight flightData;
  final bool withPrice;
  final double ticketPrice;

  const FlightCard({
    Key? key,
    required this.flightData,
    this.ticketPrice = 0.0,
  })  : withPrice = false,
        super(key: key);

  const FlightCard.withPrice({
    Key? key,
    required this.flightData,
    required this.ticketPrice,
  })  : withPrice = true,
        super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          left: withPrice ? 16.0 : 32.0,
          top: 32.0,
          right: withPrice ? 16.0 : 32.0,
          bottom: withPrice ? 16.0 : 0.0,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildLeftColumn(),
                ),
                Expanded(
                  child: _buildMiddlePart(),
                ),
                Expanded(
                  child: _buildRightColumn(),
                ),
              ],
            ),
            SizedBox(
              height: withPrice ? 24.0 : 32.0,
            ),
            Divider(
              color: R.secondaryColor,
            ),
            if (withPrice) const SizedBox(height: 6.0),
            if (withPrice) _buildPriceArea(),
          ],
        ),
      );

  String extractTime(DateTime dateTime) {
    String time =
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";

    return time;
  }

  Widget _buildLeftColumn() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            flightData.from,
            style: TextStyle(color: R.secondaryColor, fontSize: 32.0),
          ),
          const SizedBox(
            height: 6.0,
          ),
          // Text(
          //   flightData.departure,
          //   style: const TextStyle(
          //     color: Colors.white,
          //     fontWeight: FontWeight.bold,
          //     fontSize: 12.0,
          //   ),
          // ),
          const SizedBox(
            height: 24.0,
          ),
          Text(
            "تاريخ الانطلاق",
            style: TextStyle(color: R.tertiaryColor),
          ),
          const SizedBox(
            height: 6.0,
          ),
          Text(
            "${Jiffy.parseFromDateTime(flightData.lunchDate).yMMMd} ${extractTime(flightData.lunchDate)}",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),
        ],
      );

  Widget _buildRightColumn() => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            flightData.to,
            style: TextStyle(color: R.secondaryColor, fontSize: 32.0),
          ),
          const SizedBox(
            height: 6.0,
          ),
          Text(
            "${Jiffy.parseFromDateTime(flightData.arriveDate).yMMMd} ${extractTime(flightData.arriveDate)}",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),
          const SizedBox(
            height: 24.0,
          ),
          Text(
            "رقم الرحلة",
            style: TextStyle(color: R.tertiaryColor),
          ),
          const SizedBox(
            height: 6.0,
          ),
          Text(
            flightData.flightNo,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),
        ],
      );

  Widget _buildMiddlePart() => Column(
        children: [
          Icon(
            Icons.flight_takeoff,
            color: R.secondaryColor,
          ),
          const SizedBox(
            height: 6.0,
          ),
          Text(
            'مدة الرحلة ${flightData.period}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      );

  Widget _buildPriceArea() => Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.apple,
                color: R.secondaryColor,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: "سعر تذكرة vip  ",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: "${flightData.businessClassCost} ل.س",
                      style: TextStyle(
                        color: R.secondaryColor,
                        fontSize: 24.0,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.apple,
                color: R.secondaryColor,
              ),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: "سعر تذكرة normal  ",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: "${flightData.normalClassCost} ل.س",
                      style: TextStyle(
                        color: R.secondaryColor,
                        fontSize: 24.0,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      );
}
