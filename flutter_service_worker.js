'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "5cc72f6ee314fcda63c10d14d3ad0310",
"assets/assets/images/admin.png": "7ff55d8bb06862192e4249550e9726d0",
"assets/assets/images/agent.png": "ed4759675eab13d17a34aa82d73d8301",
"assets/assets/images/blue-bg.jpg": "f6b8e3298567b9f575d206705d125504",
"assets/assets/images/calc.png": "5b8979e96cfc61aef9e5374f29f1a20f",
"assets/assets/images/client.png": "35331901321ccfb7c7cf455adbf889eb",
"assets/assets/images/door.jpg": "747aef915bd5aab0552cab18349abe5c",
"assets/assets/images/grey-bg.jpg": "90474df2d7b2ed3af1d2595272a47a48",
"assets/assets/images/grey-bg2.jpg": "940c5a4ac142d9ff20eadd90d2de68c6",
"assets/assets/images/grey-bg3.png": "a44fa95ab5dd0ed7d15027b095b91a2e",
"assets/assets/images/logo/saapp_icon.png": "f5a71f56f91408a5afd5a9bf36cd8df4",
"assets/assets/images/ocean-bg.jpg": "7a2df58ff06632ec6a37f0436a8b0389",
"assets/assets/images/onboarding/onboarding-0.png": "48d48aaaa42627c5b745113ab040acd1",
"assets/assets/images/onboarding/onboarding-1.gif": "f775f6ef8a106431a0e07f9cd77293ae",
"assets/assets/images/onboarding/onboarding-2.gif": "b7e1af963080c959f1696777c9e6f400",
"assets/assets/images/onboarding/onboarding-3.gif": "6aba81fa39a9701d63fa067a638864c2",
"assets/assets/images/password.png": "d4d6b5c91fa7659a1bdf2ea10bb98ed4",
"assets/assets/images/pattern.jpg": "f926fa8d904092124fb9306514d1fe02",
"assets/assets/images/person.png": "ac9eefb28d8c0cde1b8005ad1eb360f1",
"assets/assets/images/refer.png": "6bb00315713ed1c81490b08d56b33b46",
"assets/assets/images/referrals.png": "ad2a583f032476708e4f1197a25ec73d",
"assets/assets/images/splash/splash_screen.png": "48d48aaaa42627c5b745113ab040acd1",
"assets/assets/images/test_mode_cover.png": "f9deac3ffde71c949b9a7f1c410b40f1",
"assets/assets/images/whitey.jpg": "820f518c461ebb1979d20c4598e27330",
"assets/assets/privacy_policy.md": "817f421e90da21faade13e6c13559f50",
"assets/assets/terms_of_service.md": "9c1daa44592399ac256a71176478749a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "95db9098c58fd6db106f1116bae85a0b",
"assets/NOTICES": "1186a57fca462a6e9de2fbe2f495b2ec",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/shaders/ink_sparkle.frag": "759600659906258b9719e80da859321e",
"canvaskit/canvaskit.js": "2bc454a691c631b07a9307ac4ca47797",
"canvaskit/canvaskit.wasm": "bf50631470eb967688cca13ee181af62",
"canvaskit/profiling/canvaskit.js": "38164e5a72bdad0faa4ce740c9b8e564",
"canvaskit/profiling/canvaskit.wasm": "95a45378b69e77af5ed2bc72b2209b94",
"favicon.png": "0adb04cdffdd3fee39513ded03d0be49",
"flutter.js": "f85e6fb278b0fd20c349186fb46ae36d",
"icons/Icon-192.png": "5462436bcc232b3469e3d8ed4a313273",
"icons/Icon-512.png": "89a630a5c6cc932486683ce3fc9362df",
"icons/Icon-maskable-192.png": "5462436bcc232b3469e3d8ed4a313273",
"icons/Icon-maskable-512.png": "89a630a5c6cc932486683ce3fc9362df",
"index.html": "14a937ad4d1de1fde94ed2ceb8b22c4b",
"/": "14a937ad4d1de1fde94ed2ceb8b22c4b",
"main.dart.js": "1e64becb890bdc912342c2236d7adbca",
"manifest.json": "d51b5f2ff03ba7990ea5fe0f087170ef",
"splash/img/dark-1x.png": "2cc8d6d3c1164e40db9c2a1a27e1ad65",
"splash/img/dark-2x.png": "49b7253b2e2ded985493d71b864f27af",
"splash/img/dark-3x.png": "30a6823be86cd5179d48759a9b18ef46",
"splash/img/dark-4x.png": "99995e633c9a40321afa5d845b194fc8",
"splash/img/light-1x.png": "2cc8d6d3c1164e40db9c2a1a27e1ad65",
"splash/img/light-2x.png": "49b7253b2e2ded985493d71b864f27af",
"splash/img/light-3x.png": "30a6823be86cd5179d48759a9b18ef46",
"splash/img/light-4x.png": "99995e633c9a40321afa5d845b194fc8",
"splash/splash.js": "123c400b58bea74c1305ca3ac966748d",
"splash/style.css": "572591b9ed5e026aef4d0c64cb49223e",
"version.json": "a1f6d12aad0278edcb0732592fa976c5"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
