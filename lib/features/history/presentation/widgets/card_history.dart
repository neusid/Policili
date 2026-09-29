import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/date_formatter.dart';

class CardHistory extends StatelessWidget {
  final String imageUrl;
  final String plantName;
  final String date;
  final String soilMoisture;
  final String airMoisture;
  final String ph;
  final String temperature;

  const CardHistory({
    super.key,
    required this.imageUrl,
    required this.plantName,
    required this.date,
    required this.soilMoisture,
    required this.airMoisture,
    required this.ph,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: Column(
          children: [
            // Authentic Gray Header with Logo.png & Date
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              color: const Color(0xffE2E8F0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/img/Logo.png",
                    width: 24.w,
                    height: 24.w,
                  ),
                  Text(
                    DateFormatter.formatIndonesianDateTime(date),
                    style: GoogleFonts.inter(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff475569),
                    ),
                  ),
                ],
              ),
            ),

            // Card Body
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              child: Row(
                children: [
                  // Plant / Mascot Thumbnail
                  Container(
                    width: 58.w,
                    height: 58.w,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: const Color(0xffFFF1F2),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: (imageUrl.startsWith('http'))
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Image.asset(
                              "assets/img/mascot.png",
                              fit: BoxFit.contain,
                            ),
                          )
                        : Image.asset(
                            "assets/img/mascot.png",
                            fit: BoxFit.contain,
                          ),
                  ),
                  SizedBox(width: 14.w),

                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plantName,
                          style: GoogleFonts.inter(
                            fontSize: 14.5.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.h),

                        // 2 Columns of Sensor Stats
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Kel. tanah - ${soilMoisture.contains('%') ? soilMoisture : '$soilMoisture%'}",
                                    style: GoogleFonts.inter(
                                      fontSize: 11.sp,
                                      color: const Color(0xff64748B),
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    "Kel. udara - ${airMoisture.contains('%') ? airMoisture : '$airMoisture%'}",
                                    style: GoogleFonts.inter(
                                      fontSize: 11.sp,
                                      color: const Color(0xff64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "pH - $ph",
                                    style: GoogleFonts.inter(
                                      fontSize: 11.sp,
                                      color: const Color(0xff64748B),
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    "Suhu - ${temperature.contains('°C') ? temperature : '$temperature°C'}",
                                    style: GoogleFonts.inter(
                                      fontSize: 11.sp,
                                      color: const Color(0xff64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
