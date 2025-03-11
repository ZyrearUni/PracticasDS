public class MountainFactory implements AbstractFactory { 
    final double MOUNTAIN_RETIRE = 0.2;

    @Override
    public Race createRace(int racers) {
        return new MountainRace(MOUNTAIN_RETIRE, racers);
    }
    @Override
    public Bicycle createBicycle() {
        return new MountainBicycle();
    }
}
