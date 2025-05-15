part of 'custom_text.dart';

enum TypographyStyle {
  H1(h1),
  H2(h2),
  H3(h3),
  H4(h4),
  H5(h5),
  C1(c1),
  C2(c2),
  C3(c3),
  P1(p1),
  P2(p2),
  P3(p3),
  L1(l1),
  L2(l2),
  L3(l3),
  A1(a1),
  A2(a2),
  P4(p4),
  P5(p5);

  const TypographyStyle(this.value);

  final TextStyle value;
}
