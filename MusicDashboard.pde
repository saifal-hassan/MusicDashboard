
Table listeningData;

float graphLeft = 90;
float graphRight = 900;
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

  // Lines along each axis
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

  // Genre key in the top right
  drawGenreKey();

  String hoveredSong = "";
  String hoveredArtist = "";
  String hoveredGenre = "";
  String hoveredDate = "";
  String hoveredDuration = "";

  boolean songHovered = false;

  // This reads and draws every observation
  for (int i = 0; i < listeningData.getRowCount(); i++) {

    TableRow row = listeningData.getRow(i);

    String date = row.getString("Date");
    String song = row.getString("Song");
    String artist = row.getString("Artist");
    String genre = row.getString("Genre");
    String duration = row.getString("minutesListened");

    // Skip observations without a listening duration
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
      fill(239, 48, 48);
    } else if (genre.equals("Trap")) {
      fill(150, 59, 219);
    } else if (genre.equals("Ambient")) {
      fill(168, 230, 138);
    } else if (genre.equals("Alternative rap")) {
      fill(23, 43, 112);
    } else if (genre.equals("EDM")) {
      fill(101, 201, 245);
    } else if (genre.equals("Dancehall")) {
      fill(255, 20, 147);
    } else if (genre.equals("Anime soundtrack")) {
      fill(139, 0, 0);
    } else if (genre.equals("Movie soundtrack")) {
      fill(85, 184, 120);
    } else if (genre.equals("Hip-hop")) {
      fill(48, 16, 68);
    } else if (genre.equals("Cloud rap")) {
      fill(208, 208, 208);
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


// Displays the genre key
void drawGenreKey() {

  fill(255);
  textSize(14);
  textAlign(LEFT);
  text("GENRE KEY", 940, 120);

  // Rage
  fill(239, 48, 48);
  circle(950, 150, 10);
  fill(220);
  textSize(12);
  text("Rage", 965, 154);

  // Trap
  fill(150, 59, 219);
  circle(950, 180, 10);
  fill(220);
  text("Trap", 965, 184);

  // Ambient
  fill(168, 230, 138);
  circle(950, 210, 10);
  fill(220);
  text("Ambient", 965, 214);

  // Alternative rap
  fill(23, 43, 112);
  circle(950, 240, 10);
  fill(220);
  text("Alternative rap", 965, 244);

  // EDM
  fill(101, 201, 245);
  circle(950, 270, 10);
  fill(220);
  text("EDM", 965, 274);

  // Dancehall
  fill(255, 20, 147);
  circle(950, 300, 10);
  fill(220);
  text("Dancehall", 965, 304);

  // Anime soundtrack
  fill(139, 0, 0);
  circle(950, 330, 10);
  fill(220);
  text("Anime soundtrack", 965, 334);

  // Movie soundtrack
  fill(85, 184, 120);
  circle(950, 360, 10);
  fill(220);
  text("Movie soundtrack", 965, 364);

  // Hip-hop
  fill(48, 16, 68);
  circle(950, 390, 10);
  fill(220);
  text("Hip-hop", 965, 394);

  // Cloud rap
  fill(208, 208, 208);
  circle(950, 420, 10);
  fill(220);
  text("Cloud rap", 965, 424);
}
