public class MountainRace extends Race {

    public MountainRace(float failRate) {
        this.failRate = failRate;
    }

    public MountainRace() {
        this.failRate = .20f;
    }
}
