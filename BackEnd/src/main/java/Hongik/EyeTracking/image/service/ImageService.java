package Hongik.EyeTracking.image.service;

import Hongik.EyeTracking.common.response.error.ErrorCode;
import Hongik.EyeTracking.common.response.error.exception.NotFoundException;
import Hongik.EyeTracking.image.domain.Image;
import Hongik.EyeTracking.image.repository.ImageRepository;
import Hongik.EyeTracking.user.domain.User;
import Hongik.EyeTracking.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class ImageService {
    private final ImageRepository imageRepository;
    private final UserRepository userRepository;

    private final String uploadDir = "uploads/";

    public Image createImage(String username, MultipartFile file) throws IOException {
        User user = userRepository.findByUsername(username).orElseThrow(() ->
                new NotFoundException(ErrorCode.USER_NOT_FOUND)
        );

        if (file.isEmpty()) {
            throw new IOException("Failed to store empty file.");
        }

        Path path = Paths.get(uploadDir + file.getOriginalFilename());
        Files.createDirectories(path.getParent());
        Files.write(path, file.getBytes());

        Image image = Image.builder()
                .fileName(file.getOriginalFilename())
                .filePath(path.toString())
                .user(user)
                .build();

        return imageRepository.save(image);
    }

    public void deleteImages(String username) {
        User user = userRepository.findByUsername(username).orElseThrow(() ->
                new NotFoundException(ErrorCode.USER_NOT_FOUND)
        );

        List<Image> images = imageRepository.findByUserId(user.getId());

        // 파일 시스템에서 이미지 제거
        for (Image image : images) {
            try {
                Path path = Paths.get(image.getFilePath());
                Files.deleteIfExists(path);
            } catch (IOException e) {
                // 로그를 출력하거나, 예외를 던질 수 있습니다.
                e.printStackTrace();
            }
        }

        imageRepository.deleteAll(images);
    }
}
