public class CityFactory implements AbstractFactory {

    @Override
    public Race createRace(int racers) {
        Race race = new CityRace();
        for (int i=0; i<racers; i++) {
            race.addBicycle(createBicycle(i));
        }
        return race;
    }
    @Override
    public Bicycle createBicycle(int id) {
        return new CityBicycle(id);
    }
}
