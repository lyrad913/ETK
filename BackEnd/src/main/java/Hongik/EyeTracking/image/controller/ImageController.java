package Hongik.EyeTracking.image.controller;

import Hongik.EyeTracking.image.service.ImageService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/v1")
@RequiredArgsConstructor
public class ImageController {
    private final ImageService imageService;

    @PostMapping("/upload")
    public void uploadImage(@PathVariable String username, @RequestParam("file") MultipartFile file) {
        try{
            imageService.createImage(username, file);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
