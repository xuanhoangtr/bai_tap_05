package vn.iotstar.controller;

import java.io.FileInputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import jakarta.servlet.http.HttpServletResponse;

@Controller
public class ImageController {

    private final Path uploadLocation;
    private final Path legacyImageLocation = Paths.get("images").toAbsolutePath().normalize();

    public ImageController(@Value("${app.upload.dir:uploads}") String uploadDirectory) {
        this.uploadLocation = Paths.get(uploadDirectory).toAbsolutePath().normalize();
    }

    @GetMapping("/image")
    public void getImage(@RequestParam(value = "fname", defaultValue = "avatar.png") String fname, HttpServletResponse response) {
        try {
            Path file = safeResolve(uploadLocation, fname);
            if (file == null || !Files.isRegularFile(file)) {
                file = safeResolve(legacyImageLocation, fname);
            }

            if (file != null && Files.isRegularFile(file)) {
                String mimeType = Files.probeContentType(file);
                if (mimeType == null) {
                    mimeType = "image/png";
                }
                response.setContentType(mimeType);
                try (FileInputStream fis = new FileInputStream(file.toFile())) {
                    fis.transferTo(response.getOutputStream());
                }
            } else {
                // Tra ve SVG avatar mac dinh
                response.setContentType("image/svg+xml;charset=UTF-8");
                String defaultSvg = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'>" +
                                    "<circle cx='50' cy='50' r='50' fill='#0d6efd'/>" +
                                    "<circle cx='50' cy='38' r='18' fill='#ffffff'/>" +
                                    "<path d='M20,85 C20,65 35,58 50,58 C65,58 80,65 80,85 Z' fill='#ffffff'/>" +
                                    "</svg>";
                response.getWriter().write(defaultSvg);
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private Path safeResolve(Path baseDirectory, String fileName) {
        if (fileName == null || fileName.isBlank()) {
            return null;
        }
        Path resolved = baseDirectory.resolve(fileName).normalize();
        return resolved.startsWith(baseDirectory) ? resolved : null;
    }
}
