// Erzeugt aus data/publications.yml die Publikationsbausteine (HTML) für DE und EN.
// Läuft automatisch vor jedem Rendern (pre-render) mit dem in Quarto enthaltenen Deno; kein Python nötig.
import { parse } from "stdlib/yaml";
import { join } from "stdlib/path";
import { ensureDirSync } from "stdlib/fs";

const root = Deno.env.get("QUARTO_PROJECT_DIR") ?? Deno.cwd();
type Pub = { authors: string; year: number; title: string; venue: string; url?: string;
  topic: string; type: string; selected?: boolean; journal?: string; current?: boolean };
const pubs = parse(Deno.readTextFileSync(join(root, "data/publications.yml"))) as Pub[];

const TOPIC: Record<string, Record<string, string>> = {
  de: { kita: "Kita", schule: "Schule", referendariat: "Referendariat", tafel: "Lebensmittelspenden",
        umwelt: "Umweltförderung", entwicklung: "Entwicklung und Mikrofinanz", statistik: "Statistik und Daten", marktdesign: "Marktdesign allgemein" },
  en: { kita: "Childcare", schule: "Schools", referendariat: "Teacher traineeship", tafel: "Food donations",
        umwelt: "Environmental subsidies", entwicklung: "Development and microfinance", statistik: "Statistics and data", marktdesign: "Market design, general" },
};
const TYPE: Record<string, Record<string, string>> = {
  de: { article: "Zeitschriftenartikel", wp: "Diskussionspapiere", policy: "Policy Briefs", practice: "Fachartikel", report: "Berichte", book: "Bücher" },
  en: { article: "Journal articles", wp: "Working papers", policy: "Policy briefs", practice: "Practitioner articles", report: "Reports", book: "Books" },
};
const WORD: Record<string, Record<string, string>> = {
  de: { with: "Mit", and: "und", single: "Einzelautor", all: "Alle" },
  en: { with: "With", and: "and", single: "Single-authored", all: "All" },
};
const ORDER = ["article", "wp", "policy", "practice", "report", "book"];
const e = (s: unknown) => String(s).replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");

function coauthors(p: Pub, lang: string) {
  const names = p.authors.split(",").map((a) => a.trim()).filter((a) => a && a !== "T. Klein");
  if (names.length === 0) return WORD[lang].single;
  if (names.length === 1) return `${WORD[lang].with} ${names[0]}`;
  return `${WORD[lang].with} ${names.slice(0, -1).join(", ")} ${WORD[lang].and} ${names[names.length - 1]}`;
}
const venue = (p: Pub, lang: string) =>
  lang === "en" ? p.venue.replace("Kap.", "ch.").replace("Vignette zum R-Paket", "Vignette to R package") : p.venue;
const link = (p: Pub, cls = "t") =>
  p.url ? `<a class="${cls}" href="${e(p.url)}">${e(p.title)}</a>` : `<span class="${cls}">${e(p.title)}</span>`;
const wrap = (body: string) => "```{=html}\n" + body + "\n```\n";
const row = (p: Pub, n: number, lang: string, topicAttr = false) =>
  `<li${topicAttr ? ` data-topic="${p.topic}"` : ""}><span class="n">${n}</span><div>${link(p)}<div class="meta">` +
  `<em>${e(venue(p, lang))}</em> (${p.year}) · ${e(p.authors)}</div></div></li>`;

function build(lang: string, outdir: string) {
  const out = join(root, outdir);
  ensureDirSync(out);
  const srt = [...pubs].sort((a, b) => (b.year - a.year) || a.title.localeCompare(b.title));

  // 1 Aktuelle Diskussionspapiere als Karten (Reihenfolge wie in der Datei)
  const cur = pubs.filter((p) => p.current);
  Deno.writeTextFileSync(join(out, "papers.md"), wrap(`<ol class="papers">` + cur.map((p) =>
    `<li>${link(p)}<p class="meta">${e(coauthors(p, lang))} · ${e(venue(p, lang))}, ${p.year}</p></li>`).join("") + `</ol>`));

  // 2 Ausgewählte Publikationen
  const sel = srt.filter((p) => p.selected);
  Deno.writeTextFileSync(join(out, "selected.md"), wrap(`<ul class="selected">` + sel.map((p) =>
    `<li><span class="j">${e(p.journal ?? "")}</span><div>${link(p)}<p class="meta">${e(coauthors(p, lang))} (${p.year})</p></div></li>`).join("") + `</ul>`));

  // 3 Vollständige Liste mit Themenfilter
  const used = Object.keys(TOPIC[lang]).filter((t) => pubs.some((p) => p.topic === t));
  let html = `<div class="chips" role="group"><button type="button" data-topic="" aria-pressed="true">${WORD[lang].all}</button>` +
    used.map((t) => `<button type="button" data-topic="${t}" aria-pressed="false">${e(TOPIC[lang][t])}</button>`).join("") + `</div>`;
  for (const ty of ORDER) {
    const items = srt.filter((p) => p.type === ty);
    if (!items.length) continue;
    html += `<div class="pubgroup" data-group="${ty}"><h3>${e(TYPE[lang][ty])}</h3><ol class="publist">` +
      items.map((p, i) => row(p, items.length - i, lang, true)).join("") + `</ol></div>`;
  }
  html += `<script>
document.querySelectorAll('.chips button').forEach(function(b){b.addEventListener('click',function(){
  var t=b.dataset.topic; document.querySelectorAll('.chips button').forEach(function(x){x.setAttribute('aria-pressed', x===b?'true':'false');});
  document.querySelectorAll('.publist li').forEach(function(li){li.hidden = t && li.dataset.topic!==t;});
  document.querySelectorAll('.pubgroup').forEach(function(g){g.hidden = !g.querySelector('li:not([hidden])');});
});});
</script>`;
  Deno.writeTextFileSync(join(out, "all.md"), wrap(html));

  // 4 Themenlisten für die Anwendungsseiten
  for (const t of Object.keys(TOPIC[lang])) {
    const items = srt.filter((p) => p.topic === t);
    Deno.writeTextFileSync(join(out, `topic-${t}.md`),
      wrap(`<ol class="publist">` + items.map((p, i) => row(p, items.length - i, lang)).join("") + `</ol>`));
  }
  console.log(`${outdir}: ${pubs.length} Publikationen, ${cur.length} aktuelle, ${sel.length} ausgewählte`);
}

build("de", "_partials");
build("en", "en/_partials");
