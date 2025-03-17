public class MountainRace extends Race {

    public MountainRace(int racers) {
        this.failRate = .20f;
        this.racers = racers;
        this.time = 60;
    }

    public MountainRace(int racers, double failRate, int time) {
        this.failRate = failRate;
        this.racers = racers;
        this.time = time;
    }
}
