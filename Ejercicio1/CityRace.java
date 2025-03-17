public class CityRace extends Race {

    public CityRace(int racers) {
        this.failRate = .20f;
        this.racers = racers;
        this.time = 60;
    }


    public CityRace(int racers,double failRate, int time) {
        this.failRate = failRate;
        this.racers = racers;
        this.time = time;
    }
}
