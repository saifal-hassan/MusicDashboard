
Table listeningData;

float graphLeft = 90;
float graphRight = 1140;
float graphTop = 110;
float graphBottom = 680;

float maxMinutes = 50;

void setup() {
  size(1200, 800);

  listeningData = loadTable("listening_data.csv", "header");

  println("Number of observations: " + listeningData.getRowCount());

  // This helps me calculate the largest possible minutes listened
  for (TableRow row : listeningData.rows()) {
    String duration = row.getString("minutesListened");

    if (duration != null && duration.trim().length() > 0) {
      float minutes = float(duration);

      if (minutes > maxMinutes) {
        maxMinutes = minutes;
      }
    }
  }

  // Maximum scaling for the graph is rounded to the nearest 50
  maxMinutes = ceil(maxMinutes / 50) * 50;
}

void draw() {
  background(20);

  // Page title
  fill(255);
  textSize(27);
  textAlign(LEFT);
  text("Listening Activity", 90, 48);

  fill(160);
  textSize(13);
  text("Music listening history | October 19-29, 2026", 90, 75);

  // Lines along each axis i have to draw
  stroke(65);
  fill(190);
  textSize(12);
  textAlign(RIGHT, CENTER);

  for (int i = 0; i <= 5; i++) {
    float y = map(i, 0, 5, graphBottom, graphTop);

    line(graphLeft, y, graphRight, y);

    float value = map(i, 0, 5, 0, maxMinutes);
    text(int(value), graphLeft - 15, y);
  }

  // This is the x axis label
  textAlign(CENTER, CENTER);

  for (int day = 19; day <= 29; day++) {
    float x = map(day, 19, 29, graphLeft, graphRight);

    fill(190);
    text(day, x, graphBottom + 22);
  }

  
  fill(220);
  textSize(14);
  text("Date (October 2026)",
       (graphLeft + graphRight) / 2, 755);

  pushMatrix();
  translate(25, (graphTop + graphBottom) / 2);
  rotate(-HALF_PI);
  text("Minutes Listened", 0, 0);
  popMatrix();

  String hoveredSong = "";
  String hoveredArtist = "";
  String hoveredGenre = "";
  String hoveredDate = "";
  String hoveredDuration = "";

  boolean songHovered = false;

  // This reeads and draws every observation
  for (int i = 0; i < listeningData.getRowCount(); i++) {

    TableRow row = listeningData.getRow(i);

    String date = row.getString("Date");
    String song = row.getString("Song");
    String artist = row.getString("Artist");
    String genre = row.getString("Genre");
    String duration = row.getString("minutesListened");

    // I implemented a use case where duration is negligible
    if (duration == null || duration.trim().length() == 0) {
      continue;
    }

    float minutes = float(duration);

    // Checks the date from the data
    int day = int(date.substring(8, 10));

    // This converts data into screen coordinates
    float x = map(day, 19, 29, graphLeft, graphRight);
    float y = map(minutes, 0, maxMinutes, graphBottom, graphTop);

    // Offsets each dot
    x += (i % 5 - 2) * 4;

    // Assign colour according to its genre
    if (genre.equals("Rage")) {
      fill(235, 75, 75);
    } else if (genre.equals("Trap")) {
      fill(65, 145, 235);
    } else if (genre.equals("Ambient")) {
      fill(155, 105, 225);
    } else if (genre.equals("Alternative rap")) {
      fill(235, 165, 65);
    } else if (genre.equals("EDM")) {
      fill(55, 205, 180);
    } else if (genre.equals("Dancehall")) {
      fill(235, 105, 170);
    } else if (genre.equals("Anime soundtrack")) {
      fill(235, 205, 75);
    } else if (genre.equals("Movie soundtrack")) {
      fill(150, 190, 210);
    } else if (genre.equals("Hip-hop")) {
      fill(100, 200, 110);
    } else if (genre.equals("Cloud rap")) {
      fill(190, 155, 220);
    } else {
      fill(200);
    }

    if (dist(mouseX, mouseY, x, y) < 10) {

      songHovered = true;

      hoveredSong = song;
      hoveredArtist = artist;
      hoveredGenre = genre;
      hoveredDate = date;
      hoveredDuration = duration;

      stroke(255);
      strokeWeight(2);

    } else {
      noStroke();
    }

    // Draw the circle
    circle(x, y, 10);

    strokeWeight(1);
  }

  // Hovering info
  if (songHovered) {

    float tooltipX = min(mouseX + 15, width - 275);
    float tooltipY = min(mouseY + 15, height - 130);

    fill(35);
    stroke(255);
    rect(tooltipX, tooltipY, 260, 115, 8);

    noStroke();
    fill(255);
    textAlign(LEFT);
    textSize(13);

    text(hoveredSong, tooltipX + 12, tooltipY + 22);
    text("Artist: " + hoveredArtist, tooltipX + 12, tooltipY + 42);
    text("Genre: " + hoveredGenre, tooltipX + 12, tooltipY + 62);
    text("Date: " + hoveredDate, tooltipX + 12, tooltipY + 82);
    text("Duration: " + hoveredDuration + " minutes",
         tooltipX + 12, tooltipY + 102);
  }
}
