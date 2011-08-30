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

$('document').ready(function(){  
  addChunk(10,  15,   0);
  addChunk(12,  1,    5);
  addChunk(5,   7,    10);
  addChunk(7,   5,    15);
  addChunk(20,  15,   20);
  addChunk(16,  10,   25);
  addChunk(25,  20,   30);
  addChunk(100, 100,  35);
  addChunk(155, 65,   40);
  addChunk(155, 65,   45);
  addChunk(65,  155,  50);
  addChunk(15,  45,   55);
  addChunk(5,   45,   0);
});

var hour_hapiness = 0;
var hour_sadness = 0;

var zero_pad = function(num,count)
{
  var numZeropad = num + '';
  while(numZeropad.length < count) {
    numZeropad = "0" + numZeropad;
  }
  return numZeropad;
}

var addChunk = function(happy, sad, time){
  time = time == null ? new Date : time;
  if(happy == 0 && sad == 0){
    happy = 1;
    sad = 1;
  }
  
  var $graphs = $('#graphs');
  var $chunks = $('#chunks');
  var total = happy + sad;
  
  var chunks_width = parseInt($chunks.width()) - 17; // hardcoded padding
  var one_percent = chunks_width / total;
  var happy_percent = Math.floor(happy * one_percent);
  var sad_percent = Math.floor(sad * one_percent);
  
  if(happy_percent + sad_percent < chunks_width){
    sad_percent = sad_percent + chunks_width % (happy_percent + sad_percent);
  }
  

  //var time = new Date;
  //time.getMinutes();
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
}