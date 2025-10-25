package service;
import java.util.Scanner;
import org.mindrot.jbcrypt.BCrypt;

public class BCryptInputExample {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        System.out.print("Nhập mật khẩu: ");
        String plainPassword = sc.nextLine();

        // Mã hóa bằng BCrypt
        String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));

        System.out.println("Mật khẩu đã mã hóa: " + hashedPassword);

        // Kiểm tra lại (ví dụ mô phỏng đăng nhập)
        System.out.print("Nhập lại mật khẩu để kiểm tra: ");
}
}

