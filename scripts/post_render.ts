// Läuft automatisch nach jedem vollständigen `quarto render` (post-render):
// legt Weiterleitungen alter Adressen an und ergänzt die GitHub-Pages-Dateien.
import { join } from "stdlib/path";
import { copySync, ensureDirSync, existsSync } from "stdlib/fs";

const root = Deno.env.get("QUARTO_PROJECT_DIR") ?? Deno.cwd();
const docs = join(root, "docs");

const R: Record<string, string> = {
  "research/beratung/": "/anwendungen/kita.html",
  "research/software/": "/research/#software",
  "about.html": "/de/#profil",
  "software/": "/research/#software",
  "teaching/": "/research/#lehre",
  "en/about.html": "/en/#profile",
  "en/software/": "/en/research/#software",
  "en/teaching/": "/en/research/#teaching",
  "literacy.html": "/research/",
  "summits.html": "/research/",
  "page2/": "/", "page3/": "/", "page4/": "/",
  "blog/archives.html": "/", "blog/categories.html": "/", "blog/tags.html": "/",
  "blog/2017/07/kita-de/": "/anwendungen/kita.html",
  "blog/2017/12/traffic-de/": "/research/",
  "blog/2018/05/feedingamerica-de/": "/anwendungen/lebensmittelspenden.html",
  "blog/2018/12/cwpe1521-de/": "/research/#mikrofinanz",
  "blog/2017/07/kita/": "/en/applications/childcare.html",
  "blog/2018/05/feedingamerica/": "/en/applications/food-donations.html",
  "blog/2018/12/cwpe1521/": "/en/research/#microfinance",
  "blog/2018/09/schoolchoice/": "/en/applications/schools.html",
  "blog/2018/01/traffic/": "/en/research/",
  "blog/2017/09/valueofstatistics/": "/en/research/",
  "blog/2017/05/bigdata/": "/en/research/",
  "blog/2017/04/literacy/": "/en/research/",
  "blog/2016/11/aidflows/": "/en/research/",
  "blog/2016/04/dataviz/": "/en/research/",
  "blog/2017/03/matchingMarkets/": "/en/research/#software",
  "blog/2016/06/matchingMarkets2/": "/en/research/#software",
  "blog/2016/09/matchingMarkets3/": "/en/research/#software",
};
for (const c of ["quant1", "quant2", "matching", "consulting", "econometrics1", "econometrics2", "statistics",
  "finance", "mathematics", "viz", "replication", "games", "faq", "slides"]) R[`teaching/${c}/`] = "/research/#lehre";

let n = 0;
for (const [old, target] of Object.entries(R)) {
  const file = join(docs, old.endsWith("/") ? old + "index.html" : old);
  if (existsSync(file)) continue; // nie eine echte Seite überschreiben
  ensureDirSync(join(file, ".."));
  Deno.writeTextFileSync(file, `<!DOCTYPE html>
<html lang="de"><head><meta charset="utf-8">
<title>Weitergeleitet</title>
<link rel="canonical" href="https://klein.uk${target}">
<meta http-equiv="refresh" content="0; url=${target}">
<meta name="robots" content="noindex">
</head><body><p>Diese Seite ist umgezogen: <a href="${target}">${target}</a></p></body></html>
`);
  n++;
}
Deno.writeTextFileSync(join(docs, ".nojekyll"), "");
copySync(join(root, "CNAME"), join(docs, "CNAME"), { overwrite: true });
console.log(`${n} Weiterleitungen angelegt.`);

// 5 Suchmaschinen: Weiterleitungsseite aus der Sitemap nehmen, hreflang statisch eintragen
const sm = join(docs, "sitemap.xml");
if (existsSync(sm)) {
  Deno.writeTextFileSync(sm, Deno.readTextFileSync(sm)
    .replace(/\s*<url>\s*<loc>https:\/\/klein\.uk\/(index\.html)?<\/loc>[\s\S]*?<\/url>/, ""));
}
const PAIRS: [string, string][] = [
  ["de/index.html", "en/index.html"],
  ["research/index.html", "en/research/index.html"],
  ["anwendungen/index.html", "en/applications/index.html"],
  ["anwendungen/kita.html", "en/applications/childcare.html"],
  ["anwendungen/schule.html", "en/applications/schools.html"],
  ["anwendungen/lebensmittelspenden.html", "en/applications/food-donations.html"],
  ["anwendungen/umweltfoerderung.html", "en/applications/environmental-subsidies.html"],
  ["medien.html", "en/media.html"],
  ["impressum.html", "en/legal.html"],
];
const url = (p: string) => "https://klein.uk/" + p.replace(/index\.html$/, "");
for (const [de, enp] of PAIRS) {
  const tags = `<link rel="alternate" hreflang="de" href="${url(de)}">\n` +
    `<link rel="alternate" hreflang="en" href="${url(enp)}">\n` +
    `<link rel="alternate" hreflang="x-default" href="${url(enp)}">\n`;
  for (const f of [de, enp]) {
    const file = join(docs, f);
    if (!existsSync(file)) continue;
    const html = Deno.readTextFileSync(file);
    if (!html.includes('hreflang="x-default"')) Deno.writeTextFileSync(file, html.replace("</head>", tags + "</head>"));
  }
}
