public class CityFactory implements AbstractFactory {
    @Override
    public Race createRace() {
        return new CityRace();
    }
    @Override
    public Bicycle createBicycle() {
        return new CityBicycle();
    }
}
