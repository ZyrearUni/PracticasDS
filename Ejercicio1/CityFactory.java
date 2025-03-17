public class CityFactory implements AbstractFactory {

    @Override
    public Race createRace(int racers) {
        return new CityRace(racers);
    }
    @Override
    public Bicycle createBicycle() {
        return new CityBicycle();
    }
}
