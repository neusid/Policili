import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CardDevice extends StatelessWidget {
  const CardDevice({
    super.key,
    required this.logo,
    required this.labelName,
    required this.labelValue,
    required this.status,
  });

  final String logo;
  final String labelName;
  final String labelValue;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 0.9.sw,
          height: 0.16.sw,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.w),
            color: const Color(0xffE9E9E9),
          ),
        ),
        Container(
          width: 0.7.sw,
          height: 0.16.sw,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.w),
            color: Colors.white,
          ),
          child: Row(
            children: [
              SizedBox(width: 65.w),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      labelName,
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      labelValue,
                      style: GoogleFonts.urbanist(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 0.16.sw,
          height: 0.16.sw,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(15.w),
          ),
          child: Padding(
            padding: EdgeInsets.all(15.w),
            child: Image.asset("assets/img/iot.png"),
          ),
        ),
      ],
    );
  }
}
