//%attributes = {}
  //Le contenu textuel d'un élément 'text' peut consister soit en données textuelles
  //directement incorporées dans l'élément 'text', soit du contenu de données
  //textuelles d'un élément appelé, où l'appel est spécifié avec un élément 'tref'.
C_TEXT:C284($Txt_HTML)

$Txt_HTML:="<svg width=\"10cm\" height=\"3cm\" viewBox=\"0 0 1000 300\"\r"\
+"     xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">\r"\
+"  <defs>\r"\
+"    <text id=\"TexteAppele\">\r"\
+"      Données textuelles appelées\r"\
+"    </text>\r"\
+"  </defs>\r"\
+"  <desc>Exemple tref01 - contenu textuel en-ligne et appelé</desc>\r"\
+"\r"\
+"  <text x=\"100\" y=\"100\" font-size=\"45\" fill=\"blue\" >\r"\
+"    Données textuelles en-ligne\r"\
+"  </text>\r"\
+"  <text x=\"100\" y=\"200\" font-size=\"45\" fill=\"red\" >\r"\
+"    <tref xlink:href=\"#TexteAppele\"/>\r"\
+"  </text>\r"\
+"\r"\
+"  <!-- Montre le contour du canevas avec un élément 'rect' -->\r"\
+"  <rect x=\"1\" y=\"1\" width=\"998\" height=\"298\"\r"\
+"        fill=\"none\" stroke=\"blue\" stroke-width=\"2\" />\r"\
+"</svg>\r"