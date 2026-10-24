/* Sprachmenü oben links („EN 🇬🇧  DE 🇩🇪“) und englische Navigation auf /en/-Seiten.
   Alle Seiten liegen in einem Quarto-Projekt; die Navigation ist dort deutsch definiert
   und wird hier für englische Seiten übersetzt und auf die englischen Seiten umgelenkt. */
(function () {
  var map = {
    "/de/": "/en/",
    "/research/": "/en/research/",
    "/anwendungen/": "/en/applications/",
    "/anwendungen/kita.html": "/en/applications/childcare.html",
    "/anwendungen/schule.html": "/en/applications/schools.html",
    "/anwendungen/lebensmittelspenden.html": "/en/applications/food-donations.html",
	"/anwendungen/umweltfoerderung.html": "/en/applications/environmental-subsidies.html",
    "/medien.html": "/en/media.html",
    "/impressum.html": "/en/legal.html"
  };
  var labels = {
    "Startseite": "Home", "Forschung": "Research", "Anwendungen": "Applications", "Überblick": "Overview",
    "Kitaplatzvergabe": "Childcare places", "Schulplatzvergabe": "School places",
    "Lebensmittelspenden": "Food donations", "Umweltförderung": "Environmental subsidies",
    "Medien": "Media", "Kontakt": "Contact"
  };
  var rev = {};
  Object.keys(map).forEach(function (k) { rev[map[k]] = k; });
  var norm = function (p) { return p.replace(/index\.html$/, ""); };

  var path = norm(location.pathname);
  var isEn = path.indexOf("/en/") === 0;
  var dePath = isEn ? (rev[path] || "/de/") : path;
  var enPath = isEn ? path : (map[path] || "/en/");

  // 1 Navigation: Kontakt springt zum Fuß der aktuellen Seite; auf /en/ übersetzen und umlenken
  var navs = document.querySelectorAll(".navbar-nav");
  document.querySelectorAll(".navbar a.nav-link, .navbar a.dropdown-item").forEach(function (a) {
    var href = a.getAttribute("href") || "";
    if (href.indexOf("#kontakt") !== -1) a.setAttribute("href", isEn ? "#contact" : "#kontakt");
    else if (isEn) {
      var target = map[norm(a.pathname)];
      if (target) a.setAttribute("href", target);
    }
    if (isEn) {
      var span = a.querySelector(".menu-text") || a;
      var t = span.textContent.trim();
      if (labels[t]) span.textContent = labels[t];
    }
  });
  
  // Aktiven Menüpunkt markieren, auf englischen und deutschen Seiten einheitlich
  // (Quarto kennt nur die deutschen Ziele und markiert das Untermenü nicht)
  document.querySelectorAll(".navbar .active").forEach(function (el) { el.classList.remove("active"); });
  document.querySelectorAll(".navbar a.nav-link, .navbar a.dropdown-item").forEach(function (a) {
    if ((a.getAttribute("href") || "").charAt(0) === "#" || norm(a.pathname) !== path) return;
    a.classList.add("active");
    var dd = a.closest(".dropdown");
    if (dd) { var t = dd.querySelector(".dropdown-toggle"); if (t) t.classList.add("active"); }
  });
  
  navs.forEach(function (n) { n.classList.add("is-translated"); });

  // 2 Sprachmenü oben links
  function item(code, label, href, flag, active) {
    var a = document.createElement("a");
    a.href = href + location.hash;
    a.className = "lang-item" + (active ? " is-active" : "");
    a.lang = code; a.hreflang = code;
    a.setAttribute("aria-label", label);
    if (active) a.setAttribute("aria-current", "true");
    a.innerHTML = code.toUpperCase() + ' <img src="/assets/img/' + flag + '" alt="" width="22" height="17">';
    return a;
  }
  var nav = document.createElement("nav");
  nav.className = "lang-switch";
  nav.setAttribute("aria-label", isEn ? "Language" : "Sprache");
  nav.appendChild(item("en", "English", enPath, "flag-gb.svg", isEn));
  nav.appendChild(item("de", "Deutsch", dePath, "flag-de.svg", !isEn));
  var container = document.querySelector(".navbar .navbar-container");
  if (container) container.insertBefore(nav, container.firstChild);

})();
