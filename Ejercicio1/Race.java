import java.util.ArrayList;

public abstract class Race {
    protected double failRate;
    protected int time;
    protected int racers;
    protected ArrayList<Bicycle> bicycles;

    public void addBicycle (Bicycle bicycle) {
        bicycles.add(bicycle);
        racers++;
    }
}
