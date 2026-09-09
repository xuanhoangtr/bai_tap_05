package vn.iotstar.service;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class ImageStorageService {

    private final Path uploadDirectory;

    public ImageStorageService(@Value("${app.upload.dir:uploads}") String uploadDirectory) {
        this.uploadDirectory = Paths.get(uploadDirectory).toAbsolutePath().normalize();
    }

    public String store(MultipartFile imageFile, String prefix) throws IOException {
        String extension = detectImageExtension(imageFile);
        if (extension == null) {
            throw new InvalidImageFileException("Tệp tải lên không phải ảnh JPG, PNG, GIF hoặc WEBP hợp lệ.");
        }

        Files.createDirectories(uploadDirectory);
        String storedFileName = prefix + "_" + UUID.randomUUID() + "." + extension;
        Path targetFile = uploadDirectory.resolve(storedFileName).normalize();
        if (!targetFile.startsWith(uploadDirectory)) {
            throw new IOException("Đường dẫn lưu ảnh không hợp lệ.");
        }

        try (InputStream inputStream = imageFile.getInputStream()) {
            Files.copy(inputStream, targetFile, StandardCopyOption.REPLACE_EXISTING);
        }
        return storedFileName;
    }

    private String detectImageExtension(MultipartFile imageFile) throws IOException {
        byte[] header = new byte[12];
        int bytesRead;
        try (InputStream inputStream = imageFile.getInputStream()) {
            bytesRead = inputStream.read(header);
        }
        if (bytesRead < 3) {
            return null;
        }
        if ((header[0] & 0xFF) == 0xFF && (header[1] & 0xFF) == 0xD8 && (header[2] & 0xFF) == 0xFF) {
            return "jpg";
        }
        if (bytesRead >= 8 && (header[0] & 0xFF) == 0x89 && header[1] == 0x50 && header[2] == 0x4E
                && header[3] == 0x47 && header[4] == 0x0D && header[5] == 0x0A && header[6] == 0x1A
                && header[7] == 0x0A) {
            return "png";
        }
        if (bytesRead >= 6 && header[0] == 'G' && header[1] == 'I' && header[2] == 'F'
                && header[3] == '8' && (header[4] == '7' || header[4] == '9') && header[5] == 'a') {
            return "gif";
        }
        if (bytesRead >= 12 && header[0] == 'R' && header[1] == 'I' && header[2] == 'F' && header[3] == 'F'
                && header[8] == 'W' && header[9] == 'E' && header[10] == 'B' && header[11] == 'P') {
            return "webp";
        }
        return null;
    }
}
