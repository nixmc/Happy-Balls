var serial;
var port = "/dev/cu.usbmodemfa131";

var destroy = function() {
    if (serial && serial.end) {
        serial.end();
    }
};

void setup() {
    size(1, 1);
    // begin serial
    serial = (document.getElementById("seriality")).Seriality();
    serial.begin(port, 9600);
}

void draw() {
    if (serial && serial.available && serial.available()) {
        var data = serial.readLine();
        if (window.serialityCallback) {
            window.serialityCallback(data);
        }
    }
}

window.addEventListener("unload", destroy, false);
