import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:point_of_sell/resources/colors.dart';

class Styles {
  static final TextStyle appbarText = GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    fontSize: 20,
  );

  static final TextStyle buttonText = GoogleFonts.poppins(
      fontWeight: FontWeight.w500, fontSize: 14, color: Colors.white);

  static final TextStyle description = GoogleFonts.poppins(
    fontSize: 12,
    color: lightGray,
  );

  static final TextStyle title = GoogleFonts.poppins(
    fontSize: 14,
    color: softBlack,
  );

// static final TextStyle subtitle =
//     GoogleFonts.plusJakartaSans(fontSize: 14, color: primaryText);
//
// static final TextStyle category = GoogleFonts.plusJakartaSans(
//     fontSize: 12, fontWeight: FontWeight.w500, color: secondaryText);
}
