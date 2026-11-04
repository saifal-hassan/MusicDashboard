Table listeningData;
void setup () {
  size(1200,800);
  listeningData = loadTable("listening_data.csv", "header");
  println("Number of observations: " + listeningData.getRowCount());
  
}
  
