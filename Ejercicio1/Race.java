import java.util.ArrayList;

public abstract class Race implements Runnable {
    protected double failRate;
    protected int time;
    protected int racers; // racers is the number of alive racers (might be redundant)
    protected ArrayList<Bicycle> bicycles;

    public void addBicycle (Bicycle bicycle) {
        bicycles.add(bicycle);
        racers++;
    }

    public void killBicycleWithId(int id) {
        for (Bicycle b : bicycles) {
            if (b.id==id) {
                b.alive=false;
                racers--;
                break;
            }
        }
    }
}
