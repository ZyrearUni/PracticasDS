

public class CityRace extends Race implements Runnable {

    public CityRace() {
        this.failRate = .10f;
        this.time = 60000;
    }

    public CityRace(double failRate, int time) {
        this.failRate = failRate;
        this.time = time;
    }

    @Override public void run() {
        try {
            Thread.sleep(time);
        } catch (InterruptedException e) {
            System.out.println("CityRace thread interrupted");
        }

    }
}
