enum FontFamily {

  raleway(fontName: 'Raleway'),
  antic(fontName: 'Antic'),
  assistant(fontName: 'Assistant'),
  dancingScript(fontName: 'Dancing-Script'),
  baloo2(fontName: 'Baloo2'),
  boogaloo(fontName: 'Boogaloo'),
  cookie(fontName: 'Cookie'),
  dosis(fontName: 'Dosis'),
  lato(fontName: 'Lato'),
  montserrat(fontName: 'Montserrat'),
  openSansCondensed(fontName: 'OpenSans-Condensed'),
  oswald(fontName: 'Oswald'),
  poiretOne(fontName: 'PoiretOne'),
  sacramento(fontName: 'Sacramento'),
  spinnaker(fontName: 'Spinnaker'),
  sniglet(fontName: 'Sniglet'),
  zenOldMincho(fontName: 'ZenOldMincho'),
  defaultFont(fontName: 'default');

  const FontFamily({required this.fontName});
  final String fontName;
}

FontFamily? getFontFamilyFromName(String fontName) {
  return FontFamily.values.firstWhere((e) => e.fontName == fontName);
}