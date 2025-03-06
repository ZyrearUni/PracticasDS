public class MountainFactory implements AbstractFactory {
    @Override
    public Race createRace() {
        return new MountainRace();
    }
    @Override
    public Bicycle createBicycle() {
        return new MountainBicycle();
    }
}
