public class Main {
    public static void main(String[] args) {
        System.out.println("Starting...");

        AbstractFactory factory1 = new MountainFactory();
        Race race1 = factory1.createRace(10);
        Thread tr1 = new Thread(race1);
        tr1.start();

        //FIXME remove this line after tests
        try {Thread.sleep(1000); } catch (InterruptedException e) {e.printStackTrace();}

        AbstractFactory factory2 = new CityFactory();
        Race race2 = factory2.createRace(100);
        Thread tr2 = new Thread(race2);
        tr2.start();


        try {
            tr1.join();
        } catch (InterruptedException e) { e.printStackTrace(); }


        try {
            tr2.join();
        } catch (InterruptedException e) { e.printStackTrace(); }

        System.out.println("Done");


    }
}