public abstract class Race extends Thread {
    private double retired;
    private int racers;

    Race(double retired, int racers) {
        this.retired = retired;
        this.racers = racers;
    }
}
