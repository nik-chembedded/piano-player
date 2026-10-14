// Offline support: the app files are refreshed from the network when online,
// piano samples are kept once downloaded (they never change).
const SHELL = "shell-v1";
const SAMPLES = "samples-v1";
const SHELL_FILES = [
  "./",
  "index.html",
  "manifest.webmanifest",
  "icons/icon.svg",
  "icons/icon-192.png",
  "icons/icon-512.png",
  "https://cdn.jsdelivr.net/npm/@tonejs/midi@2.0.28/build/Midi.js"
];

self.addEventListener("install", (e) => {
  e.waitUntil(caches.open(SHELL).then((c) => Promise.all(SHELL_FILES.map((u) => c.add(u).catch(() => {})))));
  self.skipWaiting();
});

self.addEventListener("activate", (e) => {
  e.waitUntil(caches.keys().then((keys) => Promise.all(keys.filter((k) => k !== SHELL && k !== SAMPLES).map((k) => caches.delete(k)))));
  self.clients.claim();
});

self.addEventListener("fetch", (e) => {
  const req = e.request;
  if (req.method !== "GET") return;
  const url = new URL(req.url);

  if (url.pathname.includes("/samples/")) {
    e.respondWith(caches.open(SAMPLES).then(async (c) => {
      const hit = await c.match(req);
      if (hit) return hit;
      const res = await fetch(req);
      if (res.ok) c.put(req, res.clone());
      return res;
    }));
    return;
  }

  // everything else (page, fonts, MIDI reader): network first, cached copy when offline
  e.respondWith(fetch(req).then((res) => {
    if (res.ok || res.type === "opaque") { const copy = res.clone(); caches.open(SHELL).then((c) => c.put(req, copy)); }
    return res;
  }).catch(() => caches.match(req).then((hit) => hit || caches.match("index.html"))));
});
