var db,
    addHappinessScore,
    getHappinessScore,
    putHappinessScore,
(function() {
    // See IndexedDB primer here: https://developer.mozilla.org/en/IndexedDB/IndexedDB_primer
    var request = mozIndexedDB.open("HappyBalls");
    request.onsuccess = function(event) {
      db = request.result;
      db.onerror = function(event) {
        alert("Database error: " + event.target.errorCode);
      };
      if (db.version != "1.0") {
        request = db.setVersion("1.0");
        request.onerror = function(event) {
          // Handle errors.
        };
        request.onsuccess = function(event) {
          // Set up the database structure here!
          var objectStore = db.createObjectStore("happiness", { keyPath: "location" });
        };
      }
      addHappinessScore = function(happinessScore, opts) {
          var transaction = db.transaction(["happiness"], IDBTransaction.READ_WRITE),
              objectStore = transaction.objectStore("happiness"),
              req = objectStore.add(happinessScore);
          req.onsuccess = opts && opts.onSuccess || undefined;
          req.onerror = opts && opts.onError || undefined;
          return req;
      };
      getHappinessScore = function(location, opts) {
          var req = db.transaction("happiness").objectStore("happiness").get(location);
          req.onsuccess = opts && opts.onSuccess || undefined;
          req.onerror = opts && opts.onError || undefined;
          return req;
      };
      putHappinessScore = function(happinessScore, opts) {
          var transaction = db.transaction(["happiness"], IDBTransaction.READ_WRITE),
              objectStore = transaction.objectStore("happiness"),
              req = objectStore.put(happinessScore);
          req.onsuccess = opts && opts.onSuccess || undefined;
          req.onerror = opts && opts.onError || undefined;
          return req;
      };
    };            
})();
