public class MountainRace extends Race implements Runnable {

    public MountainRace(int racers) {
        this.failRate = .20f;
        this.racers = racers;
        this.time = 60000;
    }

    public MountainRace(int racers, double failRate, int time) {
        this.failRate = failRate;
        this.racers = racers;
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
