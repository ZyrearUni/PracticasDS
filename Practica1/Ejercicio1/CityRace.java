import java.util.ArrayList;

public class CityRace extends Race implements Runnable {

    public CityRace() {
        this(0.1,60000);
    }

    public CityRace(double failRate, int time) {
        this.failRate = failRate;
        this.time = time;
        bicycles = new ArrayList<Bicycle>();
    }

    @Override public void run() { // FIXME should run be implemented in Race and inherited?
        try {
            Thread.sleep(time/2);
        } catch (InterruptedException e) {
            System.out.println("CityRace thread interrupted in the first half of the race");
        }
        System.out.println("CityRace half-completed completed but some racers quit");
        int toKill = (int) Math.floor(racers*failRate);
        for (int i =0; i<toKill; i++) {
            boolean found;
            do { // remove one random alive bicycle (if already dead, remove another)
                found = false;
                int idToKill = (int) (Math.random() * bicycles.size());
                for (Bicycle b : bicycles) {
                    if (b.id==idToKill) {
                        if (b.alive==false) { break; }

                        b.alive=false;
                        found = true;
                        racers--;
                        break;
                    }
                }
            } while (!found);
        }
        System.out.println(toKill + " bicycles dropped out of the race");

        try {
            if (time%2==1)
                Thread.sleep(time/2+1);
            else
                Thread.sleep(time/2);
        } catch (InterruptedException e) {
            System.out.println("CityRace thread interrupted in the second half of the race");
        }
    }
}
