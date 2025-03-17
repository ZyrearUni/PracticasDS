public class CityBicycle extends Bicycle {

    public CityBicycle() {
        this.id=idCounter;
        idCounter++; // TODO Fix concurrent access of common resource idCounter
    }
}
