import 'package:flutter/material.dart';

/* -------------------------- Applitacion env keys -------------------------- */
const String kApplicationId = 'UVX7IXCOS1';
const String kApiKey = '8314848f755b147ef47a60b462eb575a';

/* --------------------------------- Colors --------------------------------- */

const Color kFontWhite = Color(0xFFFFFFFF);
const Color kFontBlack = Color(0xFF000000);

const Color kPrimaryColor = Color(0xFF438C73);
const Color kSecondaryColor = Color(0xFF83BD41);
const Color kSecondaryLightColor = Color(0xFF9AE04B);
const Color kAccentColor = Color(0xFFEC5444);
const Color kCardColor = Color(0xFF55917C);

const RadialGradient kRadialPrimaryBg = RadialGradient(
  center: Alignment.topCenter,
  colors: [
    kPrimaryColor,
    Color(0xFF34705B),
  ],
  radius: 1.5,
);

List<Shadow> kButtonAccentShadows = [
  Shadow(
    color: kAccentColor,
    blurRadius: 7,
    offset: Offset(0, 0),
  ),
  Shadow(
    color: Colors.white.withOpacity(0.2),
    blurRadius: 3,
    offset: Offset(0, 0),
  ),
];

BoxDecoration kCardDecoration = BoxDecoration(
    color: Colors.white.withOpacity(0.9),
    borderRadius: BorderRadius.circular(8.0));

/* ------------------------------- Dimensions ------------------------------- */

const double kDefaultPadding = 21.0;
const double kDefaultBorderRadius = 8.0;

/* --------------------------------- Factors -------------------------------- */

const double kTextOpacityFactor = 0.5;
