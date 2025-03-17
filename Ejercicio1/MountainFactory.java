public class MountainFactory implements AbstractFactory {
    @Override
    public Race createRace(int racers) {
        Race race = new MountainRace();
        for (int i=0; i<racers; i++) {
            race.addBicycle(createBicycle(i));
        }
        return race;
    }
    @Override
    public Bicycle createBicycle(int id) {
        return new MountainBicycle(id);
    }
}
