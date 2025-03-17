public class MountainBicycle extends Bicycle {
    public MountainBicycle() {
        this.id=idCounter;
        idCounter++; // TODO Fix concurrent access of common resource idCounter
    }
}
