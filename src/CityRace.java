public class CityRace extends Race {
    public CityRace(float failRate) {
        this.failRate = failRate;
    }

    public CityRace() {
        this.failRate = .10f;
    }
}
