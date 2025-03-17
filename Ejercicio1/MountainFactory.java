public class MountainFactory implements AbstractFactory { 

    @Override
    public Race createRace(int racers) {
        return new MountainRace(racers);
    }
    @Override
    public Bicycle createBicycle() {
        return new MountainBicycle();
    }
}
