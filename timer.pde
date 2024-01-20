//! MASLAB 2024 Timer Script
//! 
//! This code is in the public domain.

/// Create timer object
Timer t = new Timer();

/// Set minutes box
int minutes_location = 1920/2 - 120;
int minutes_width = 120;

/// Set colon box
int colon_location = 1920/2 - 20;

/// Set seconds box
int seconds_location = 1920/2 + 100;
int seconds_width = 160;

/// Set rectangle count
int rect_count = 180;

/// Initialize scoreboard
int red = 0;
int green = 0;

void setup() {
    /// Initialize window
    fullScreen();
    
    /// Set frame rate to 60 fps
    frameRate(60);
}

void draw() {
    /// Clear the screen
    background(0, 0, 0);
    
    if (keyPressed) {
        if (key == 'x') {
            t.reset();
            red = 0;
            green = 0;
        } else if (key == ' ') {
            t.tick();
        } else if (key == 'f') {
            red += 1;
        } else if (key == 'j') {
            green += 1;
        } else if (key == 'v') {
            red -= 1;
        } else if (key == 'n') {
            green -= 1;
        }
        
        delay(100);
    }

    /// Configure loading bar
    noFill();
    rectMode(CENTER);
    if (t.millis > 0) {
        stroke(255, 255, 255);
    } else {
        if (millis() % 1000 - 500 > 0) {
            stroke(255, 0, 0);
        } else {
            stroke(255, 255, 255);
        }
    }
    strokeWeight(1);
    
    /// Draw loading bar
    for (int i = 0; i < 1920 * t.permille() / 1000; i += 1920 / rect_count) {
        rect(i, 1080/2, 1, 1080/2);
    }
    
    /// Display backdrop
    fill(0, 0, 0);
    noStroke();
    rect(1920/2, 1080/2, 400, 160);
    
    /// Configure text
    fill(255, 255, 255);
    textSize(96);
    textAlign(CENTER, CENTER);
    
    /// Display timer
    text(t.minutes(), minutes_location, 1080/2);
    text(":", colon_location, 1080/2 - 8);
    text(t.seconds(), seconds_location, 1080/2);
    
    /// Configure boxes
    noFill();
    stroke(255, 0, 0);
       
    /// Display boxes
    rect(minutes_location, 1080/2, minutes_width, 120);
    rect(seconds_location, 1080/2, seconds_width, 120);
    
    /// Configure & display scoreboard
    textSize(48);
    fill(255, 0, 0);
    text("Red: " + red, 1920/2, 100);
    fill(0, 255, 0);
    text("Green: " + green, 1920/2, 1080 - 100);
    
    /// Update timer
    t.update();
}

class Timer {
    /// Number of milliseconds left on the timer
    int millis;
    
    /// Number of milliseconds after program start that
    /// this timer started running
    int start;
    
    /// Is the timer running?
    boolean running;
    
    /// Starting number of milliseconds on the timer
    int total;
    
    /// Construct a new Timer instance.
    Timer() {
        total = 180000;
        start = millis();
        millis = total;
        running = false;
    }
    
    /// Update the timer.
    void update() {       
        if (!running) {
            return;
        }
        
        millis = total - millis() + start;
        
        if (millis < 0) {
            millis = 0;
        }
    }
    
    int minutes() {
        return floor(millis / 60000);
    }
    
    int seconds() {
        return floor((millis / 1000) % 60);
    }
    
    int permille() {
        return round(1000 * (1 - float(millis) / float(total)));
    }
    
    /// Reset the timer.
    void reset() {
        millis = total;
        running = false;
    }
    
    /// Start the timer.
    void tick() {
        if (running) {
            return;
        }
        
        start = millis();
        running = true;
    }
}
