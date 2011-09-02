var initSketch = function(sketchId) {
    if (!window[sketchId]) {
        window[sketchId] = Processing.getInstanceById(sketchId);
    }
    return window[sketchId];
};

var dropBallIntoBucket = function(bucketId) {
    var bucket = initSketch(bucketId);
    bucket.initParticle();
};

var updateLocation = function(location, happinessIncrease, unhappinessIncrease) {
    var map = initSketch("map");
    map.updatePie(location, happinessIncrease, unhappinessIncrease);
};

var updateLogo = function(happinessIncrease, unhappinessIncrease) {
    var logo = initSketch("logo");
    logo.incrementCounts(happinessIncrease, unhappinessIncrease);
};

$('document').ready(function(){  
  var timer = setInterval(function(){ addChunk(hour_hapiness, hour_sadness); }, 300000);
  fetch_tweets();
});

$(window).bind("hashchange", function(){
    var hash = document.location.hash,
        action = hash.substr(1),
        actions = {
            "!truncate-db" : truncateDB,
            "!foo" : (function(){console.log("bar");})
        };
    if (action in actions) {
        actions[action]();
    }
});

// global variables to hold the incremental counts
var hour_hapiness = 0;
var hour_sadness = 0;

var increment_chunk_count = function(happy, sad){
  hour_hapiness = hour_hapiness + happy;
  hour_sadness = hour_sadness + sad;
  console.log("hour_sadness: " + hour_hapiness);
  console.log("hour_sadness: " + hour_sadness);
};

var zero_pad = function(num,count)
{
  var numZeropad = num + '';
  while(numZeropad.length < count) {
    numZeropad = "0" + numZeropad;
  }
  return numZeropad;
};

var addChunk = function(happy, sad, time){
  time = time == null ? new Date : time;
  
  if(happy == 0 && sad == 0){
    happy = 1;
    sad = 1;
  }
  
  var $graphs = $('#graphs');
  var $chunks = $('#chunks');
  var total = happy + sad;
  
  var chunks_width = parseInt($chunks.width()) - 41; // hardcoded padding for clock?
  var one_percent = chunks_width / total;
  var happy_percent = Math.floor(happy * one_percent);
  var sad_percent = Math.floor(sad * one_percent);
  
  if(happy_percent + sad_percent < chunks_width){
    sad_percent = sad_percent + chunks_width % (happy_percent + sad_percent);
  }

  if(time.getMinutes){
    time = time.getMinutes();
  }
  time = Math.round(parseInt(time)/5)*5 + 5;
  if(time >= 60){
    time = 0;
  }
  var $new_li = $("<li class='mins_" + zero_pad(time,2) + " new_chunk'> \
      <div class='happy_chunk chunk'></div> \
      <div class='sad_chunk chunk'></div> \
    </li>");

  $new_li.children("div.happy_chunk").css("width", happy_percent + "px");
  $new_li.children("div.sad_chunk").css("width", sad_percent + "px");
  
  if($('#chunks li').length >= 12){
    $('#chunks li:last').remove();
  }
  $chunks.prepend($new_li);
  $('#chunks li:first').animate({ opacity: 1.0, top: 0 }, 1000);
  
  hour_hapiness = 0;
  hour_sadness = 0;
};

var serialityCallback = function(data) {
    var re = /Location: (\d+) happy: (\d+) sad: (\d+)/;
    console.log("Received:", data);
    var match = re.exec(data);
    if (match) {
        var location = parseInt(match[1]),
            happiness = parseInt(match[2]),
            unhappiness = parseInt(match[3]);
        getHappinessScore(location, {
            onSuccess: function(ev) {
                var result = ev.target.result;
                console.log(result);
                if (!result || result.happiness < happiness || result.unhappiness < unhappiness) {
                    // Something's changed
                    var happinessIncrease = happiness - (result && result.happiness || 0),
                        unhappinessIncrease = unhappiness - (result && result.unhappiness || 0);
                    console.log("happinessIncrease:", happinessIncrease);
                    console.log("unhappinessIncrease:", unhappinessIncrease);
                    increment_chunk_count(happinessIncrease, unhappinessIncrease);
                    
                    // Record change...
                    putHappinessScore({
                        location: location,
                        happiness: happiness,
                        unhappiness: unhappiness,
                    }, {
                        onSuccess: function(ev) {
                            console.log("Scores updated for location:", location);
                        },
                        onError: console.log
                    });
                    
                    // Update location pie
                    // console.log("Updating location", location, happinessIncrease, unhappinessIncrease)
                    updateLocation(location, happinessIncrease, unhappinessIncrease);
                    
                    // Update logo
                    updateLogo(happinessIncrease, unhappinessIncrease);
                    
                    // Send change to server...
                    // $ curl -i -d "location=1&happiness=42&unhappiness=0" http://happy-balls.local/server/happiness/
                    $.post("http://" + document.location.hostname + "/server/happiness/", {
                        location: location, 
                        happiness: happinessIncrease, 
                        unhappiness: unhappinessIncrease
                    });
                    
                    // Drop appropriate number of balls into buckets...
                    while (happinessIncrease > 0) {
                        dropBallIntoBucket("happyBucket");
                        happinessIncrease--;
                    }
                    while (unhappinessIncrease > 0) {
                        dropBallIntoBucket("unhappyBucket");
                        unhappinessIncrease--;
                    }
                }
            },
            onError: console.log
        });
    }
};

var last_tweet_id = "0";
var fetch_tweets = function(){
  twitterlib.search('#happballs', { filter: 'happy OR sad OR ":)" OR ":("', since_id: last_tweet_id }, function (tweets, options) {
    last_tweet_id = tweets[0].id_str;
    for(var x = 0; x < tweets.length; x = x + 1){
      var tweet = tweets[x];
      console.log(tweet.created_at + " : " + tweet.id);
      var re = new RegExp("\\w+");  
      var re = /\w+/;
      //if(tweet.text)
    }
  });

};