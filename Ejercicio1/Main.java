import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        System.out.println("¿Cuántos ciclistas hay?");

        Scanner scanner = new Scanner(System.in);
        int racers = scanner.nextInt();
        scanner.close();

        System.out.println("Hay " + racers + " corredores.");
    }
}