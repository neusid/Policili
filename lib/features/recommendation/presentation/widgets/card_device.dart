import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CardDevice extends StatelessWidget {
  const CardDevice({
    super.key,
    this.logo = "Mm",
    required this.labelName,
    required this.labelValue,
    this.status = "Success",
  });

  final String logo;
  final String labelName;
  final String labelValue;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 11.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Signature Red IoT Icon Box
              Container(
                width: 58.w,
                decoration: const BoxDecoration(
                  color: Color(0xffFF2020),
                ),
                padding: EdgeInsets.all(14.w),
                child: Center(
                  child: Image.asset(
                    "assets/img/iot.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Metric Details
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        labelName,
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff64748B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        labelValue,
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Status Chip
              Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xffECFDF5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xff10B981).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff059669),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
