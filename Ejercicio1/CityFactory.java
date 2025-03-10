public class CityFactory implements AbstractFactory {
    
    private final double CITY_RETIRE = 0.1;
    
    @Override
    public Race createRace(int racers) {
        return new CityRace(CITY_RETIRE, racers);
    }
    @Override
    public Bicycle createBicycle() {
        return new CityBicycle();
    }
}
