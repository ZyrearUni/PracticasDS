public class MountainRace extends Race implements Runnable {

    public MountainRace() {
        this.failRate = .20f;
        this.time = 60000;
    }

    public MountainRace(double failRate, int time) {
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
